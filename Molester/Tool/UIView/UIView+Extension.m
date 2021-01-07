//
//  UIView+Extension.m
//  Molester
//
//  Created by 高欣 on 2018/8/16.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)drawDashType:(DashLineType)lineType LineSize:(CGSize )lineSize lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
{
    self.frame = CGRectMake(0, 0, lineSize.width, lineSize.height);
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    if (lineType == DashLine_H) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) *0.5 , CGRectGetHeight(self.frame))];
        [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    }else
    {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame),
                                            CGRectGetHeight(self.frame) * 0.5)];
        [shapeLayer setLineWidth:CGRectGetWidth(self.frame)];
    }
    
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (lineType == DashLine_H) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(self.frame), 0);
    }else
    {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.frame));
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}
@end
