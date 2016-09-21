//
//  JWTriangleView.m
//  Study10-OpenGL绘制一个三角形
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//
/**
 *  运行在GPU 上，一个字快！比如你要做视频的实时处理，每秒60 帧，如果你用cpu 处理它，cpu的使用率可能达到％80 以上，你手机会非常烫，不信试试看。如果你在gpu上做处理，
 *  学习目标－ 使用opengl 绘制一个三角形(opengl 图像绘制的软件接口，运行在GPU中，处理矢量运算速度很快)
 *  OpenGL ES 有啥用？主要用在游戏开发(别傻了，难度太大) 和 图像处理,视频实时处理运算等
 *  好了，三角型在opengl 中有很重要的作用，以后说，现在说一下实现思路！
 *  步骤1. 创建一个 CAEAGLayer对象 显示opengl的最终呈现的内容
 *  步骤2. 创建一个EAGLContext 对象管理openGL显示的内容
 *  步骤3. 创建一个帧缓存对象，屏幕刷新时的一帧数据
 *  步骤4. 创建一个颜色渲染缓冲区，用来缓存颜色数据
 *  步骤5. 清除屏幕
 *  步骤6. 创建一个深度渲染缓冲区，用来呈现立体效果图(2D 图像就不要了)
 *  步骤7. 将三角型的三个顶点 加载到GPU中
 *  步骤8. 将三角型的三个顶点的颜色，加载到GPU中去
 *  步骤9. 执行绘图命令
 *  步骤10.呈现到context中去
 *  友情提示.过程有的曲折，希望各位好好理解!坚持就是胜利！有啥问题 群里交流: 578734141
 */

#import "JWTriangleView.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface JWTriangleView()

@property (nonatomic, strong) EAGLContext   *jContext;

@property (nonatomic, strong) GLKBaseEffect *jEffect;

@end

GLfloat vertex [] = {
    
     0,  1, // 正上
    -1, -1, // 左下
     1, -1, // 右下
};

GLfloat colors [] = {
    
    1, 0, 0,
    0, 0, 1,
    0, 1, 0,
};

@implementation JWTriangleView {
    
    GLuint _jFrameBuffer; // 帧缓存标示
    GLuint _jColorsBuffer; // 颜色缓冲标示
    GLuint _jPositionBuffer; // 顶点坐标缓存标示
    GLuint _jVertexColorBuffer; // 顶点对应的颜色渲染缓冲区标示
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    
    [self jPerformSteps];
}

#pragma mark - 执行步骤
- (void)jPerformSteps {
    
    [self jConfigureLayer];
    
    [self jCreateEAGLContext]; // 上下文
    
    [self jCreateFrameBuffer]; // 帧缓存
    
    [self jCreateColorRenderBuffer]; // 颜色缓存
    
    [self jClearScreen]; // 清屏
    
    [self jDrawTriangleVertex]; // 绘制三角顶点
    
    [self jDrawColorBuffer];
    
    [self showRenderBuffer];
}

#pragma mark - 第一步: 重写下面的layerClass方法 将view的layer层变为 CAEAGLayer 类型 
+ (Class)layerClass {
    
    return [CAEAGLLayer class];
}

// 配置CAEAGLLayer
- (void)jConfigureLayer {
    
    CAEAGLLayer *jLayer = (CAEAGLLayer *)self.layer;
    jLayer.opaque = true; // 提高渲染质量 但会消耗内存
    jLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @(false), kEAGLColorFormatRGBA8:@(true)};
    self.jEffect = [[GLKBaseEffect alloc] init];
}

#pragma mark - 第二步: 创建一个EAGLContext对象 跟踪所有状态,命令和资源 对象管理openGL加载到GPU的内容
- (void)jCreateEAGLContext {
    
    self.jContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.jContext];
}

#pragma mark - 第三步: 创建一个帧缓存对象
/*
 * 创建帧缓存的步骤
 * 1.申请内存标示
 * 2.绑定
 * 3.开辟内存空间
 */
- (void)jCreateFrameBuffer {
    
    glGenFramebuffers(1, &_jFrameBuffer); // 为帧缓存申请一个内存标示，唯一的 1.代表一个帧
    glBindFramebuffer(GL_FRAMEBUFFER, _jFrameBuffer); // 把这个内存标示绑定到帧缓存上
}

#pragma mark - 第四步: 创建颜色渲染缓存
/*
 * 创建帧缓存的步骤
 * 1.申请内存标示
 * 2.绑定
 * 3.设置帧缓存的颜色渲染缓存地址
 * 4.开辟内存空间
 */
- (void)jCreateColorRenderBuffer {
    
    glGenRenderbuffers(1, &_jColorsBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _jColorsBuffer);
    
    [self.jContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _jColorsBuffer);
}

#pragma mark - 第五步: 清除屏幕
/*
 * 1. 设置清除屏幕的颜色
 * 2. 清除屏幕 GL_COLOR_BUFFER_BIT 代表颜色缓冲区
 */
- (void)jClearScreen {
    
    glViewport(0, 0, [self drawableWidth], [self drawableHeight]);
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (GLint)drawableWidth {
    
    GLint width;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    return  width;
}

- (GLint)drawableHeight {
    
    GLint height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    return height;
}

#pragma mark - 第六步: 绘制三角型顶点 
- (void)jDrawTriangleVertex {
    
    [self.jEffect prepareToDraw];
    glGenBuffers(1, &_jPositionBuffer); // 为顶点坐标申请一个内存标示 1代表一帧
    glBindBuffer(GL_ARRAY_BUFFER, _jPositionBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertex), vertex, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, // 指示绑定的花村包含的是顶点位置的信息
                          3,                       // 顶点数量
                          GL_FLOAT,                // 数据类型
                          GL_FALSE,                // 告诉openGL 小数点固定数据是否可以被改变
                          sizeof(GLfloat) * 2,     // 步幅 指定妹儿顶点保存需要多少个字节
                          NULL);                   // 告诉openGL可以从绑定数据的开始位置访问数据
    // 绘图
    // 告诉openGL怎么缓存出料顶点缓存数据
    // 设置绘制第一个顶点的位置
    // 绘制顶点的数量
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

#pragma mark - 第七步: 绘制顶点颜色渲染缓冲区
/*
 * 步骤1 申请内存标示
 * 步骤2 绑定
 * 步骤3 将颜色数据加入gpu的内存中
 * 步骤4 启动绘制颜色命令
 * 步骤5 设置绘图配置
 * 步骤6 开始绘制
 */
- (void)jDrawColorBuffer {
    
    [self.jEffect prepareToDraw];
    glGenBuffers(1, &_jVertexColorBuffer); // 申请内存标示
    glBindBuffer(GL_ARRAY_BUFFER, _jVertexColorBuffer); // 绑定
    glBufferData(GL_ARRAY_BUFFER, sizeof(colors), colors, GL_STATIC_DRAW); // 将颜色数据加入gpu的内存中
    
    // 启动绘制颜色命令
    glEnableVertexAttribArray(GLKVertexAttribColor);
    // 设置绘图配置
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, NULL);
    // 绘图
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

#pragma mark - 第八步: 将渲染缓存中的内容呈现到视图中去
- (void)showRenderBuffer {
    
    [self.jContext presentRenderbuffer:GL_RENDERBUFFER];
}

@end









































