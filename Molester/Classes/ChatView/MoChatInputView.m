//
//  MoChatInputView.m
//  Molester
//
//  Created by 高欣 on 2018/8/13.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "MoChatInputView.h"

@interface MoChatInputView()<UITextViewDelegate>

@property (nonatomic,strong) UIButton *voiceBtn;

@end

@implementation MoChatInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    [self addSubview:self.voiceBtn];
    [self addSubview:self.textView];
    
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(35);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceBtn.mas_right).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(35);
        make.centerY.equalTo(self);
    }];
    
    //设置输入的文字长度限制
#define MAX_DETAIL_NUM  20
    [[MoNotificationCenter rac_addObserverForName:UITextViewTextDidChangeNotification object:nil]subscribeNext:^(NSNotification * noti) {
        UITextView * textView = noti.object;
        textView.enablesReturnKeyAutomatically = !textView.text.length;
        if (textView.text.length > MAX_DETAIL_NUM && textView.markedTextRange == nil)
        {
            textView.text = [textView.text substringToIndex:MAX_DETAIL_NUM];
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        NSLog(@"发送消息");
        if ([self.delegate respondsToSelector:@selector(messageSend:)]) {
            [self.delegate messageSend:self.textView.text];
        }
        textView.text = @"";
        return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (UIButton *)voiceBtn
{
    if (_voiceBtn == nil) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
    }
    return _voiceBtn;
}

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc]init];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.font = TextTitleFont;
        _textView.enablesReturnKeyAutomatically = !_textView.text.length;
    }
    return _textView;
}



@end
