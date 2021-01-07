//
//  MoUserManager.m
//  Molester
//
//  Created by 高欣 on 2018/8/9.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoUserManager.h"

static NSString * accountNumKey = @"MoUserCurrentUser";
@interface MoUserManager ()

/**
 当前用户账号
 */
@property (nonatomic,copy) NSString *currentUserAccount;

@property (nonatomic,strong)  NSManagedObjectContext *context;//coredata上下文


@end

@implementation MoUserManager

/**
 单例
 */
+(instancetype)sharedUserManager
{
    static MoUserManager *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[MoUserManager alloc]init];
    });
    return obj;
}

- (void)setCurrentUserAccount:(NSString *)currentUserAccount
{
    [[NSUserDefaults standardUserDefaults]setObject:currentUserAccount forKey:accountNumKey];
}


- (NSString *)currentUserAccount
{
    NSString * accountNum = [[NSUserDefaults standardUserDefaults]objectForKey:accountNumKey];
    if (!accountNum) {
        [[NSUserDefaults standardUserDefaults]setObject:@"000000" forKey:accountNumKey];
    }
    return [[NSUserDefaults standardUserDefaults]objectForKey:accountNumKey];
}

- (void)insert:( void (^) (MoUser *))userBlock
{
    if (!userBlock) return;
    if ([self userSaved]) {
        NSLog(@"数据库已有此用户");
        return;
    }
    
    MoUser *users = [NSEntityDescription insertNewObjectForEntityForName:@"MoUser" inManagedObjectContext:self.context];
    userBlock(users);
    
    NSError *error = nil;
    BOOL success = NO;
    if (self.context.hasChanges) {
        success = [self.context save:&error];
    }
    
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        
    }else
    {
        NSLog(@"插入成功");
    }
    
}

- (BOOL)change:(void (^)(MoUser *))userBlock
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MoUser"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountNum=%@", self.currentUserAccount];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray<MoUser *> *users = [self.context executeFetchRequest:request error:&error];
    
    if (users.count == 0) {
        [self initializeSTUser];
        NSLog(@"数据库中无用户");
    }else
    {
        MoUser * user = users.firstObject;
        if (userBlock) {
            userBlock(user);
            self.currentUserAccount = user.accountNum;
        }
    }
    
    if (self.context.hasChanges) {
       return [self.context save:nil];
    }
    if (error) {
        NSLog(@"CoreData Update Data Error : %@", error);
    }
    return NO;
}


/**
 删除当前用户

 @return 删除成功/失败
 */
- (BOOL)deleteUser
{
    //删除之前首先需要用到查询
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; //创建请求
    
    request.entity = [NSEntityDescription entityForName:@"MoUser" inManagedObjectContext:self.context];//找到我们的Person
    
    NSError *error = nil;
    NSArray *objs = [self.context executeFetchRequest:request error:&error];//执行我们的请求
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];//抛出异常
    }
    // 遍历数据
    for (MoUser *obj in objs) {
        NSLog(@"userState = %@", [obj valueForKey:@"userState"]); //打印符合条件的数据
        NSLog(@"accountNum = %@", [obj valueForKey:@"accountNum"]); //打印符合条件的数据
        [self.context deleteObject:obj];
    }
    
    BOOL success = [self.context save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }else
    {
        NSLog(@"删除成功，sqlite");
    }
    return success;
}

- (void)loginOut:(void(^)(void))success fail:(void(^)(void))fail
{
    // 请求退出登录接口
    
    
    /*
     退出接口请求成功之后
     1 清除用户信息
     2 发送通知 退到根视图刷新界面
     */
    NSLog(@"退出登录成功");
    if ([self deleteUser]) {
        [MoNotificationCenter postNotificationName:MoSwitchRootViewControllerNotification object:nil userInfo:@{MoSwitchRootViewControllerUserInfoKey:@(MoUserState_LogOut)}];
        // 成功执行成功的回调
        if (success) {
            success();
        }        
    }
    
    
    
    // 失败执行失败的回调
    //    if (fail) {
    //        fail();
    //    }
    //
}


/**
 判断数据库是否有用户
 */
- (BOOL)userSaved
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MoUser"];
    NSError *error = nil;
    NSArray<MoUser *> *users = [self.context executeFetchRequest:request error:&error];
    NSLog(@"accountNum  %@",users.firstObject.accountNum);
    if (users.count > 0) {
        return YES;
    }
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
    return NO;
}



/**
 初始化当前用户
 */
- (MoUser *)initializeSTUser
{
    //插入前先清空数据库
    __block MoUser * obj = nil;
    
    if ([self deleteUser]) {
        //如果删除成功
        self.currentUserAccount = @"000000";
        //插入一个新的用户
        [self insert:^(MoUser *user) {
            //初始化
            user.accountNum = self.currentUserAccount;
            user.userState = 0;
            user.name = @"";
            user.password = @"";
            obj = user;
        }];
    }
    return obj;
}

- (MoUser *)currentUser
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MoUser"];
    NSError *error = nil;
    NSArray<MoUser *> *users = [self.context executeFetchRequest:request error:&error];
    if (users.count == 0) {
        return [self initializeSTUser];
    }else
    {
        for (MoUser * user in users) {
            if ([user.accountNum isEqualToString:self.currentUserAccount]) {
                return user;
            }
        }
    }
    
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
    
    //创建一个新的用户
    return [self initializeSTUser];
}


- (NSManagedObjectContext *)context
{
    if (_context == nil) {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"MoUser" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSError *error = nil;
        dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"MoUser"];
        
        NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL: [NSURL fileURLWithPath:dataPath] options:nil error:&error];
        if (store == nil) { // 直接抛异常
            [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        }
        _context.persistentStoreCoordinator = coordinator;
        NSLog(@"%@",NSHomeDirectory());//数据库会存在沙盒目录的Documents文件夹下
    }
    return _context;
}



@end
