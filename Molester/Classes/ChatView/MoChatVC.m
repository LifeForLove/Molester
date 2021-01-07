//
//  MoChatVC.m
//  Molester
//
//  Created by 高欣 on 2018/8/11.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoChatVC.h"
#import "MoChatSendCell.h"
#import "MoChatReceiveCell.h"
#import "MoChatModel.h"
#import "MoChatInputView.h"

#import "XMPPUserCoreDataStorageObject.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"


static NSString * const MoSendMessageCellIdentifi  = @"MoSendMessageCellIdentifi";
static NSString * const MoReceiveMessageCellIdentifi  = @"MoReceiveMessageCellIdentifi";

@interface MoChatVC ()<UITableViewDelegate,UITableViewDataSource,MoChatInputViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) MoChatModel *model;

/**
 聊天输入模块
 */
@property (nonatomic,strong) MoChatInputView *chatInputView;

@end

@implementation MoChatVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"";
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = NO;
//}
//

#define ChatBottom_height 50

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SafeAreaNavHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(SafeAreaBarIncreaseHeight + ChatBottom_height));
    }];
    
    [self.view addSubview:self.chatInputView];
    [self.chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(ChatBottom_height);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
    
    self.model.bareJidStr = self.userCoreDataObj.jid.bare;
    
    @weakify(self);
    [RACObserve(self.model, infoArr) subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@" ===  infoArr ===");
        [self.tableView reloadData];
        if (self.model.infoArr.count == 0) return;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.model.infoArr.count - 1 inSection:0]atScrollPosition: UITableViewScrollPositionBottom animated:NO];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject * msg = self.model.infoArr[indexPath.row];
    if (msg.isOutgoing) {
        MoChatSendCell * cell = [tableView dequeueReusableCellWithIdentifier:MoSendMessageCellIdentifi];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentLabel.text = msg.body;
        return cell;
    }else
    {
        MoChatReceiveCell * cell = [tableView dequeueReusableCellWithIdentifier:MoReceiveMessageCellIdentifi];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentLabel.text = msg.body;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.infoArr.count;
}


/**
 点击了发送按钮

 @param content 消息内容
 */
- (void)messageSend:(NSString *)content
{
    [[MoXMPPManager shareManager] sendMessage:content chatJID:self.userCoreDataObj.jid];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //当点击了背景 结束当前编辑状态
    if (self.chatInputView.textView.isFirstResponder) {
        [self.chatInputView.textView resignFirstResponder];
    }
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView createTableView:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44.f;
        [_tableView registerClass:[MoChatSendCell class] forCellReuseIdentifier:MoSendMessageCellIdentifi];
        [_tableView registerClass:[MoChatReceiveCell class] forCellReuseIdentifier:MoReceiveMessageCellIdentifi];
    }
    return _tableView;
}

- (MoChatModel *)model
{
    if (_model == nil) {
        _model = [[MoChatModel alloc]init];
    }
    return _model;
}

- (MoChatInputView *)chatInputView
{
    if (_chatInputView == nil) {
        _chatInputView = [[MoChatInputView alloc]init];
        _chatInputView.delegate = self;
    }
    return _chatInputView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
