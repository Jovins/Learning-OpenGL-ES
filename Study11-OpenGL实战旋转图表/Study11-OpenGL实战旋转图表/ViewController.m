//
//  ViewController.m
//  Study11-OpenGL实战旋转图表
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "ViewController.h"
#import "JWChartViewController.h"
#import "JWCaptureView.h"

@interface ViewController ()

@property (nonatomic, strong) JWChartViewController *jChartVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 第一步 添加3D视图
    JWChartViewController *chartVC = [[JWChartViewController alloc] initWithChartData:@[@36, @80, @120, @200, @320]];
    self.jChartVC = chartVC;
    chartVC.view.frame = self.view.bounds;
    [self.view insertSubview:chartVC.view atIndex:0];
    [self addChildViewController:chartVC];
    
    // 打开摄像头
    chartVC.view.backgroundColor = [UIColor clearColor];
    JWCaptureView *view = [[JWCaptureView alloc] init];
    view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.view insertSubview:view atIndex:0];
    [view setup:^(CGImageRef image) {
        
        NSLog(@"%@", image);
    }];
}


- (IBAction)jRotation:(UIButton *)sender {
    
    if (sender.selected) {
        
        [self.jChartVC startRotation];
    }
    else {
        
        [self.jChartVC stopRotation];
    }
    sender.selected = !sender.selected;
}
@end






















