//
//  MoFriendListNav.m
//  Molester
//
//  Created by 高欣 on 2018/8/8.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoFriendListNav.h"
#import "MoFriendListVC.h"
@interface MoFriendListNav ()

@end

@implementation MoFriendListNav

- (instancetype)init
{
    self = [super init];
    if (self) {
        MoFriendListVC * vc = [[MoFriendListVC alloc]init];
        [self pushViewController:vc animated:NO];
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
