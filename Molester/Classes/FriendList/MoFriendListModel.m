//
//  MoFriendListModel.m
//  Molester
//
//  Created by 高欣 on 2018/8/11.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoFriendListModel.h"

@interface MoFriendListModel ()<NSFetchedResultsControllerDelegate>

// 查询结果控制器
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;

@end



@implementation MoFriendListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fetchedResult];
    }
    return self;
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
    [self.fetchedResultController performFetch:nil];
    self.infoArr = self.fetchedResultController.fetchedObjects;
    return self.infoArr;
}


- (NSFetchedResultsController *)fetchedResultController
{
    if (_fetchedResultController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        [fetchRequest setEntity:entity];
        // 排序
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"jidStr"  ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
        _fetchedResultController.delegate = self;
    }
    return _fetchedResultController;
}


@end
