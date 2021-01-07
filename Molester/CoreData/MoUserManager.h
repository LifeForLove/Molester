//
//  MoUserManager.h
//  Molester
//
//  Created by 高欣 on 2018/8/9.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserManager [MoUserManager sharedUserManager]
#define CurrentUser UserManager.currentUser


@interface MoUserManager : NSObject

/**
 单例
 */
+(instancetype)sharedUserManager;

/**
 改
 */
- (BOOL)change:(void (^) (MoUser * user))userBlock;

/**
 查
 */
- (MoUser *)currentUser;

/**
 退出登录
 */
- (void)loginOut:(void(^)(void))success fail:(void(^)(void))fail;


@end
