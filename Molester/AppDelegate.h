//
//  AppDelegate.h
//  Molester
//
//  Created by 高欣 on 2018/8/8.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 网络状态
 */
@property (nonatomic,assign) AFNetworkReachabilityStatus networkStatus;

@end

