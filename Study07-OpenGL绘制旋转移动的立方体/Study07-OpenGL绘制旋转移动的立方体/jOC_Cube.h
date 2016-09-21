//
//  jOC_Cube.h
//  Study07-OpenGL绘制旋转移动的立方体
//
//  Created by 黄进文 on 16/9/12.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#ifndef jOC_Cube_h
#define jOC_Cube_h

// 顶点坐标
static const GLfloat cubeVertices[] =
{
    -0.5,  0.5,  0.5,
     0.5,  0.5,  0.5,
     0.5, -0.5,  0.5,
    -0.5, -0.5,  0.5,
    
    -0.5,  0.5, -0.5,
     0.5,  0.5, -0.5,
     0.5, -0.5, -0.5,
    -0.5, -0.5, -0.5,
    //1
};

// 颜色
static const GLubyte cubeColors[] = {
    
    255, 255,   0, 255,
      0, 255, 255, 255,
      0,   0,   0,   0,
    255,   0, 255, 255,
    
    255, 255,   0, 255,
      0, 255, 255, 255,
      0,   0,   0,   0,
    255,   0, 255, 255,
};

// 索引
static const GLubyte tfan1[6 * 3] =
{
    1, 0, 3,
    1, 3, 2,
    1, 2, 6,
    1, 6, 5,
    1, 5, 4,
    1, 4, 0
};

// 索引
static const GLubyte tfan2[6 * 3] =
{
    7, 4, 5,
    7, 5, 6,
    7, 6, 2,
    7, 2, 3,
    7, 3, 0,
    7, 0, 4
};

#endif /* jOC_Cube_h */










































