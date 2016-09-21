//
//  JWPlanet.h
//  Study04-OpenGL太阳系
//
//  Created by 黄进文 on 16/9/10.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>

@interface JWPlanet : NSObject
{
    @private
    GLfloat *j_VertexData;     // 顶点数据
    GLubyte *j_ColorData;      // 颜色
    GLfloat *j_NormalData;      // 正常数据
    GLint   j_Stacks, j_Slices; // 堆 切片
    GLfloat j_Scale;           // 缩放
    GLfloat j_Squash;
    GLfloat j_Angle;
    GLfloat j_Pos[3];
    GLfloat j_RotationalIncrement;
}

- (BOOL)execute;

- (instancetype)init:(GLint)stacks slices:(GLint)slices radius:(GLfloat)radius squash:(GLfloat)squash;

- (void)getPositionX:(GLfloat *)x Y:(GLfloat*)y Z:(GLfloat *)z;

- (void)setPositionX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z;

- (GLfloat)getRotation;

- (void)setRotation:(GLfloat)angle;

- (GLfloat)getRotationalIncrement;

- (void)setRotationalIncrement:(GLfloat)inc;

- (void)incrementRotation;
@end






































