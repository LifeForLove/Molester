//
//  MoUser+CoreDataProperties.h
//  
//
//  Created by 高欣 on 2018/8/9.
//
//

#import "MoUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MoUser (CoreDataProperties)

+ (NSFetchRequest<MoUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t userState;
@property (nullable, nonatomic, copy) NSString *accountNum;
@property (nullable, nonatomic, copy) NSString *password;
@end

NS_ASSUME_NONNULL_END
