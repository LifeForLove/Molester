//
//  MoLoginView.h
//  Molester
//
//  Created by 高欣 on 2018/8/9.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MOBaseNav.h"

typedef void(^resultBlock)(NSInteger code);

@interface MoLoginView : MOBaseNav

@property (nonatomic,copy) resultBlock result;

/**
 展示登录界面
 
 @param result 回调登录结果
 */
+ (void)show:(resultBlock)result;

@end
