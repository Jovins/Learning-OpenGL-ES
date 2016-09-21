//
//  JWCube.h
//  Study11-OpenGL实战旋转图表
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWPosition.h"

@interface JWCube : NSObject

@property (nonatomic, assign) GLfloat *vertex;

@property (nonatomic, assign) GLuint number;

+ (instancetype)jCubeWithPosition:(JWPosition *)position width:(GLfloat)width height:(GLfloat)height lenght:(GLfloat)lenght;

@end
