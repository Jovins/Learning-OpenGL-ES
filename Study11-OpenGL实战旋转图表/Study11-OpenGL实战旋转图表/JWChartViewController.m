//
//  JWChartViewController.m
//  Study11-OpenGL实战旋转图表
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "JWChartViewController.h"
#import <OpenGLES/ES2/glext.h>
#import "JWCube.h"


#define BUFFER_OFFSET(i) ((char *)NULL + (i))
#define WIDTH   0.1

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface JWChartViewController() {
    
    float _jRotation;
    GLuint _jVertexArray;
    GLuint _jVertexBuffer;
    GLuint _jNormalBuffer;
}

@property (nonatomic, strong) EAGLContext *jContext;

@property (nonatomic, strong) GLKBaseEffect *jBaseEffect;

@property (nonatomic, strong) GLKBaseEffect *jLightEffect;

@property (nonatomic, strong) NSMutableArray *jValues;

@property (nonatomic, strong) NSArray *jTargetValues;

@property (nonatomic, assign) BOOL isRotation; // 是否旋转

@end


@implementation JWChartViewController

- (instancetype)initWithChartData:(NSArray *)chartData {
    
    if (self = [super init]) {
        
        [self jLoadData:chartData];
    }
    return self;
}

- (void)jLoadData:(NSArray *)data {
    
    self.jTargetValues = data;
    self.jValues = [NSMutableArray arrayWithArray:self.jTargetValues];
    for (int i = 0; i < self.jValues.count; i++) {
        
        self.jValues[i] = @(0);
    }
}

- (void)startRotation {
    
    self.isRotation = true;
    _jRotation = 0;
}

- (void)stopRotation {
    
    self.isRotation = false;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 跟踪所有状态,命令和资源
    self.jContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.jContext) {
        
        NSLog(@"Failed to create ES context");
    }
    GLKView *view = (GLKView *)self.view;
    view.context = self.jContext;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.jContext];
    // 着色器初始化
    self.jBaseEffect = [[GLKBaseEffect alloc] init]; // 实现OpenGL ES 1.1规范中的关键的灯光和材料模式
    self.jBaseEffect.light0.enabled = GL_TRUE;
    self.jBaseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 0.0f, 1.0f, 1.0f);
    
    self.jLightEffect = [[GLKBaseEffect alloc] init];
    self.jLightEffect.light0.enabled = GL_TRUE;
    self.jLightEffect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    /*
     glEnable(GL_DEPTH_TEST);
     当前像素前面是否有别的像素，如果别的像素挡道了它，那它就不会绘制，也就是说，OpenGL就只绘制最前面的一层。
     用来开启更新深度缓冲区的功能，也就是，如果通过比较后深度值发生变化了，会进行更新深度缓冲区的操作。
     启动它，OpenGL就可以跟踪在Z轴上的像素，这样，它只会再那个像素前方没有东西时，才会绘画这个像素。
     在做绘画3D时，这个功能最好启动，视觉效果比较真实。
     */
    glEnable(GL_DEPTH_TEST);
}

#pragma mark - 代理
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    CGFloat width = 2.0 / self.jValues.count ;
    for (int i = 0; i < self.jValues.count; i++) {
        
        CGFloat value = 2.0 / (CGFloat)self.view.bounds.size.height * [self.jValues[i] floatValue];
        switch (i) {
            case 0:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
                break;
            case 1:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 0.0f, 1.0f, 1.0f);
                break;
            case 2:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
                break;
            case 3:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
                break;
            case 4:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
                break;
            case 5:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(0.0f, 1.0f, 1.0f, 1.0f);
                break;
            case 6:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(0.1f, 0.3f, 1.0f, 1.0f);
                break;
            case 7:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(0.9f, 0.1f, 0.3f, 1.0f);
                break;
            case 8:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(   1, 0.3f, 0.4f, 1.0f);
                break;
            case 9:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(0.6f, 0.1f, 0.3f, 1.0f);
                break;
            case 10:
                self.jBaseEffect.light0.diffuseColor = GLKVector4Make(0.5f, 0.1f,    7, 1.0f);
                break;
                
            default:
                break;
        }
        
        [self.jBaseEffect prepareToDraw];
        [self jDrawCubePostitonX: -1 + i * width Max:value width:width - 0.1];
    }

}

-(void)jDrawCubePostitonX:(CGFloat)x Max:(CGFloat)max width:(CGFloat)width {
    
    // 立方体模型
    JWCube *cube = [JWCube jCubeWithPosition:[JWPosition jPositionMakeX:x Y:-1 Z:0] width:width height:max lenght:width];
    
    glGenBuffers(1, &_jVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _jVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, cube.number * sizeof(GLfloat), cube.vertex, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    
    glDrawArrays(GL_TRIANGLES, 0, 36); // 36 = 2 * 6 * 3
    glDeleteBuffers(1, &_jVertexBuffer);
}

#pragma mark - update 旋转移动
- (void)update {
    
    static GLfloat radious = 0; // 旋转角度
    radious += 1;
    if (radious >= 65) {
        
        radious = 65.0f;
    }
    
    for (int i = 0; i < self.jTargetValues.count;i++){
        if ([self.jTargetValues[i] floatValue] > [self.jValues[i] floatValue]) {
            
            self.jValues[i] = @([self.jValues[i] floatValue] + 5);
        }
    }
    if (self.isRotation){
        
        _jRotation += self.timeSinceLastUpdate * 0.5f;
    }
    
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(radious), aspect, 0.1f, 10.0f);
    self.jBaseEffect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _jRotation, 0.0f, 1.0f, 0.0f);
    self.jBaseEffect.transform.modelviewMatrix = baseModelViewMatrix;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        
        self.view = nil;
        [EAGLContext setCurrentContext:self.jContext];
        glDeleteBuffers(1, &_jVertexBuffer); // 清理顶点缓存
        glDeleteVertexArraysOES(1, &_jVertexArray);
        self.jBaseEffect = nil;
        if ([EAGLContext currentContext] == self.jContext) {
            
            [EAGLContext setCurrentContext:nil];
        }
    }
}

/**
 *  清理数据
 */
- (void)dealloc {
    
    [EAGLContext setCurrentContext:self.jContext];
    glDeleteBuffers(1, &_jVertexBuffer); // 清理顶点缓存
    glDeleteVertexArraysOES(1, &_jVertexArray);
    self.jBaseEffect = nil;
    if ([EAGLContext currentContext] == self.jContext) {
        
        [EAGLContext setCurrentContext:nil];
    }
}

/**
 *  隐藏状态栏
 */
- (BOOL)prefersStatusBarHidden {
    
    return YES;
}
@end




























