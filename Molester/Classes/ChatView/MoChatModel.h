//
//  MoChatModel.h
//  Molester
//
//  Created by 高欣 on 2018/8/12.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPMessageArchivingCoreDataStorage.h"
@interface MoChatModel : NSObject

@property (nonatomic,strong) NSArray<XMPPMessageArchiving_Message_CoreDataObject *> *infoArr;

/**
 该用户的bareJid
 */
@property (nonatomic,copy) NSString *bareJidStr;

@end
