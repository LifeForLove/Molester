//
//  MoUser+CoreDataClass.m
//  
//
//  Created by 高欣 on 2018/8/9.
//
//

#import "MoUser+CoreDataClass.h"

@interface MoUser ()//<NSCopying,NSMutableCopying>

@end

@implementation MoUser

//- (id)copyWithZone:(NSZone*)zone
//{
//    MoUser* model = [[MoUser allocWithZone:zone]init];
//
//    unsigned int outCount = 0;
//
//    Ivar* ivars =class_copyIvarList([self class], &outCount);
//
//    for(int i =0; i < outCount; i++)
//
//    {
//        Ivar ivar = ivars[i];
//        id obj =object_getIvar(self, ivar);
//        object_setIvar(model, ivar, obj);
//    }
//
//    free(ivars);
//    return model;
//}
//
//- (id)mutableCopyWithZone:(NSZone *)zone
//{
//    MoUser* model = [[MoUser allocWithZone:zone]init];
//
//    unsigned int outCount = 0;
//
//    Ivar* ivars = class_copyIvarList([self class], &outCount);
//
//    for(int i =0; i < outCount; i++)
//
//    {
//        Ivar ivar = ivars[i];
//        id obj =object_getIvar(self, ivar);
//        object_setIvar(model, ivar, obj);
//    }
//
//    free(ivars);
//    return model;
//}


@end
