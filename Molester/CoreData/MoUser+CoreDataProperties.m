//
//  MoUser+CoreDataProperties.m
//  
//
//  Created by 高欣 on 2018/8/9.
//
//

#import "MoUser+CoreDataProperties.h"

@implementation MoUser (CoreDataProperties)

+ (NSFetchRequest<MoUser *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"MoUser"];
}

@dynamic name;
@dynamic userState;
@dynamic accountNum;
@dynamic password;


@end
