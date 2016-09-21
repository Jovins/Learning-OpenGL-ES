//
//  JWChartViewController.h
//  Study11-OpenGL实战旋转图表
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface JWChartViewController : GLKViewController

- (void)jLoadData:(NSArray *)data;

- (instancetype)initWithChartData:(NSArray *)chartData;

- (void)startRotation;

- (void)stopRotation;

@end


































