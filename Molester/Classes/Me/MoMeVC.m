//
//  MoMeVC.m
//  Molester
//
//  Created by 高欣 on 2018/8/8.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoMeVC.h"
#import "HMShareView.h"

@interface MoMeVC ()

@end

@implementation MoMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * loginoutBtn = [UIButton buttonWithTextColor:White_Color font:TextTitleFont backgroundNormalColor:Main_Color backgroundDisableColor:Line_DHS_Color];
    [loginoutBtn setTitle:@"退出登录" forState:0];
    [[loginoutBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton * sender) {
        sender.enabled = NO;
        [self loginOut:^{
            sender.enabled = YES;
        }];
    }];
    [self.view addSubview:loginoutBtn];
    [loginoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 45));
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HMShareView * share = [[HMShareView alloc]init];
    [share show];
}


- (void)loginOut:(void (^) (void))result
{
    [UserManager loginOut:^{
        result();
    } fail:^{
        result();
    }];
}



@end
