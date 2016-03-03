//
//  FunnelChartView.h
//  FunnelChartViewDemo
//
//  Created by Qin Yuxiang on 2/28/16.
//  Copyright © 2016 YuxiangQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunnelChartModel.h"

typedef void(^DidSelectedIndexFunnelChartBlock)(NSUInteger index);
/**
 *  控件主体
 */
@interface FunnelChartView : UIView

@property (copy, nonatomic) DidSelectedIndexFunnelChartBlock didSelectedIndexFunnelChartBlock;

- (id)initWithFrame:(CGRect)frame
funnelChartModelArray:(NSArray<FunnelChartModel*>*)dataArray;

- (id)initWitFrame:(CGRect)frame
            values:(NSArray<NSNumber*>*)valueArray
            colors:(NSArray<UIColor*>*)colorArray;

- (void)reloadData:(NSArray<FunnelChartModel*>*)dataArray;

@end
