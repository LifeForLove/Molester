//
//  MoChatInputView.h
//  Molester
//
//  Created by 高欣 on 2018/8/13.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoChatInputViewDelegate <NSObject>

- (void)messageSend:(NSString *)content;

@end

@interface MoChatInputView : UIView

/**
 文字输入框
 */
@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,weak) id<MoChatInputViewDelegate> delegate;


@end
