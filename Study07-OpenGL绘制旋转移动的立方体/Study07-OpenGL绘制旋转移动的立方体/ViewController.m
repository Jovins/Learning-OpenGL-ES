//
//  ViewController.m
//  Study07-OpenGL绘制旋转移动的立方体
//
//  Created by 黄进文 on 16/9/12.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "jOC_Cube.h"

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *jContext;

@end

@implementation ViewController

/**
 *  学习目标
 *
 *  第一步: 创建GLKViewController 控制器(在里面实现方法)
 *  第二步: 创建EAGContext 跟踪所有状态,命令和资源
 *  第三步: 创建投影坐标系
 *  第四步: 创建视景体
 *  第五步: 清除命令
 *  第六步: 创建对象坐标
 *  第七步: 导入顶点数据
 *  第八步: 导入颜色数据
 *  第九步: 绘制
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.alpha = 0.8;
    
    [self jCreateEAGLContext];
    
    [self jCreateProjectionMatrix];
    
    [self jCreateClipping];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self jClearCommand];
    
    [self jCreateModeViewMatrix];
    
    [self jLoadingVertexData];
    
    [self jLoadingColorBuffer];
    
    [self jDrawView];
}

/**
 *  第二步: 创建EAGContext 跟踪所有状态,命令和资源
 */
- (void)jCreateEAGLContext {
    
    self.jContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:self.jContext];
    // 配置view
    GLKView *view = (GLKView *)self.view;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = self.jContext;
}

/**
 *  第三步:创建投影坐标系
 */
- (void)jCreateProjectionMatrix {
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
}


/**
 *  第四步: 创建视景体(立方体)
 */
- (void)jCreateClipping {
    
    float aspectRatio;
    const float zNear = 0.1;
    const float zFar  = 1000;
    const float fileOfView = 60.0;
    GLfloat size;
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    aspectRatio = (float)frame.size.width / (float)frame.size.height;
    size = zNear * tanf(GLKMathDegreesToRadians(fileOfView) / 2.0); // 视景体的大小
    // 设置视图窗口的大小 坐标系统
    glFrustumf(-size, size, -size / aspectRatio, size / aspectRatio, zNear, zFar);
    // 背面视图
    glViewport(0, 0, frame.size.width, frame.size.height);
}

/**
 *  第五步: 清除命令
 */
- (void)jClearCommand {
    
    glEnable(GL_DEPTH_TEST);
    glClearColor(1, 1, 1, 0.5); // 半透明
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // GL_DEPTH_BUFFER_BIT 深度值 -- 距离
}

/**
 *  第六步: 创建对象坐标(运动坐标)
 */
- (void)jCreateModeViewMatrix {
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    // 距离(上下移动)
    static GLfloat transY = 0.0;
    static GLfloat z      = -4.0; // (物体在Z轴的距离)
    // 第一个参数:x轴距离 第二：Y轴距离 第三：Z轴
    glTranslatef(0.0, (GLfloat)(sinf(transY) / 2.0), z);
    transY += 0.075f;
    
    // 旋转
    static GLfloat spinX  = 0; // 旋转角度
    static GLfloat spinY  = 0;
    static GLfloat spinZ  = 0;
    glRotatef(spinY, 0.0, 1.0, 0.0); // 旋转物体
    glRotatef(spinX, 1.0, 0.0, 0.0);
    glRotatef(spinZ, 0.0, 0.0, 1.0);
    spinY  += 0.25;
    spinX  += 0.25;
    spinZ  += 0.25;
}

/**
 *  第七步: 导入顶点数据
 *  glVertexPointer 第一个参数:每个顶点数据的个数,第二个参数,顶点数据的数据类型,第三个偏移量，第四个顶点数组地址
 */
- (void)jLoadingVertexData {
    
    glVertexPointer(3, GL_FLOAT, 0, cubeVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
}

/**
 *  第八步: 导入颜色数据
 */
- (void)jLoadingColorBuffer {
    
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColors);
    glEnableClientState(GL_COLOR_ARRAY);
}

/**
 *  第九步: 绘制
 */
- (void)jDrawView {
    
    // 开启剔除面功能
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK); // 剔除背面
    
    glDrawElements(GL_TRIANGLE_FAN, 18, GL_UNSIGNED_BYTE, tfan1);
    glDrawElements(GL_TRIANGLE_FAN, 18, GL_UNSIGNED_BYTE, tfan2);
}

@end








































