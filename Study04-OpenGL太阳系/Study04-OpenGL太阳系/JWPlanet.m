//
//  JWPlanet.m
//  Study04-OpenGL太阳系
//
//  Created by 黄进文 on 16/9/10.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

// 球形的模型数据

#import "JWPlanet.h"

@implementation JWPlanet

/**
 *  初始化数据
 */
- (instancetype)init:(GLint)stacks slices:(GLint)slices radius:(GLfloat)radius squash:(GLfloat)squash {
    
    unsigned int colorIncrment = 0;
    unsigned int blue          = 0;
    unsigned int red           = 255;
    int numVertices            = 0;
    
    j_Scale  = radius;
    j_Squash = squash;
    
    colorIncrment = 255 / stacks;
    
    if ((self = [super init]))
    {
        j_Stacks     = stacks;
        j_Slices     = slices;
        j_VertexData = nil;
        
        // Vertices
        
        GLfloat *verPtr = j_VertexData =
        (GLfloat*)malloc(sizeof(GLfloat) * 3 * ((j_Slices * 2 + 2) * (j_Stacks)));
        
        // Color data
        
        GLubyte *colorPtr = j_ColorData =
        (GLubyte*)malloc(sizeof(GLubyte) * 4 * ((j_Slices * 2 + 2) * (j_Stacks)));
        
        // Normal pointers for lighting
        
        GLfloat *normalPtr = j_NormalData = 				//1
        (GLfloat*)malloc(sizeof(GLfloat) * 3 * ((j_Slices * 2 + 2) * (j_Stacks)));
        unsigned int phiIndex, thetaIndex;
        
        // Latitude
        
        for(phiIndex = 0; phiIndex < j_Stacks; phiIndex++)
        {
            // Starts at -1.57 goes up to +1.57 radians
            
            // The first circle
            
            float phi0 = M_PI * ((float)(phiIndex + 0) * (1.0/(float)(j_Stacks)) - 0.5);
            
            // The next, or second one.
            
            float phi1 = M_PI * ((float)(phiIndex + 1) * (1.0/(float)(j_Stacks)) - 0.5);
            float cosPhi0 = cos(phi0);
            float sinPhi0 = sin(phi0);
            float cosPhi1 = cos(phi1);
            float sinPhi1 = sin(phi1);
            
            float cosTheta, sinTheta;
            
            // Longitude
            
            for(thetaIndex = 0; thetaIndex < j_Slices; thetaIndex++)
            {
                // Increment along the longitude circle each "slice"
                
                float theta = 2.0 * M_PI * ((float)thetaIndex) * (1.0 / (float)(j_Slices - 1));
                cosTheta = cos(theta);
                sinTheta = sin(theta);
                
                // We're generating a vertical pair of points, such
                // as the first point of stack 0 and the first point of stack 1
                // above it. This is how TRIANGLE_STRIPS work,
                // taking a set of 4 vertices and essentially drawing two triangles
                // at a time. The first is v0-v1-v2 and the next is v2-v1-v3, etc.
                
                
                // Get x-y-z for the first vertex of stack.
                
                verPtr[0] = j_Scale*cosPhi0 * cosTheta;
                verPtr[1] = j_Scale*sinPhi0 * j_Squash;
                verPtr[2] = j_Scale*cosPhi0 * sinTheta;
                
                // The same but for the vertex immediately above the previous one
                
                verPtr[3] = j_Scale*cosPhi1  * cosTheta;
                verPtr[4] = j_Scale*sinPhi1  * j_Squash;
                verPtr[5] = j_Scale* cosPhi1 * sinTheta;
                
                // Normal pointers for lighting
                
                normalPtr[0] = cosPhi0 * cosTheta; 	//2
                normalPtr[1] = sinPhi0;
                normalPtr[2] = cosPhi0 * sinTheta;
                
                normalPtr[3] = cosPhi1 * cosTheta; 	//3
                normalPtr[4] = sinPhi1;
                normalPtr[5] = cosPhi1 * sinTheta;
                
                colorPtr[0] = red;
                colorPtr[1] = 0;
                colorPtr[2] = blue;
                colorPtr[4] = red;
                colorPtr[5] = 0;
                colorPtr[6] = blue;
                colorPtr[3] = colorPtr[7] = 255;
                
                colorPtr  += 2 * 4;
                verPtr    += 2 * 3;
                normalPtr += 2 * 3;                                                  //4
                
            }
            
            blue += colorIncrment;
            red  -= colorIncrment;
        }
        
        numVertices = (int)(verPtr - j_VertexData)/6;
    }
    
    return self;
}

/**
 *  剔除了任何我不需要执行东西, 用于测试月亮。旋转的弧度。
 */
- (BOOL)execute {
    
    glMatrixMode(GL_MODELVIEW); // 将当前矩阵设置为投影矩阵
    glEnable(GL_CULL_FACE); // 开启剔除操作效果
    /**
     glCullFace()参数包括GL_FRONT和GL_BACK。表示禁用多边形正面或者背面上的光照、
     阴影和颜色计算及操作，消除不必要的渲染计算。例如某对象无论如何位置变化，我们都只
     能看到构成其组成的多边形的某一面时，可使用该函数
     */
    glCullFace(GL_BACK); // 禁用背面光照、阴影和颜色计算及操作，消除不必要的渲染计算
    
    glEnableClientState(GL_NORMAL_ARRAY); // 启用当前矩阵
    glEnableClientState(GL_VERTEX_ARRAY); // 启用顶点矩阵
    glEnableClientState(GL_COLOR_ARRAY);  // 启用颜色矩阵
    
    glVertexPointer(3, GL_FLOAT, 0, j_VertexData); // 顶点
    glNormalPointer(GL_FLOAT, 0, j_NormalData);
    
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, j_ColorData);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (j_Slices + 1) * 2 * (j_Stacks - 1) + 2);
    
    return true;
}

- (void)getPositionX:(GLfloat *)x Y:(GLfloat *)y Z:(GLfloat *)z {
    
    *x = j_Pos[0];
    *y = j_Pos[1];
    *z = j_Pos[2];
}

- (void)setPositionX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z {
    
    j_Pos[0] = x;
    j_Pos[1] = y;
    j_Pos[2] = z;
}

- (GLfloat)getRotation {
    
    return j_Angle;
}

- (void)setRotation:(GLfloat)angle {
    
    j_Angle = angle;
}

- (void)incrementRotation {
    
    j_Angle += j_RotationalIncrement;
}

- (GLfloat)getRotationalIncrement {
 
    return j_RotationalIncrement;
}

- (void)setRotationalIncrement:(GLfloat)inc {
    
    j_RotationalIncrement = inc;
}


@end












































