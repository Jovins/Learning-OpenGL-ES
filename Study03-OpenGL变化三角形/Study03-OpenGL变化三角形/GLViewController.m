//
//  GLViewController.m
//  Study03-OpenGL变化三角形
//
//  Created by 黄进文 on 16/9/8.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "GLViewController.h"

@interface GLViewController()

@property (nonatomic, strong) EAGLContext *jContext;


@end

@implementation GLViewController {
    
    GLuint _program;
    GLuint _vertexColor;
    GLuint _vertexBuffer;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 创建一个EAGContext 对象，用来跟踪OpenGL 的状态和管理数据和命令
    self.jContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    // 配置GLKView(刚才创建的控制器的view的类型就是GLKView类型)
    GLKView *view = (GLKView *)self.view;
    view.context = self.jContext;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:self.jContext];
    
    // 编译.vsh和.fsh
    [self complieVSHAndFSH];
    
    // 获取着色器中输入变量的索引值
    _vertexColor =  glGetUniformLocation(_program, "color");
    
    // 将顶点数据加载到GPU 中去
    // 三角形顶点数据
    static GLfloat vertexData[] = {
        
        0,  1,  // 正上
        -1, 0,  // 左
        1,  0,  // 右
    };
    
    // 将顶点数据加载到GPU
    glGenBuffers(1, &_vertexBuffer); // 申请内存标识
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer); // 绑定
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW); // 申请内存空间
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 8, 0); // 设置指针(2代表2维(x, y))
    /**
     void glVertexAttribPointer(	GLuint index,
                                    GLint size,
                                    GLenum type,
                                    GLboolean normalized,
                                    GLsizei stride,
                                    const GLvoid * pointer);
     Parameters
     index
     指定要修改的顶点属性的索引值
     size
     指定每个顶点属性的组件数量。必须为1、2、3或者4。初始值为4。（梦维：如position是由3个（x,y,z）组成，而颜色是4个（r,g,b,a））
     type
     指定数组中每个组件的数据类型。可用的符号常量有GL_BYTE, GL_UNSIGNED_BYTE, GL_SHORT,GL_UNSIGNED_SHORT, GL_FIXED, 和 GL_FLOAT，初始值为GL_FLOAT。
     normalized
     指定当被访问时，固定点数据值是否应该被归一化（GL_TRUE）或者直接转换为固定点值（GL_FALSE）。
     stride
     指定连续顶点属性之间的偏移量。如果为0，那么顶点属性会被理解为：它们是紧密排列在一起的。初始值为0。
     pointer
     指定一个指针，指向数组中第一个顶点属性的第一个组件。初始值为0。
     */
}

/**
 *  渲染数据
 *  继承父类方法
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    static NSInteger count = 0;
    // 清除颜色缓冲区
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    count++;
    if (count > 50) {
        
        count = 0;
        // 根据颜色索引值,设置颜色数据，就是刚才我们从着色器程序中获取的颜色索引值
        glUniform4f(_vertexColor, arc4random_uniform(255)/255.0, arc4random_uniform(255)/255.0, arc4random_uniform(255)/255.0, 1.0); // 随机颜色
    }
    // 使用着色器程序
    glUseProgram(_program);
    // 绘制
    glDrawArrays(GL_TRIANGLES, 0, 3); // 只能画三角形
    /**
     glDrawArrays(int mode, int first,int count)
     1.GL_TRIANGLES：每三个顶之间绘制三角形，之间不连接
     
     2.GL_TRIANGLE_FAN：以V0V1V2,V0V2V3,V0V3V4，……的形式绘制三角形
     
     3.GL_TRIANGLE_STRIP：顺序在每三个顶点之间均绘制三角形。这个方法可以保证从相同的方向上所有三角形均被绘制。以V0V1V2,V1V2V3,V2V3V4……的形式绘制三角形
     */
}

#pragma mark - 编译两个顶点着色器程序和片断着色器源代码
- (void)complieVSHAndFSH {
    
    // 创建标示
    GLuint vertShader, fragShader;
    // 获取路径
    NSString *vertShaderPath, *fragShaderPath;
    vertShaderPath = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    fragShaderPath = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    // 编译
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPath]) {
        NSLog(@"编译失败 vertex shader");
    }
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPath]) {
        NSLog(@"编译失败 fragment shader");
    }
    
    // 创建着一个空的色器程序，把刚才编译好的两个着色器目标代码，连接到这个空的程序中去
    _program = glCreateProgram();
    // 将顶点着色器加到程序中
    glAttachShader(_program, vertShader);
    // 将片段着色器加到程序中国
    glAttachShader(_program, fragShader);
    // 将着色器程序的属性绑定到OpenGL 中
    glBindAttribLocation(_program, 0, "position");  // 0代表枚举位置
    
    // 开始正式链接着色器程序
    if (![self linkProgram:_program]) {
        
         NSLog(@"Failed to link program: %d", _program);
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            
            glDeleteProgram(_program);
            _program = 0;
        }
    }
}

#pragma mark - 链接着色器程序
- (BOOL)linkProgram:(GLuint)program {
    
    // 链接程序
    glLinkProgram(program);
    
    // 调试时打印日记
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(program, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    // 检查链接结果
    GLint status;
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status == 0) {
        
        NSLog(@"链接着色器程序失败！status : %zd", status);
        return NO;
    }
    return YES;
}

#pragma mark - 编译
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    
    //  获取文件的内容 并进行NSUTF8StringEncoding 编码
    const GLchar *source;
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    // 根据类型创建着色器
    *shader = glCreateShader(type);
    // 获取着色器的数据源
    glShaderSource(*shader, 1, &source, NULL);
    // 开始编译
    glCompileShader(*shader);
    // 方便调试，打印编译日记
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"shader compile log:\n%s", log);
        free(log);
    }
#endif
    // 查看编译是否成功
    GLint status;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        
        glDeleteShader(*shader);
        NSLog(@"编译失败 status : %zd！", status);
        return NO;
    }
    else {
        
        NSLog(@"编译成功！");
    }
    return YES;
}

@end







































