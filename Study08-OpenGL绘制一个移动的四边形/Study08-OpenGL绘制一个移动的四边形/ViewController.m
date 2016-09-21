//
//  ViewController.m
//  Study08-OpenGL绘制一个移动的四边形
//
//  Created by 黄进文 on 16/9/12.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "JOCSquare.h"

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
 *  第四步: 清除命令
 *  第五步: 创建对象坐标
 *  第六步: 导入顶点数据
 *  第七步: 导入颜色数据
 *  第八步: 绘制
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.alpha = 0.5;
    
    [self jCreateEAGLContext];
    
    [self jCreateProjectionMatrix];
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
 *  第三步: 创建投影坐标系
 */
- (void)jCreateProjectionMatrix {
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
}

/**
 *  第四步: 清除命令
 */
- (void)jClearCommand {
    
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
}

/**
 *  第五步: 创建对象坐标
 */
- (void)jCreateModeViewMatrix {
    
    static float transY = 0.0;
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    // z轴一定要设置为0 因为这里没有创建视景体
    glTranslatef(0.0, (GLfloat)(sinf(transY) / 2.0), 0.0); // Y轴上下移动
    transY += 0.075f;
    
    // 旋转: Z轴旋转
    static float spinZ = 0;
    glRotatef(spinZ, 0.0, 0.0, 1.0);
    spinZ += 10.0;  // 旋转频率
}

/**
 *  第六步: 导入顶点数据
 *  glVertexPointer 第一个参数:每个顶点数据的个数,第二个参数,顶点数据的数据类型,第三个偏移量，第四个顶点数组地址
 */
- (void)jLoadingVertexData {
    
    glVertexPointer(2, GL_FLOAT, 0, jSquareVertex);
    glEnableClientState(GL_VERTEX_ARRAY);
}

/**
 *  第七步: 导入颜色数据
 */
- (void)jLoadingColorBuffer {
    
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, jSquareColor);
    glEnableClientState(GL_COLOR_ARRAY);
}

/**
 *  第八步: 绘制
 */
- (void)jDrawView {
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);  // 4: 顶点
}

@end







































