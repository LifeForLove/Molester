//
//  AppDelegate.m
//  Molester
//
//  Created by 高欣 on 2018/8/8.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "AppDelegate.h"
#import "MoMainTab.h"
@interface AppDelegate ()<MoXMPPManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化配置
    [self initializeConfig];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = Background_Color;
    //选择进入的根视图
    [self chooseViewController];
    [self.window makeKeyAndVisible];
    //在初始化UI之后配置
    [self configureApplication:application initialParamsAfterInitUI:launchOptions];
    return YES;
}


- (void)netWorkState
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    @weakify(self);
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        self.networkStatus = status;
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
        }
    }];
    //开始监控
    [manager startMonitoring];
}


/**
 初始化配置
 */
- (void)initializeConfig
{
    //bug管理
    [Bugly startWithAppId:BuglyAppID];
    //监测网络状态
    [self netWorkState];
}

#pragma mark - 在初始化UI之后配置
- (void)configureApplication:(UIApplication *)application initialParamsAfterInitUI:(NSDictionary *)launchOptions
{
    // 监听切换根视图的通知
    @weakify(self);
    [[MoNotificationCenter rac_addObserverForName:MoSwitchRootViewControllerNotification object:nil]subscribeNext:^(NSNotification * note) {
        @strongify(self);
        MouserStateType rootType = [note.userInfo[MoSwitchRootViewControllerUserInfoKey] integerValue];
        [self switchRootViewControllerWithType:rootType];
    }];
    
    //FPS 检测
#ifdef DEBUG
    [[JPFPSStatus sharedInstance] open];
#else
    //do sth.
#endif
}


/**
 设置根视图
 
 @param rootType 根视图的类型
 */
- (void)switchRootViewControllerWithType:(MouserStateType)rootType
{
    switch (rootType) {
        case MoUserState_Login:
        {
            MoMainTab *mainvc = [[MoMainTab alloc] init];
            self.window.rootViewController = mainvc;
        }
            break;
        case MoUserState_LogOut:
        {
            MoLoginView *loginVC = [[MoLoginView alloc] init];
            self.window.rootViewController = loginVC;
        }
            break;
        default:
            break;
    }
}


/**
 选择要进入的控制器
 */
- (void)chooseViewController
{
    
    switch (CurrentUser.userState) {
        case MoUserState_LogOut:
            [self switchRootViewControllerWithType:MoUserState_LogOut];
            break;
        case MoUserState_Login:
            //登录当前账户
        {
            MoXMPPManager * xmppManager = [MoXMPPManager shareManager];
            xmppManager.delegate = self;
            [xmppManager loginWithUserName:CurrentUser.accountNum password:CurrentUser.password loginType:LoginType_login];
            [self switchRootViewControllerWithType:MoUserState_Login];
        }
            break;
        default:
            break;
    }
}


/**
 MoXMPPManager delegate 的回调

 @param code code码
 @param loginType 登录/注册
 */
- (void)loginResult:(NSInteger)code type:(LoginType)loginType
{
    NSLog(@"数据库中有用户,启动成功后自动连接服务器");
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
