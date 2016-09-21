//
//  ViewController.m
//  Study05-OpenGL绘制移动的球体
//
//  Created by 黄进文 on 16/9/11.
//  Copyright © 2016年 evenCoder. All rights reserved.
//


#import "ViewController.h"

@interface ViewController () {
    
    GLfloat *_jVertexArray; // 顶点
    GLubyte *_jColorsArray; // 颜色
    GLfloat *_jNormalArray; // 法线
    
    GLint   _jStacks;
    GLint   _jSlices;
    GLfloat _jScale;
    GLfloat _jSquash;
}

@property (nonatomic, strong) EAGLContext *jContext;

@end

@implementation ViewController

/**
 *  学习目标 绘制移动的球体 添加灯光
 *
 *  第一步: 创建GLKViewController 控制器(在里面实现方法)
 *  第二步: 创建EAGContext 跟踪所有状态,命令和资源
 *  第三步: 生成球体的顶点坐标和颜色数据
 *  第四步: 创建投影坐标系
 *  第五步: 创建视景体
 *  第六步: 添加多个光源
 *  第七步: 清除命令
 *  第八步: 创建对象坐标
 *  第九步: 导入顶点数据
 *  第十步: 导入颜色数据
 *  第十一步: 绘制
 *  欢迎加群: 578734141 交流学习~
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 2.创建EAGContext 跟踪所有状态 命令和资源
    self.jContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:self.jContext];
    // 配置View
    GLKView *view = (GLKView *)self.view;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = self.jContext;
    // 3.生成球体的顶点坐标和颜色数据
    [self createCalculate];
    // 4.创建投影坐标系
    glMatrixMode(GL_PROJECTION); // 投影矩阵
    glLoadIdentity(); // 设置当前矩阵为单位矩阵
    
    // 5.创建视景体
    [self setupClipping];
    
    // 6.添加多个光源
    [self createMultipleLighting];
}

/**
 *  渲染数据(代理方法)
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    // 7.清除命令
    [self clearCommand];
    
    // 8.创建对象坐标
    [self createModelViewMatrix];
    
    // 9. 导入顶点数据
    [self loadingVertexData];
    
    // 10.导入颜色数据
    [self loadingColorBuffer];
    
    // 11.绘制
    [self drawingView];
}

/**
 *  绘制
 */
- (void)drawingView {
    
    // 开启剔除面功能
    glEnable(GL_CULL_FACE);
    // 剔除背面
    glCullFace(GL_BACK);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (_jSlices + 1) * 2 * (_jStacks - 1) + 2);
}


/**
 *  导入颜色数据
 */
- (void)loadingColorBuffer {
    
    glEnableClientState(GL_COLOR_ARRAY); // 开启颜色模式
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, _jColorsArray);
}

/**
 *  导入顶点数据
 *  glVertexPointer 第一个参数:每个顶点数据的个数,第二个参数,顶点数据的数据类型,第三个偏移量，第四个顶点数组地址
 */
- (void)loadingVertexData {
    
    glEnableClientState(GL_VERTEX_ARRAY); // 开启顶点模式
    glVertexPointer(3, GL_FLOAT, 0, _jVertexArray);
    
    glEnableClientState(GL_NORMAL_ARRAY); // 开启法线模式
    glNormalPointer(GL_FLOAT, 0, _jNormalArray);
}

/**
 *  创建对象坐标
 */
- (void)createModelViewMatrix {
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    static GLfloat transY = 0.0;
    static GLfloat      z = -2;
    static CGFloat  scale = 1;
    static BOOL     isBig = true;
    
    if (isBig) {
        
        scale += 0.01;
    }
    else {
        
        scale -= 0.01;
    }
    // 球体缩放变化重要部分
    if (scale >= 1.5) {
        
        isBig = false;
    }
    if (scale <= 0.5) {
        
        isBig = true;
    }
    
    // 改变位置 大小
    static GLfloat spinX = 0;
    static GLfloat spinY = 0;
    glTranslatef(0.0, (GLfloat)(sinf(transY)/1.0), z);
    glRotatef(spinY, 0.0, 1.0, 0.0);
    glRotatef(spinX, 1.0, 0.0, 0.0);
    glScalef(scale, scale, scale);
    transY += 0.075f;
    spinY  += .25;
    spinX  += .25;
}


/**
 *  清除命令
 */
- (void)clearCommand {
    
    glEnable(GL_DEPTH_TEST);
    glClearColor(1, 1, 1, 0.1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

/**
 *  创建多个光源
 */
- (void)createMultipleLighting {
    
    // 创建灯光的位置
    GLfloat posMain[]  = {  5.0,  4.0, 6.0, 1.0};
    GLfloat posFill1[] = {-15.0, 15.0, 0.0, 1.0};
    GLfloat posFill2[] = {-10.0, -4.0, 1.0, 1.0};
    GLfloat white[]    = {  1.0,  1.0, 1.0, 1.0};
    
    // 定义几种颜色值
    GLfloat dimblue[] = {0.0, 0.0, .2, 1.0};
    GLfloat cyan[]    = {0.0, 1.0, 1.0, 1.0};
    GLfloat yellow[]  = {1.0, 1.0, 0.0, 1.0};
    
    GLfloat dimmagenta[] = { .75, 0.0, .25, 1.0};
    GLfloat dimcyan[]    = { 0.0,  .5,  .5, 1.0};
    
    // 光源1.设置反射光的位置和颜色
    glLightfv(GL_LIGHT0, GL_POSITION, posMain);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, white);
    // 设置镜面光的颜色 它的光源和反射光是同一个光源
    glLightfv(GL_LIGHT0, GL_SPECULAR, yellow);
    
    // 光源2.设置光源2的位置和类型
    glLightfv(GL_LIGHT1, GL_POSITION, posFill1);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, dimblue);
    glLightfv(GL_LIGHT1, GL_SPECULAR, dimcyan);
    
    // 光源3.设置光源3的位置和类型
    glLightfv(GL_LIGHT2, GL_POSITION, posFill2);
    glLightfv(GL_LIGHT2, GL_DIFFUSE, dimblue);
    glLightfv(GL_LIGHT2, GL_SPECULAR, dimmagenta);
    
    // 设置衰减因子
    glLightf(GL_LIGHT2, GL_QUADRATIC_ATTENUATION, .005);
    
    // 设置材料在镜面光照下的颜色(GL_DIFFUSE: 反射光 GL_SPECULAR: 镜面光)
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, cyan);
    
    // 设置材料在镜面光下的颜色
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, white);
    
    // 解析：
    glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 25);
    
    // 设置光照模式GL_SMOOTH代表均匀的颜色屠宰表面上
    glShadeModel(GL_SMOOTH);
    glLightModelf(GL_LIGHT_MODEL_TWO_SIDE, 0.0);
    
    // 开启灯光模式
    glEnable(GL_LIGHTING);
    
    // 打开灯光1 2 3
    glEnable(GL_LIGHT0);
    glEnable(GL_LIGHT1);
    glEnable(GL_LIGHT2);
}

/**
 *  设置窗口及投影坐标的位置
 */
- (void)setupClipping {
    
    float aspectRatio;
    const float zNear = .1;
    const float zFar  = 1000;
    const float fieldOfView = 60.0;
    GLfloat size;
    CGRect  frame = [[UIScreen mainScreen] bounds];
    // 比例
    aspectRatio = (float)frame.size.width / (float)frame.size.height;
    size = zNear * tanf(GLKMathDegreesToRadians(fieldOfView) / 2.0);
    // 设置视图窗口的大小和坐标系统
    glFrustumf(-size, size, -size / aspectRatio, size / aspectRatio, zNear, zFar);
    glViewport(0, 0, frame.size.width, frame.size.height);  // 窗口大小
}

/**
 *  生成球体的顶点坐标和颜色数据
 */
- (void)createCalculate {
    
    unsigned int colorIncrement = 0;
    unsigned int           blue = 0;
    unsigned int            red = 255;
    unsigned int          green = 0;
    static int              big = 1;
    static float           scale = 0;
    // 球体缩放比例
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
    // 初始胡数据
    _jScale  = 0.5 + scale;
    _jSlices = 100;
    _jSquash = 1;
    _jStacks = 100;
    colorIncrement = 255 / _jStacks;
    
    // vertices顶点
    GLfloat *verPtr = _jVertexArray = (GLfloat *)malloc(sizeof(GLfloat) * 3 * ((_jSlices * 2 + 2) * (_jStacks)));
    //color data 颜色数据
    GLubyte *colorPtr = _jColorsArray = (GLubyte *)malloc(sizeof(GLubyte) * 4 * ((_jSlices * 2 + 2) * (_jStacks)));
    // normal
    GLfloat *normalPtr = _jNormalArray = (GLfloat*)malloc(sizeof(GLfloat) * 3 * ((_jSlices * 2 + 2) * (_jStacks)));
    
    //latitude
    unsigned int phiIndex, thetaIndex;
    for(phiIndex = 0; phiIndex < _jStacks; phiIndex++)		//5
    {
        
        float phi0 = M_PI * ((float)(phiIndex + 0) * (1.0f/(float)( _jStacks)) - 0.5f);
        float phi1 = M_PI * ((float)(phiIndex + 1) * (1.0f/(float)( _jStacks)) - 0.5f);
        float cosPhi0 = cos(phi0);
        float sinPhi0 = sin(phi0);
        float cosPhi1 = cos(phi1);
        float sinPhi1 = sin(phi1);
        
        float cosTheta, sinTheta;
        for(thetaIndex = 0; thetaIndex < _jSlices; thetaIndex++)
        {
            
            
            float theta = 2.0f * M_PI * ((float)thetaIndex) * (1.0f/(float)( _jSlices -1));
            cosTheta = cos(theta);
            sinTheta = sin(theta);
            
            
            verPtr [0] = _jScale * cosPhi0 * cosTheta;
            verPtr [1] = _jScale * sinPhi0 * _jSquash;
            verPtr [2] = _jScale * cosPhi0 * sinTheta;
            
            
            
            verPtr [3] = _jScale * cosPhi1 * cosTheta;
            verPtr [4] = _jScale * sinPhi1 * _jSquash;
            verPtr [5] = _jScale * cosPhi1 * sinTheta;
            
            colorPtr [0] = red;
            colorPtr [1] = green;
            colorPtr [2] = blue;
            colorPtr [4] = red;
            colorPtr [5] = green;
            colorPtr [6] = blue;
            colorPtr [3] = colorPtr[7] = 255;
            
            // Normal pointers for lighting
            
            normalPtr[0] = cosPhi0 * cosTheta; 	//2
            normalPtr[1] = sinPhi0;
            normalPtr[2] = cosPhi0 * sinTheta;
            
            normalPtr[3] = cosPhi1 * cosTheta; 	//3
            normalPtr[4] = sinPhi1;
            normalPtr[5] = cosPhi1 * sinTheta;
            
            colorPtr  += 2 * 4;
            
            verPtr    += 2 * 3;
            
            normalPtr += 2 * 3;
        }
        
        //blue+=colorIncrment;
        red -= colorIncrement;
        // green += colorIncrment;
    }
}

@end

































