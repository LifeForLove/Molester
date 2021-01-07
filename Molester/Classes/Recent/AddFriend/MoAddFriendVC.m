//
//  MoAddFriendVC.m
//  Molester
//
//  Created by 高欣 on 2018/8/13.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoAddFriendVC.h"

static NSString * const MoAddFriendCellIdentifi  = @"MoFriendListCellIdentifi";

@interface MoAddFriendVC ()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MoAddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加朋友";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
 
    
    
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView createTableView:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MoAddFriendCellIdentifi];
    }
    return _tableView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
