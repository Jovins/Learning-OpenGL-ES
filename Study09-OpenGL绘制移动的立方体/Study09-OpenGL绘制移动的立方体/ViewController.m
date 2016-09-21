//
//  ViewController.m
//  Study09-OpenGL绘制移动的立方体
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>
#import "oc_cube.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface ViewController () {
    
    float _jRotation;
    GLuint _jVertexBuffer;
}

@property (nonatomic, strong) EAGLContext   *jContext;

@property (nonatomic, strong) GLKBaseEffect *jEffect;

@end

@implementation ViewController

/*
 * 学习目标 简单的绘制一个立方体
 * 亮点 :使用系统封装好的对象来做 代码简洁，好维护
 * 实现步骤:
 * 第一步 .创建一个继承 GLKViewController(为我们封装了好多代码)的对象
 * 第二步 .创建一个EAGLContext 对象负责管理gpu的内存和指令
 * 第三步 .创建一个GLKBaseEffect 对象，负责管理渲染工作
 * 第四步 .创建立方体的顶点坐标和法线
 * 第五步 .清屏
 * 第六步 .绘图
 * 第七步 .让立方体运动其它
 * 第八步 .在视图消失的时候，做一些清理工作
 */

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 1. 创建管理上下文
    [self jCreateEAGLContext];
    // 2. 创建渲染管理
    [self jCreateBaseEffect];
    // 3. 添加顶点坐标和法线坐标
    [self jAddVertexAndNormal];
}
#pragma mark - GLKView and GLKViewController delegate methods
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    // 清屏
    [self jClearScreen];
    // 绘制
    [self jDrawView];
}

- (void)update {
    
    [self jChangeMoveTrack];
}

// 在视图消失的时候，做一些清理工作
- (void)dealloc {
    
    [self jClearDownGL];
    if ([EAGLContext currentContext] == self.jContext) {
        
        [EAGLContext setCurrentContext:nil];
    }
}

/**
 *  第二步:创建EAGContext 跟踪所有状态,命令和资源
 *  1. 创建管理上下文
*/
- (void)jCreateEAGLContext {
    
    self.jContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.jContext) {
        
        NSLog(@"手机不支持OpenGL es2");
    }
    [EAGLContext setCurrentContext:self.jContext];
    // 配置view
    GLKView *view = (GLKView *)self.view;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = self.jContext;
}

/**
 *  第三步: 创建GLKBaseEffect 对象
 *  3.创建渲染管理
 */
- (void)jCreateBaseEffect {
    
    self.jEffect = [[GLKBaseEffect alloc] init];
    self.jEffect.light0.enabled = GL_TRUE;
    // 设置颜色
    self.jEffect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
}

/**
 *  第四步 .创建立方体的顶点坐标和法线
 *  4.添加顶点坐标和法线坐标
 *  Vertex: 顶点  Normal: 法线
 */
- (void)jAddVertexAndNormal {
    
    // 开启深度测试 让被挡住的像素隐藏
    glEnable(GL_DEPTH_TEST);
    
    // 将顶点数据和法线数据加载到GUP中去
    glGenBuffers(1, &_jVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _jVertexBuffer); // 绑定顶点数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(jCubeVertexData), jCubeVertexData, GL_STATIC_DRAW);
    
    // 开启绘制命令GLKVertexAttribPosition(位置) 3: 顶点维数
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, 0);
    
    // 开启绘制命令 GLKVertexAttribPosition(法线) 3: 法线维数
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12)); // BUFFER: 缓冲
}

/**
 *  第五步 .清屏
 */
- (void)jClearScreen {
    
    glClearColor(0.6f, 0.6f, 0.6f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

/**
 *  第六步 .绘图
 */
- (void)jDrawView {
    
    [self.jEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 36); // 顶点个数: 36 = 2 * 6 * 3 一个面有两个三角形, 总共有6个面, 每个三角形有三个顶点
}

/**
 *  第七步 .改变立方体运动轨迹
 */
- (void)jChangeMoveTrack {
    
    // 获取一个屏幕比例值
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    
    // 透视转换
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    self.jEffect.transform.projectionMatrix = projectionMatrix;
    GLKMatrix4 baseModeViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -10.0f);
    // 计算自身坐标和旋转状态
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _jRotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModeViewMatrix, modelViewMatrix);
    self.jEffect.transform.modelviewMatrix = modelViewMatrix;
    _jRotation += self.timeSinceLastUpdate * 2.5f; // 旋转频率
}

/**
 *  第八步 .在视图消失的时候，做一些清理工作
 */
- (void)jClearDownGL {
    
    [EAGLContext setCurrentContext:self.jContext];
    glDeleteBuffers(1, &_jVertexBuffer);
    self.jEffect = nil;
}

/**
 *  隐藏状态栏
 */
- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end






























