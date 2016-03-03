//
//  ViewController.m
//  FunnelChartViewDemo
//
//  Created by Qin Yuxiang on 2/28/16.
//  Copyright © 2016 YuxiangQ. All rights reserved.
//

#import "ViewController.h"
#import "FunnelChart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FunnelChartModel *model1 = [FunnelChartModel new];
    model1.value = 10.f;
    model1.color = [UIColor redColor];
    
    FunnelChartModel *model2 = [FunnelChartModel new];
    model2.value = 12.f;
    model2.color = [UIColor orangeColor];
    
    FunnelChartModel *model3 = [FunnelChartModel new];
    model3.value = 22.f;
    model3.color = [UIColor brownColor];
    
    FunnelChartModel *model4 = [FunnelChartModel new];
    model4.value = 15.f;
    model4.color = [UIColor yellowColor];
    
    NSMutableArray *data = [NSMutableArray new];
    [data addObject:model1];
    [data addObject:model2];
    [data addObject:model3];
    [data addObject:model4];
    
    FunnelChartView *funnelChartView = [[FunnelChartView alloc]
                                        initWithFrame:CGRectMake(0,
                                                                 64,
                                                                 CGRectGetWidth(self.view.frame),
                                                                 CGRectGetHeight(self.view.frame) - 64.f)
                                                        funnelChartModelArray:data];
    funnelChartView.didSelectedIndexFunnelChartBlock = ^(NSUInteger index){
        NSLog(@"%@",@(index));
    };
    [self.view addSubview:funnelChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
