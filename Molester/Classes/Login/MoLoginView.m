//
//  MoLoginView.m
//  Molester
//
//  Created by 高欣 on 2018/8/9.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoLoginView.h"
#import "MoBaseVC.h"
@interface MoLoginVC :MoBaseVC

/**
 背景scrollView
 */
@property (nonatomic,strong) UIScrollView *scrollView;

/**
 账号
 */
@property (nonatomic,strong) UITextField *nameT;

/**
 密码
 */
@property (nonatomic,strong) UITextField *pwdT;

/**
 登录按钮
 */
@property (nonatomic,strong) UIButton *loginBtn;


/**
 注册按钮
 */
@property (nonatomic,strong) UIButton *registBtn;

/**
 登录信号
 */
@property (nonatomic,strong) RACSubject *loginSingle;

@end

@interface MoLoginView ()<MoXMPPManagerDelegate>
@end

@implementation MoLoginView

- (void)viewDidLoad {
    [super viewDidLoad];
    MoLoginVC * vc = [[MoLoginVC alloc]init];

    @weakify(self);
    [[vc.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton * x){
        @strongify(self);
        NSLog(@"开始登录");
        [ELLoadingView show];
        [self loginAction:vc.nameT.text password:vc.pwdT.text loginType:LoginType_login];
    }];
    
    [[vc.registBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton * x) {
        @strongify(self);
        NSLog(@"注册");
        [ELLoadingView show];
        [self loginAction:vc.nameT.text password:vc.pwdT.text loginType:LoginType_regist];
    }];
    [self pushViewController:vc animated:NO];
    
}


/**
 登录/注册
 */
- (void)loginAction:(NSString *)userName password:(NSString *)pwd loginType:(LoginType)loginType
{
    MoXMPPManager * xmppManager = [MoXMPPManager shareManager];
    xmppManager.delegate = self;
    [xmppManager loginWithUserName:userName password:pwd loginType:loginType];
}

/**
 登录注册结果回调

 @param code code
 @param loginType 登录/注册方式
 */
- (void)loginResult:(NSInteger)code type:(LoginType)loginType
{
    [ELLoadingView dismiss];
    if (loginType == LoginType_login) {
        //发送切换根视图的通知
        if (code == 200) {
            [MoNotificationCenter postNotificationName:MoSwitchRootViewControllerNotification object:nil userInfo:@{MoSwitchRootViewControllerUserInfoKey:@(MoUserState_Login)}];
        }
    }else
    {
        //注册的回调
    }
}



+ (void)show:(resultBlock)result
{
    MoLoginView * nav = [[MoLoginView alloc]init];
    if (result) {
        nav.result = result;
    }
    [[UIViewController currentTopVC] presentViewController:nav animated:YES completion:nil];
}

@end

@implementation MoLoginVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UINavigationBar appearance] setTintColor:White_Color];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage createImageWithColor:Main_Color] forBarMetrics:UIBarMetricsDefault];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    @weakify(self);
    [[RACSignal combineLatest:@[[self.nameT rac_textSignal],[self.pwdT rac_textSignal]] reduce:^id(NSString * name , NSString * pwd){
        return @(name.length >= 2 && pwd.length >= 6);
    }]subscribeNext:^(NSNumber * x) {
        @strongify(self);
        self.loginBtn.enabled = [x boolValue];
        self.registBtn.enabled = [x boolValue];
    }];
    
}


- (void)createView
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.nameT];
    [self.scrollView addSubview:self.pwdT];
    [self.scrollView addSubview:self.loginBtn];
    [self.scrollView addSubview:self.registBtn];
    
    //重新设置导航栏的样式
    //nav 文字颜色
    [[UINavigationBar appearance] setTintColor:Main_Color];
    //导航栏的颜色
    [[UINavigationBar appearance]setBackgroundImage:[UIImage createImageWithColor:self.view.backgroundColor] forBarMetrics:UIBarMetricsDefault];
    
    [self.nameT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SafeAreaNavHeight + 60);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(50);
    }];
    
    [self.pwdT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameT.mas_bottom).offset(40);
        make.left.right.equalTo(self.nameT);
        make.height.equalTo(self.nameT);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameT);
        make.top.equalTo(self.pwdT.mas_bottom).offset(90);
        make.height.equalTo(self.nameT);;
    }];
    
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameT);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(30);
        make.height.equalTo(self.nameT);;
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.registBtn.mas_bottom).offset(150);
    }];
    
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
}

- (UITextField *)nameT
{
    if (_nameT == nil) {
        _nameT = [[UITextField alloc]init];
        _nameT.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        _nameT.keyboardType = UIKeyboardTypeASCIICapable;
        _nameT.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameT.maxCount = 15;
    }
    return _nameT;
}

- (UITextField *)pwdT
{
    if (_pwdT == nil) {
        _pwdT = [[UITextField alloc]init];
        _pwdT.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        _pwdT.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdT.secureTextEntry = YES;
        _pwdT.maxCount = 15;
    }
    return _pwdT;
}

- (UIButton *)loginBtn
{
    if (_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithTextColor:White_Color font:TextTitleFont backgroundNormalColor:Main_Color backgroundDisableColor:Text_DHS_Color];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}

- (UIButton *)registBtn
{
    if (_registBtn == nil) {
        _registBtn = [UIButton buttonWithTextColor:White_Color font:TextTitleFont backgroundNormalColor:Main_Color backgroundDisableColor:Text_DHS_Color];
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registBtn.enabled = NO;
    }
    return _registBtn;
}


@end
