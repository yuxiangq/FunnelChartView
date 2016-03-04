//
//  FunnelChartSliderButton.m
//  FunnelChartViewDemo
//
//  Created by Qin Yuxiang on 2/28/16.
//  Copyright © 2016 YuxiangQ. All rights reserved.
//

#import "FunnelChartSliderButton.h"

static const CGFloat kWidth = 40.f;
@implementation FunnelChartSliderButton

- (void)drawRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGPoint pA = {width - kWidth, 0};
    CGPoint pB = {width, 0};
    CGPoint pC = {width, height};
    CGPoint pD = {width - kWidth, height};
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,pA.x,pA.y);
    CGContextAddLineToPoint(context,pB.x, pB.y);
    CGContextAddLineToPoint(context,pC.x, pC.y);
    CGContextAddLineToPoint(context,pD.x, pD.y);
    //设置填充色
    [[UIColor orangeColor] setFill];
    //设置边框颜色
    [[UIColor orangeColor] setStroke];
    //绘制路径
    CGContextDrawPath(context,kCGPathFillStroke);
    
    //画直线
    CGContextSetLineWidth(context,2.0);//设置直线宽度
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,0,height / 2);
    CGContextAddLineToPoint(context,width,height / 2);
    [[UIColor orangeColor] setStroke];
    CGContextDrawPath(context,kCGPathFillStroke);
}

@end
