//
//  ViewController.m
//  Study01-OpenGL ES
//
//  Created by 黄进文 on 16/9/8.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *jContext;

@property (nonatomic, strong) GLKBaseEffect *jEffect;

@property (nonatomic, assign) int jCount;

@end

@implementation ViewController

/**
 用尽量少的代码实现把一张图片绘制到屏幕
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建OpenGL 上下文
    self.jContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3]; // 有3.0 2.0 1.0
    GLKView *jView = (GLKView *)self.view;  // 在storyboard那里添加GLKView
    jView.context = self.jContext;
    jView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888; // 设置颜色缓冲区格式
    [EAGLContext setCurrentContext:self.jContext];
    
    // 设置顶点数据 前三个是顶点坐标 后面是纹理坐标
    /**
    OpenGLES的世界坐标系是[-1, 1]，故而点(0, 0)是在屏幕的正中间。
    纹理坐标系的取值范围是[0, 1]，原点是在左下角。故而点(0, 0)在左下角，点(1, 1)在右上角。
     */
    GLfloat squareData[] = {
        
                // 0.0f 以原点(0， 0)作为参考系
        0.5, -0.5, 0.0f,   1.0f, 0.0f,  // 右下
        -0.5, 0.5, 0.0f,   0.0f, 1.0f,  // 左上
        -0.5, -0.5, 0.0f,  0.0f, 0.0f, // 左下
        0.5, 0.5, 0.0f,   1.0f, 1.0f, // 右上
    };
    
    // 设置顶点索引
    // 索引数组是顶点数组的索引，把squareData数组看成4个顶点，每个顶点会有5个GLfloat数据，索引从0开始。
    GLuint indexData[] = {
      
        0, 1, 2,
        1, 3, 0
    };
    self.jCount = sizeof(indexData) / sizeof(GLuint);
    
    // 顶点数据缓存
    GLuint square;
    glGenBuffers(1, &square); // 申请一个标识符
    glBindBuffer(GL_ARRAY_BUFFER, square); // 把标识符绑定到GL_ARRAY_BUFFER上
    // 把顶点数据从cpu内存复制到gpu内存
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareData), squareData, GL_STATIC_DRAW);
    
    // 索引缓存
    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index); // 把标识符绑定到GL_ELEMENT_ARRAY_BUFFER上
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indexData), indexData, GL_STATIC_DRAW);
    
    // 顶点数据缓存
    glEnableVertexAttribArray(GLKVertexAttribPosition); // 是开启对应的顶点属性
    // 设置合适的格式从buffer里面读取数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);  // 纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
    
    // 获取纹理贴图
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"kate" ofType:@"png"];
    // GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    
    // GLKTextureLoader读取图片，创建纹理GLKTextureInfo
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    // 着色器 创建着色器GLKBaseEffect，把纹理赋值给着色器
    self.jEffect = [[GLKBaseEffect alloc] init];
    self.jEffect.texture2d0.enabled = GL_TRUE;
    self.jEffect.texture2d0.name = info.name;
}


/**
 *  渲染场景代码(系统自动调用)
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.jEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.jCount, GL_UNSIGNED_INT, 0);
}


@end





































