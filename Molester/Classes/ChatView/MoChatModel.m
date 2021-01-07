//
//  MoChatModel.m
//  Molester
//
//  Created by 高欣 on 2018/8/12.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoChatModel.h"


@interface MoChatModel ()<NSFetchedResultsControllerDelegate>

// 查询结果控制器
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;

@end


@implementation MoChatModel

- (void)setBareJidStr:(NSString *)bareJidStr
{
    _bareJidStr = bareJidStr;
    [self fetchedResult];
}


/**
 *  当数据库发生变化时,调用这个方法
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self fetchedResult];
}


/**
 从数据库中查询好友列表
 */
- (NSArray *)fetchedResult
{
    
    [self loadChatHistory];
    
    
    [self.fetchedResultController performFetch:nil];
    self.infoArr = self.fetchedResultController.fetchedObjects;
    return self.infoArr;
}

- (void)loadChatHistory
{
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = storage.mainThreadManagedObjectContext;
    NSLog(@"%@",moc);
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:storage.mainThreadManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor * sortD = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    [request setSortDescriptors:@[sortD]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"bareJidStr='%@'",self.bareJidStr]];
    [request setPredicate:predicate];
    
    NSFetchedResultsController * fetchResult = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:storage.mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];

    NSError * error;
    [fetchResult performFetch:&error];
    NSArray * arr = fetchResult.fetchedObjects;
    if (error) {
        NSLog(@"error = %@",error);
    }
    NSLog(@"%@",arr);
    
    
}



- (NSFetchedResultsController *)fetchedResultController
{
    if (_fetchedResultController == nil) {
        XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:storage.mainThreadManagedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", self.bareJidStr];
        [fetchRequest setPredicate:predicate];
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:storage.mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        _fetchedResultController.delegate = self;
    }
    return _fetchedResultController;
}



@end
