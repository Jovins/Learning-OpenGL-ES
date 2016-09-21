//
//  ViewController.m
//  Study06-OpenGL创建一个移动的球体
//
//  Created by 黄进文 on 16/9/12.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface ViewController () {
    
    GLfloat *_jVertexArray;
    GLubyte *_jColorArray;
    
    GLint   _jStacks;
    GLint   _jSlices;
    GLfloat _jScale;
    GLfloat _jSquash;
}

@property (nonatomic, strong) EAGLContext *jContext;

@end

@implementation ViewController

/**
 *  学习目标 绘制移动的球体(没有设置光源)
 *
 *  第一步: 创建GLKViewController 控制器(在里面实现方法)
 *  第二步: 创建EAGContext 跟踪所有状态,命令和资源
 *  第三步: 生成球体的顶点坐标和颜色数据
 *  第四步: 创建投影坐标系
 *  第五步: 创建视景体
 *  第六步: 清除命令
 *  第七步: 创建对象坐标
 *  第八步: 导入顶点数据
 *  第九步: 导入颜色数据
 *  第十步: 绘制
 *
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackgroundImageView];
    
    [self jCreateEAGLContext];
    
    [self jCreateCalculate];
    
    [self jCreateProjectionMatrix];
    
    [self jCreateCliping];
}

/**
 *  渲染数据
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self jClearCommand];
    
    [self jCreateModelViewMatrix];
    
    [self jLoadingVertexData];
    
    [self jLoadingColorBuffer];
    
    [self jDrawView];
}

/**
 *  2.创建EAGContext 跟踪所有状态,命令和资源
 */
- (void)jCreateEAGLContext {
    
    self.jContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:self.jContext];
    
    GLKView *view = (GLKView *)self.view;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = self.jContext;
}

/**
 *  3.生成球体的顶点坐标和颜色数据
 */
- (void)jCreateCalculate {
    
    unsigned int colorIncrement = 0;
    // 设置球体颜色
    unsigned int blue = 255;
    unsigned int red = 0;
    unsigned int green = 0;
    static int big = 1;
    static float scale = 0;
    // 球体缩放数据
    if (big) {
        
        scale += 0.01;
    }
    else {
        
        scale -= 0.01;
    }
    
    if (scale >= 0.5) {
        
        big = 0;
    }
    if (scale <= 0) {
        
        big = 1;
    }
    
    _jScale  = 0.5 + scale;
    _jSlices = 100;
    _jSquash = 1;
    _jStacks = 100;
    colorIncrement = 255 / _jStacks;
    
    // vertex 顶点
    GLfloat *verPtr = _jVertexArray = (GLfloat *)malloc(sizeof(GLfloat) * 3 * ((_jSlices * 2 + 2) * (_jStacks)));
    // color 颜色
    GLubyte *colorPtr = _jColorArray = (GLubyte *)malloc(sizeof(GLubyte) * 4 * ((_jSlices * 2 + 2) * (_jStacks)));
    
    // latitude
    unsigned int phiIndex, thetaIndex;
    for(phiIndex = 0; phiIndex < _jStacks; phiIndex++) {
        
        float phi0 = M_PI * ((float)(phiIndex + 0) * (1.0f / (float)(_jStacks)) - 0.5f);
        float phi1 = M_PI * ((float)(phiIndex + 1) * (1.0f / (float)(_jStacks)) - 0.5f);
        float cosPhi0 = cos(phi0);
        float sinPhi0 = sin(phi0);
        float cosPhi1 = cos(phi1);
        float sinPhi1 = sin(phi1);
        
        float cosTheta, sinTheta;
        for (thetaIndex = 0; thetaIndex < _jSlices; thetaIndex++) {
            
            float theta = 2.0f * M_PI * ((float)thetaIndex) * (1.0 / (float)(_jSlices - 1));
            cosTheta = cos(theta);
            sinTheta = sin(theta);
            
            verPtr[0] = _jScale * cosPhi0 * cosTheta;
            verPtr[1] = _jScale * sinPhi0 * _jSquash;
            verPtr[2] = _jScale * cosPhi0 * sinTheta;
            
            verPtr[3] = _jScale * cosPhi1 * cosTheta;
            verPtr[4] = _jScale * sinPhi1 * _jSquash;
            verPtr[5] = _jScale * cosPhi1 * sinTheta;
            
            verPtr += 2 * 3;
            
            colorPtr[0] = red;
            colorPtr[1] = green;
            colorPtr[2] = blue;
            colorPtr[4] = red;
            colorPtr[5] = green;
            colorPtr[6] = blue;
            colorPtr[3] = colorPtr[7] = 255;
            
            colorPtr += 2 * 4;
        }
        red -= colorIncrement;
    }
}

/**
 *  4.创建投影坐标系
 */
- (void)jCreateProjectionMatrix {
    
    glMatrixMode(GL_PROJECTION); // 投影矩阵
    glLoadIdentity(); // 设置当前矩阵为单位矩阵
}

/**
 *  5.创建视景体
 *  设置窗口及投影坐标的位置
 */
- (void)jCreateCliping {
    
    float aspectRatio;
    const float zNear = 0.1;
    const float zFar = 1000;
    const float fileOfView = 60.0;
    GLfloat size;
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    aspectRatio = (float)frame.size.width / (float)frame.size.height;
    size = zNear * tanf(GLKMathDegreesToRadians(fileOfView) / 2.0);
    // 设置视图窗口的大小 坐标系统
    glFrustumf(-size, size, -size / aspectRatio, size / aspectRatio, zNear, zFar);
    glViewport(0, 0, frame.size.width, frame.size.height);
}

/**
 *  6.清除命令
 */
- (void)jClearCommand {
    
    glEnable(GL_DEPTH_TEST);
    glClearColor(1, 1, 1, 0.1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

/**
 *  7.创建对象坐标
 *  glTranslatef：将T(x,y,z)右乘与堆栈的栈顶变换矩阵。右乘的解释，假设目前栈顶变换矩阵为M，那么就相当于把M修改为M*T.
 *  glRotatef ：将R(x,y,z,s)右乘与堆栈的栈顶变换矩阵。
 *  glLoadIdentity：将堆栈的栈顶变换矩阵设置成单位矩阵。
 *  glPushMatrix：将堆栈的栈顶变换矩阵复制一份，然后Push到堆栈中。所谓Push，就像塞子弹一样把一个矩阵压入到堆栈中，此时，栈顶就是这个新的矩阵了，注意定义的向量都是和栈顶变换矩阵作用的。
 *  glPopMatrix：将堆栈的栈顶变换矩阵Pop出来。
 */
- (void)jCreateModelViewMatrix {
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    static GLfloat transY = 0.0;
    static GLfloat z = -2;
    static CGFloat scale = 1;
    static BOOL isBig = true;
    
    if (isBig) {
        
        scale += 0.01;
    }
    else {
        
        scale -= 0.01;
    }
    
    if (scale >= 1.5) {
        
        isBig = false;
    }
    if (scale <= 0.5) {
        
        isBig = true;
    }
    
    static GLfloat spinX = 0;
    static GLfloat spinY = 0;
    
    glTranslatef(0.0, (GLfloat)(sinf(transY) / 3.0), z);
    glRotatef(spinY, 0.0, 1.0, 0.0);
    glRotatef(spinX, 1.0, 0.0, 0.0);
    glScalef(scale, scale, scale);
    transY += 0.075f; // 频率
    spinY  += 0.25;
    spinX  += 0.25;
}

/**
 *  8.导入顶点数据
 */
- (void)jLoadingVertexData {
    
    glVertexPointer(3, GL_FLOAT, 0, _jVertexArray);
    glEnableClientState(GL_VERTEX_ARRAY);
}

/**
 *  9.导入颜色数据
 */
- (void)jLoadingColorBuffer {
    
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, _jColorArray);
    glEnableClientState(GL_COLOR_ARRAY);
}

/**
 *  10.渲染 绘制数据
 */
- (void)jDrawView {
    
    // 开启剔除面功能
    glEnable(GL_CULL_FACE);
    // 剔除背面
    glCullFace(GL_BACK);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (_jSlices + 1) * 2 * (_jStacks - 1) + 2);
}

/**
 *  设置背景面
 */
- (void)setupBackgroundImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qinnv.jpg"]];
    imageView.frame = self.view.bounds;
    
    [self.view addSubview:imageView];
    
    imageView.alpha = 0.4;
}

@end



































