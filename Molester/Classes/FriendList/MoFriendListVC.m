//
//  MoFriendListVC.m
//  Molester
//
//  Created by 高欣 on 2018/8/8.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoFriendListVC.h"
#import "MoFriendListCell.h"
#import "MoFriendListModel.h"
#import "MoChatVC.h"
static NSString * const MoFriendListCellIdentifi  = @"MoFriendListCellIdentifi";

@interface MoFriendListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) MoFriendListModel *model;

@end

@implementation MoFriendListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SafeAreaNavHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SafeAreaBarIncreaseHeight);
    }];
    
    @weakify(self);
    self.tableView.mj_header = [GXRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
    [RACObserve(self.model, infoArr) subscribeNext:^(id x) {
        [self.tableView reloadData];
        if (self.model.infoArr.count == 0) return;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.model.infoArr.count - 1 inSection:0]atScrollPosition: UITableViewScrollPositionBottom animated:NO];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoFriendListCell * cell = [tableView dequeueReusableCellWithIdentifier:MoFriendListCellIdentifi];
    cell.nameLabel.text = self.model.infoArr[indexPath.row].jidStr;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MoChatVC * vc = [[MoChatVC alloc]init];
    vc.userCoreDataObj = self.model.infoArr[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.infoArr.count;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView createTableView:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        [self.tableView registerClass:[MoFriendListCell class] forCellReuseIdentifier:MoFriendListCellIdentifi];
    }
    return _tableView;
}

- (MoFriendListModel *)model
{
    if (_model == nil) {
        _model = [[MoFriendListModel alloc]init];
    }
    return _model;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
