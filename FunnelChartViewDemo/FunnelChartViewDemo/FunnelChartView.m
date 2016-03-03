//
//  FunnelChartView.m
//  FunnelChartViewDemo
//
//  Created by Qin Yuxiang on 2/28/16.
//  Copyright © 2016 YuxiangQ. All rights reserved.
//

#import "FunnelChartView.h"
#import "FunnelChartValueObject.h"
#import "FunnelChartSliderButton.h"

static const CGFloat kCorner = .5f;
static const CGFloat kMargin = 10.f;

@implementation FunnelChartView {
    NSArray<FunnelChartModel*> *_dataArray;
    NSMutableArray<FunnelChartValueObject*> *_voArray;
    
    CGPoint _prePointA;
    CGPoint _prePointB;
    CGPoint _prePointC;
    CGPoint _prePointD;
    
    CGFloat _minSliderY;
    CGFloat _maxSliderY;
    
    NSUInteger _preIndex;
}

- (id)initWithFrame:(CGRect)frame
funnelChartModelArray:(NSArray<FunnelChartModel*>*)dataArray {
    if (self = [super initWithFrame:frame]) {
        if (dataArray.count == 0) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:@"传入的参数不正确"
                                         userInfo:nil];
        }
        _voArray = [NSMutableArray new];
        _dataArray = dataArray;
        _preIndex = 0;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWitFrame:(CGRect)frame
            values:(NSArray<NSNumber*>*)valueArray
            colors:(NSArray<UIColor*>*)colorArray {
    if (valueArray.count == 0 || valueArray.count != colorArray.count) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"传入的参数不正确"
                                     userInfo:nil];
    }
    
    NSMutableArray *modelArray = [NSMutableArray new];
    [valueArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj,
                                             NSUInteger idx,
                                             BOOL * _Nonnull stop) {
        FunnelChartModel *model = [FunnelChartModel new];
        model.value = [obj floatValue];
        model.color = colorArray[idx];
        [modelArray addObject:model];
    }];
    return [self initWithFrame:frame
         funnelChartModelArray:modelArray];
}

- (void)reloadData:(NSArray<FunnelChartModel*>*)dataArray {
    _dataArray = dataArray;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)drawRect:(CGRect)rect {
    _prePointA = CGPointZero;
    _prePointB = CGPointZero;
    _prePointC = CGPointZero;
    _prePointD = CGPointZero;
    
    CGFloat funnelMaxWidth = CGRectGetWidth(rect) * 0.7f;
    CGFloat funnelMaxHeight = CGRectGetHeight(rect) - kMargin * 2;
    
    CGFloat totalValue = 0.f;
    for (FunnelChartModel *model in _dataArray) {
        totalValue += model.value;
    }
    
    static CGFloat minHeight = 2.f;
    [_dataArray enumerateObjectsUsingBlock:^(FunnelChartModel *obj
                                            ,NSUInteger idx
                                            ,BOOL *stop) {
        CGPoint pointA = CGPointZero;
        CGPoint pointB = CGPointZero;
        CGPoint pointC = CGPointZero;
        CGPoint pointD = CGPointZero;
        CGFloat height = funnelMaxHeight * (obj.value / totalValue);
        
        if (height < minHeight) {
            _maxSliderY += (minHeight - height);
            height = minHeight;
        }

        if (_voArray.count == 0) {
            FunnelChartValueObject *vo = [FunnelChartValueObject new];
            vo.minValue = 0.f;
            vo.maxValue = height;
            [_voArray addObject:vo];
            
        }
        else {
            FunnelChartValueObject *preVO = [_voArray lastObject];
            FunnelChartValueObject *vo = [FunnelChartValueObject new];
            vo.minValue = preVO.maxValue;
            vo.maxValue = preVO.maxValue + height;
            [_voArray addObject:vo];
        }
        
        if (_prePointA.x == 0.f && _prePointA.y == 0.f) {
            pointA = CGPointMake(kMargin, kMargin);
            pointB = CGPointMake(funnelMaxWidth + kMargin, kMargin);
            pointC = CGPointMake((funnelMaxWidth + kMargin) - (height * kCorner), kMargin + height);
            pointD = CGPointMake(kMargin + (height * kCorner), kMargin + height);
        }
        else {
            if (idx == _dataArray.count - 1) {
                pointA = _prePointD;
                pointB = _prePointC;
                pointC = CGPointMake(pointB.x, _prePointC.y + height);
                pointD = CGPointMake(pointA.x, _prePointC.y + height);
            }
            else {
                pointA = _prePointD;
                pointB = _prePointC;
                pointC = CGPointMake(pointB.x - (height * kCorner), _prePointC.y + height);
                pointD = CGPointMake(pointA.x + (height * kCorner), _prePointC.y + height);
            }
        }
        
        if (pointC.x < pointD.x) {
            pointC.x = pointB.x;
            pointD.x = pointA.x;
        }
        
        _prePointA = pointA;
        _prePointB = pointB;
        _prePointC = pointC;
        _prePointD = pointD;
        
        [self drawRectWithColor:obj.color
                         pointA:pointA
                         pointB:pointB
                         pointC:pointC
                         pointD:pointD];
    }];
    
    [self drawSliderWithBeginPoint:CGPointMake(CGRectGetWidth(rect) - kMargin * 3, kMargin)
                          endPoint:CGPointMake(CGRectGetWidth(rect) - kMargin * 3, kMargin + funnelMaxHeight)];
}

- (void)drawRectWithColor:(UIColor*)color
                  pointA:(CGPoint)pA
                  pointB:(CGPoint)pB
                  pointC:(CGPoint)pC
                  pointD:(CGPoint)pD {
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //开始路径绘制
    CGContextBeginPath(context);
    
    //起点
    CGContextMoveToPoint(context,pA.x,pA.y);
    CGContextAddLineToPoint(context,pB.x, pB.y);
    CGContextAddLineToPoint(context,pC.x, pC.y);
    CGContextAddLineToPoint(context,pD.x, pD.y);
    //设置填充色
    [color setFill];
    //设置边框颜色
    [color setStroke];
    //绘制路径
    CGContextDrawPath(context,kCGPathFillStroke);
}

- (void)drawSliderWithBeginPoint:(CGPoint)beginPoint
                        endPoint:(CGPoint)endPoint {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,2.0);//设置直线宽度
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,beginPoint.x,beginPoint.y);
    CGContextAddLineToPoint(context,endPoint.x,endPoint.y);
    [[UIColor lightGrayColor] setStroke];
    CGContextDrawPath(context,kCGPathFillStroke);
    _minSliderY = beginPoint.y;
    _maxSliderY += endPoint.y;
    
    CGFloat buttonHeight = 28;
    FunnelChartSliderButton *sliderButton = [[FunnelChartSliderButton alloc] initWithFrame:CGRectMake(kMargin, beginPoint.y - buttonHeight / 2, CGRectGetWidth(self.frame) - kMargin * 2 , buttonHeight)];
    sliderButton.backgroundColor = [UIColor clearColor];
    sliderButton.userInteractionEnabled = YES;
    UIPanGestureRecognizer *sliderLabelPanGR = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(panSliderButton:)];
    [sliderButton addGestureRecognizer:sliderLabelPanGR];
    [self addSubview:sliderButton];

}

- (void)panSliderButton:(UIPanGestureRecognizer*)sender {
    CGPoint point = [sender translationInView:self];
    CGFloat movedY = (sender.view.center.y + point.y <= _minSliderY)
    || (sender.view.center.y + point.y >= _maxSliderY) ?
    sender.view.center.y : sender.view.center.y + point.y;
    sender.view.center = CGPointMake(sender.view.center.x, movedY);
    [sender setTranslation:CGPointMake(0, 0) inView:self];
    CGFloat relativeY = movedY - _minSliderY;
    [_voArray enumerateObjectsUsingBlock:^(FunnelChartValueObject *obj,
                                           NSUInteger idx,
                                           BOOL *stop) {
        if (relativeY >= obj.minValue && relativeY < obj.maxValue) {
            if (idx != _preIndex) {
                if (self.didSelectedIndexFunnelChartBlock) {
                    self.didSelectedIndexFunnelChartBlock(idx);
                }
                _preIndex = idx;
            }
        }
    }];
}

@end
