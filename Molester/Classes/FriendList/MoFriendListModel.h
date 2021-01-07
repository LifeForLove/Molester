//
//  MoFriendListModel.h
//  Molester
//
//  Created by 高欣 on 2018/8/11.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPRosterCoreDataStorage.h"

@interface MoFriendListModel : NSObject

@property (nonatomic,strong) NSArray<XMPPUserCoreDataStorageObject *> *infoArr;

@end
