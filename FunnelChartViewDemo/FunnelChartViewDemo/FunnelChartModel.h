//
//  FunnelChartModel.h
//  FunnelChartViewDemo
//
//  Created by Qin Yuxiang on 2/29/16.
//  Copyright © 2016 YuxiangQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//@protocol FunnelChartModelDelegate <NSObject>
//
//@end

/**
 *  漏斗实体对象，用来组织数据
 */
@interface FunnelChartModel : NSObject

@property (assign, nonatomic) CGFloat value;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) id object;

@end

