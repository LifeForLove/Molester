//
//  MoXMPPManager.h
//  Molester
//
//  Created by 高欣 on 2018/8/9.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    LoginType_login,
    LoginType_regist,
} LoginType;

@protocol MoXMPPManagerDelegate <NSObject>

@required;
/**
 登录/注册结果的回调

 @param code 状态码
 @param loginType 判断是登录还是注册
 */
- (void)loginResult:(NSInteger)code type:(LoginType)loginType;

@end

@interface MoXMPPManager : NSObject

/**
 登录/注册
 */
@property (nonatomic,assign) LoginType loginType;

+ (instancetype)shareManager;

@property (nonatomic,weak) id<MoXMPPManagerDelegate> delegate;


/**
 登录/注册
 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)pwd loginType:(LoginType)loginType;

/**
 发送消息

 @param content 消息内容
 */
- (void)sendMessage:(NSString *)content chatJID:(XMPPJID *)chatJID;

@end
