//
//  JWPosition.h
//  Study11-OpenGL实战旋转图表
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface JWPosition : NSObject

@property (nonatomic, assign) GLfloat x;

@property (nonatomic, assign) GLfloat y;

@property (nonatomic, assign) GLfloat z;

+ (instancetype)jPositionMakeX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z;

@end
