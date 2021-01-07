//
//  MoMeNav.m
//  Molester
//
//  Created by 高欣 on 2018/8/8.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoMeNav.h"
#import "MoMeVC.h"
@interface MoMeNav ()

@end

@implementation MoMeNav

- (instancetype)init
{
    self = [super init];
    if (self) {
        MoMeVC * vc = [[MoMeVC alloc]init];
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
