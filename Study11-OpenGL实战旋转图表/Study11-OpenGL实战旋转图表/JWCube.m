//
//  JWCube.m
//  Study11-OpenGL实战旋转图表
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "JWCube.h"

// 立方体模型
@implementation JWCube

/**
 *  初始化立方体
 *
 *  @param position 顶点
 *  @param width    宽
 *  @param height   高
 *  @param lenght   长
 */
+ (instancetype)jCubeWithPosition:(JWPosition *)position width:(GLfloat)width height:(GLfloat)height lenght:(GLfloat)lenght {
    
    GLfloat x = position.x;
    GLfloat y = position.y;
    GLfloat z = position.z;
    
    // 8个顶点
    JWPosition *position0 = [JWPosition jPositionMakeX:x - width * 0.5 Y:y + height Z:z + lenght * 0.5];
    JWPosition *position1 = [JWPosition jPositionMakeX:x + width * 0.5 Y:y + height Z:z + lenght * 0.5];
    JWPosition *position2 = [JWPosition jPositionMakeX:x - width * 0.5 Y:y          Z:z + lenght * 0.5];
    JWPosition *position3 = [JWPosition jPositionMakeX:x + width * 0.5 Y:y          Z:z + lenght * 0.5];
    JWPosition *position4 = [JWPosition jPositionMakeX:x - width * 0.5 Y:y + height Z:z - lenght * 0.5];
    JWPosition *position5 = [JWPosition jPositionMakeX:x + width * 0.5 Y:y + height Z:z - lenght * 0.5];
    JWPosition *position6 = [JWPosition jPositionMakeX:x - width * 0.5 Y:y          Z:z - lenght * 0.5];
    JWPosition *position7 = [JWPosition jPositionMakeX:x + width * 0.5 Y:y          Z:z - lenght * 0.5];
    
    JWCube *cube = [[JWCube alloc] init];
    cube.number = 216;
    cube.vertex = malloc(sizeof(GLfloat) * cube.number);
    NSArray *array = @[position0, position1, position2, position3, position4, position5, position6, position7];
    // 顶点索引
    NSArray * indexs = @[@1, @0, @2,
                         @1, @2, @3,
                         @1, @3, @7,
                         @1, @7, @5,
                         @1, @5, @4,
                         @1, @4, @0,
                         @6, @7, @5,
                         @6, @5, @4,
                         @6, @0, @4,
                         @6, @2, @0,
                         @6, @7, @3,
                         @6, @3, @2];
    // 顶点
    for (int i=0;i< indexs.count; i++) {
        
        JWPosition *position = array[[indexs[i] integerValue]];
        
        cube.vertex[i*6]   = position.x;
        cube.vertex[i*6+1] = position.y;
        cube.vertex[i*6+2] = position.z;
        // 设置6个面
        switch (i/6) {
            case 0:
                cube.vertex[i * 6 + 3] = 0;
                cube.vertex[i * 6 + 4] = 0;
                cube.vertex[i * 6 + 5] = 1;
                break;
            case 1:
                cube.vertex[i * 6 + 3] = 1;
                cube.vertex[i * 6 + 4] = 0;
                cube.vertex[i * 6 + 5] = 0;
                
                break;
            case 2:
                cube.vertex[i * 6 + 3] = 0;
                cube.vertex[i * 6 + 4] = 1;
                cube.vertex[i * 6 + 5] = 0;
                
                break;
            case 3:
                cube.vertex[i * 6 + 3] = 0;
                cube.vertex[i * 6 + 4] = 0;
                cube.vertex[i * 6 + 5] = -1;
                break;
            case 4:
                cube.vertex[i * 6 + 3] = 0;
                cube.vertex[i * 6 + 4] = -1;
                cube.vertex[i * 6 + 5] = 0;
                
                break;
            case 5:
                cube.vertex[i * 6 + 3] = -1;
                cube.vertex[i * 6 + 4] = 0;
                cube.vertex[i * 6 + 5] = 0;
                break;
                
            default:
                break;
                
        }
    }
    return cube;
}

- (void)dealloc {
    
    free(self.vertex);
}

@end





































