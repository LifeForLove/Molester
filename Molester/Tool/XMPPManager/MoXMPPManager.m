//
//  MoXMPPManager.m
//  Molester
//
//  Created by 高欣 on 2018/8/9.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoXMPPManager.h"
#import "XMPPAutoPing.h"
#import "XMPPReconnect.h"
#import "CocoaLumberjack.h"
#import "XMPPLogging.h"

//联系人
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"

//聊天记录
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"



@interface MoXMPPManager()<XMPPStreamDelegate,XMPPAutoPingDelegate>

/**
 新桃检测模块
 */
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;

/**
 自动重连模块
 */
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;

/**
 联系人
 */
@property (nonatomic,strong) XMPPRoster *xmppRoster;

/**
 聊天记录
 */
@property (nonatomic,strong) XMPPMessageArchiving *xmppMessageArchiving;

/**
 xml流
 */
@property(strong,nonatomic) XMPPStream *xmppStream;

/**
 用户名
 */
@property (nonatomic,copy) NSString *userName;

/**
 密码
 */
@property (nonatomic,copy) NSString *password;

@end

@implementation MoXMPPManager

+ (instancetype)shareManager
{
    static MoXMPPManager * obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[MoXMPPManager alloc]init];
        // 开启一个模块
        [obj setupLogging];
        [obj setupModule];
    });
    return obj;
}

// 开启控制台日志功能
- (void)setupLogging
{
    // 开启插件
    setenv("XcodeColors", "YES", 0);
    
    // Standard lumberjack initialization
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:XMPP_LOG_FLAG_SEND_RECV];
    
    // Standard lumberjack initialization
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // And then enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    // 设置日志颜色
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:XMPP_LOG_FLAG_SEND];
    
//     设置日志颜色
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:XMPP_LOG_FLAG_RECV_POST];
    
}


//  模块的操作
- (void)setupModule
{
    // 模块创建的规律: 创建模块对象---> 设置属性---> (设置代理,监听状态) ---> 激活
    // 心跳检测模块
    // 设置心跳检测模块的属性
    // 发包间隔
    self.xmppAutoPing.pingInterval = 20.0;
    // 超时时长
    self.xmppAutoPing.pingTimeout = 20;
    // 是否响应服务器发来的心跳检测包
    self.xmppAutoPing.respondsToQueries = YES;
    
    // 设置代理,监听心跳检测模块的状况
    [self.xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 激活当前模块
    [self.xmppAutoPing activate:self.xmppStream];

    // 自动重连模块
    [self.xmppReconnect activate:self.xmppStream];
    
    // 自动接收一个订阅请求
    self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = NO;
    [self.xmppRoster activate:self.xmppStream];
    
    // 消息模块
    [self.xmppMessageArchiving activate:self.xmppStream];
    
    
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)pwd loginType:(LoginType)loginType
{
    self.loginType = loginType;
    self.userName = userName;
    self.password = pwd;
    NSLog(@"====%@====",loginType == LoginType_login ? @"登录" : @"注册");
    self.xmppStream.myJID = [XMPPJID jidWithUser:userName domain:@"115.29.55.141" resource:@"iOS"];
    self.xmppStream.hostName = @"115.29.55.141";
    self.xmppStream.hostPort = 5222;
    
    //先连接
    BOOL success = [self.xmppStream connectWithTimeout:-1 error:nil];
    if (!success) {
        NSLog(@"连接失败");
    }
    
}

/**
 *  一旦连接成功,就会调用这个代理方法
 *
 *  @param sender xml流
 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接成功");
    if (self.loginType == LoginType_login) {
        // 登录
        BOOL success = [self.xmppStream authenticateWithPassword:self.password error:nil];
        if (!success) {
            NSLog(@"登录失败");
            if ([self.delegate respondsToSelector:@selector(loginResult:type:)]) {
                [self.delegate loginResult:404 type:LoginType_login];
            }
        }
    } else {
        // 注册
        BOOL success =  [self.xmppStream registerWithPassword:self.password error:nil];
        if (!success) {
            NSLog(@"注册失败");
            if ([self.delegate respondsToSelector:@selector(loginResult:type:)]) {
                [self.delegate loginResult:404 type:LoginType_regist];
            }
        }
    }
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    NSLog(@"========= willConnect ========");
}


- (void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error
{
    NSLog(@"error %@",error);
}


- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    BOOL success = [self.xmppStream authenticateWithPassword:self.password error:nil];
    if (success) {
        if ([self.delegate respondsToSelector:@selector(loginResult:type:)]) {
            [self.delegate loginResult:404 type:LoginType_login];
        }
    }else
    {
        NSLog(@"登录链接失败");
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册失败%@",error);
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"======登录失败 %@======",error);
}


/**
 *  登录成功之后调用的方法
 *
 *  @param sender xml流
 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"登录成功");
    // 设置当前用户的状态
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
    
    //登录成功保存到数据库
    BOOL result = [UserManager change:^(MoUser *user) {
        user.userState = 1;
        user.accountNum = self.userName;
        user.password = self.password;
    }];
    if (result && [self.delegate respondsToSelector:@selector(loginResult:type:)]) {
        [self.delegate loginResult:200 type:LoginType_login];
    }
    
}

/**
 *  接收到订阅请求后调用的方法
 *  @param presence 谁发送的订阅请求
 */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ask = 'subscribe'"];
    [fetchRequest setPredicate:predicate];
    
    // 分区"我加对方为好友" 还是 "对方加我为好友"
    NSArray *fetchObjects = [[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (XMPPUserCoreDataStorageObject *contact in fetchObjects) {
        if ([contact.jidStr isEqualToString:presence.from.bare]) {
            // 我加别人
            // 如果是"我加别人",直接同意
            [self.xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加好友" message:[NSString stringWithFormat:@"%@接收我的好友请求",contact.jidStr] preferredStyle:UIAlertControllerStyleAlert];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertController dismissViewControllerAnimated:YES completion:nil];
            });
        }
        return;
    }
    
    // 别人加我
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加好友" message:[NSString stringWithFormat:@"%@想添加你为好友",presence.from.bare] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 同意
        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 不同意
        [self.xmppRoster rejectPresenceSubscriptionRequestFrom:presence.from];
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}


/**
 发送消息

 @param content 消息内容
 */
- (void)sendMessage:(NSString *)content chatJID:(XMPPJID *)chatJID
{
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:chatJID];
    [message addBody:content];
    [self.xmppStream sendElement:message];
}


- (XMPPStream *)xmppStream
{
    if (_xmppStream == nil) {
        _xmppStream = [[XMPPStream alloc] init];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppStream;
}

- (XMPPAutoPing *)xmppAutoPing
{
    if (_xmppAutoPing == nil) {
        _xmppAutoPing = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    }
    return _xmppAutoPing;
}

- (XMPPReconnect *)xmppReconnect
{
    if (_xmppReconnect == nil) {
        _xmppReconnect = [[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    }
    return _xmppReconnect;
}

- (XMPPRoster *)xmppRoster
{
    if (_xmppRoster == nil) {
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:[XMPPRosterCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_main_queue()];
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppRoster;
}

- (XMPPMessageArchiving *)xmppMessageArchiving
{
    if (_xmppMessageArchiving == nil) {
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:[XMPPMessageArchivingCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_main_queue()];
    }
    return _xmppMessageArchiving;
}

@end
