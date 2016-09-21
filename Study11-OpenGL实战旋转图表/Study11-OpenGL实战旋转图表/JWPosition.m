//
//  JWPosition.m
//  Study11-OpenGL实战旋转图表
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "JWPosition.h"

@implementation JWPosition

// 顶点
+ (instancetype)jPositionMakeX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z {
    
    JWPosition *position = [[JWPosition alloc] init];
    position.x = x;
    position.y = y;
    position.z = z;
    return position;
}

@end
