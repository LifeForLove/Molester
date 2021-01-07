//
//  MoFriendListCell.m
//  Molester
//
//  Created by 高欣 on 2018/8/11.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoFriendListCell.h"

@interface MoFriendListCell ()

@end

@implementation MoFriendListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    [self.contentView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(45);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.iconImg.mas_right).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}



- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel labelWithColor:Text_Black_Color font:TextTitleFont alignment:NSTextAlignmentLeft title:@""];
    }
    return _nameLabel;
}

- (UIImageView *)iconImg
{
    if (_iconImg == nil) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    }
    return _iconImg;
}


@end
