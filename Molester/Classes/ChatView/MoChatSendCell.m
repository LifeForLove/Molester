//
//  MoChatSendCell.m
//  Molester
//
//  Created by 高欣 on 2018/8/12.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoChatSendCell.h"

@interface MoChatSendCell ()

@property (nonatomic,strong) UIImageView * backgroundImageView;

@end

@implementation MoChatSendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.backgroundImageView];
    [self.contentView addSubview:self.contentLabel];
    
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(45);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImg.mas_left).offset(-20);
        make.top.equalTo(self.iconImg).offset(5);
        make.width.lessThanOrEqualTo(@(kScreenWidth - 45 - 15 - 20 - 20));
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel).offset(-5);
        make.left.equalTo(self.contentLabel).offset(-10);
        make.right.equalTo(self.contentLabel).offset(10);
        make.bottom.equalTo(self.contentLabel).offset(5);
    }];
}

- (UIImageView *)iconImg
{
    if (_iconImg == nil) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    }
    return _iconImg;
}


- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chat_msg_send"]];
        
    }
    return _backgroundImageView;
}

- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [UILabel labelWithColor:Text_Black_Color font:TextTitleFont alignment:NSTextAlignmentLeft title:@""];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}



@end
