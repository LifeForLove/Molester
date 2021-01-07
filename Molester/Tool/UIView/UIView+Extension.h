//
//  UIView+Extension.h
//  Molester
//
//  Created by 高欣 on 2018/8/16.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DashLineType) {
    DashLine_H, //横线
    DashLine_V, //竖线
};

@interface UIView (Extension)


/**
 绘制横竖虚线

 @param lineType 虚线的方向
 @param lineSize 整个虚线的size
 @param lineLength 虚线的长度
 @param lineSpacing 虚线的间隔
 @param lineColor 虚线的颜色
 */
- (void)drawDashType:(DashLineType)lineType LineSize:(CGSize )lineSize lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
