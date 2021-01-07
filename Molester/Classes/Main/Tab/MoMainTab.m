//
//  MoMainTab.m
//  Molester
//
//  Created by 高欣 on 2018/8/8.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoMainTab.h"
#import "MoRecentNav.h"
#import "MoFriendListNav.h"
#import "MoMeNav.h"

@interface MoMainTab ()


/**
 最近聊天列表
 */
@property (nonatomic,strong) MoRecentNav *recentNav;

/**
 好友列表
 */
@property (nonatomic,strong) MoFriendListNav *friendListNav;

/**
 我的
 */
@property (nonatomic,strong) MoMeNav *meNav;

@end

@implementation MoMainTab


- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayMainViewControllers];
}

- (void)displayMainViewControllers
{
    //tabbar 去掉顶部的线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    [[UITabBar appearance] setBackgroundColor:White_Color];
    
    //设置导航条样式
    //nav 文字颜色
    [[UINavigationBar appearance] setTintColor:White_Color];
    
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = TextNavTitleFont;
    att[NSForegroundColorAttributeName] = White_Color;
    //设置标题样式
    [[UINavigationBar appearance] setTitleTextAttributes:att];
    
    //去掉顶部黑线
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage createImageWithColor:Main_Color] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:YES];
    
    self.recentNav = [[MoRecentNav alloc] init];
    self.recentNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"趣撩" image:[[UIImage imageNamed:@"tab_recent_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_recent_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.recentNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Main_Color ,NSFontAttributeName:TabbarTextFont} forState:UIControlStateSelected];
    [self.recentNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Text_Gary_Color,NSFontAttributeName:TabbarTextFont} forState:UIControlStateNormal];
    
    self.friendListNav = [[MoFriendListNav alloc]init];
    self.friendListNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"通讯录" image:[[UIImage imageNamed:@"tab_friendlist_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_friendlist_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.friendListNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Main_Color ,NSFontAttributeName:TabbarTextFont} forState:UIControlStateSelected];
    [self.friendListNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Text_Gary_Color,NSFontAttributeName:TabbarTextFont} forState:UIControlStateNormal];
    
    
    self.meNav = [[MoMeNav alloc]init];
    self.meNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[[UIImage imageNamed:@"tab_me_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_me_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.meNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Text_Gary_Color,NSFontAttributeName:TabbarTextFont} forState:UIControlStateNormal];
    [self.meNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Main_Color,NSFontAttributeName:TabbarTextFont} forState:UIControlStateSelected];
    self.viewControllers = @[self.recentNav,self.friendListNav,self.meNav];
    
}
@end
