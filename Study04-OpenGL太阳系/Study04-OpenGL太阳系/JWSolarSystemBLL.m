//
//  JWSolarSystemBLL.m
//  Study04-OpenGL太阳系
//
//  Created by 黄进文 on 16/9/11.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "JWSolarSystemBLL.h"

@implementation JWSolarSystemBLL

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initGeometry];
    }
    return self;
}

/**
 *  初始化数据
 */
- (void)initGeometry {
    
    j_Eyeposition[X_VALUE] = 0.0;				//1
    j_Eyeposition[Y_VALUE] = 0.0;
    j_Eyeposition[Z_VALUE] = 10.0;
    
    j_Sun = [[JWPlanet alloc] init:50 slices:50 radius:1.5 squash:1.0]; //2
    [j_Sun setPositionX:0.0 Y:0.0 Z:0];
    
    j_Earth=[[JWPlanet alloc] init:50 slices:50 radius:0.5 squash:1.0]; //3
    [j_Earth setPositionX:0 Y:0.0 Z:0];
    
    j_Month=[[JWPlanet alloc] init:50 slices:50 radius:0.2 squash:1.0];	//4
    [j_Month setPositionX:0 Y:0.0 Z:0];
}

- (void)execute {
    
    // 设置球体颜色
    GLfloat paleYellow[] = {212.0/255, 207.0/255, 208.0/255, 1.0};
    GLfloat white[] = {1.0, 1.0, 1.0, 1.0}; // 白色
    GLfloat cyan[] = {1.0, 1.0, 1.0, 1.0};  // 白色
    GLfloat red[] = {252.0/255, 75.0/255, 50.0/255, 1.0}; // 橘红
    GLfloat blue[] = {49.0/255, 126.0/255, 251.0/255, 1.0};  // 浅蓝色
    static GLfloat angle = 0.0;
    GLfloat orbitalIncrement = 5.25;
    static float monthAngle = 0;
    GLfloat monthInc = 0.2;
    GLfloat sunPos[4] = {0.0, 0.0, 0.0, 1.0};
				
    angle += orbitalIncrement;
    monthAngle += monthInc;

    // glPushMatrix、glPopMatrix操作事实上就相当于栈里的入栈和出栈。
    glPushMatrix();	// 将当前矩阵堆栈推送，通过一个，复制当前矩阵。这就是后glPushMatrix的调用堆栈的顶部矩阵是它下面的相同的。					//4
    
    // 向那个方向移动(三维)
    glTranslatef(-j_Eyeposition[X_VALUE], -j_Eyeposition[Y_VALUE], -6); // 5
    
    
    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, red);	//15
    glLightfv(SS_SUNLIGHT,GL_POSITION,sunPos);		     // 设置灯光的位置
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, cyan);   // 设置材料正面面能发射的光的颜色
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, white); // 设置材料能发射的镜面光颜色
    
    glPushMatrix();
    glPushMatrix();
    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, red);
    [self executePlanet:j_Sun];
    glPopMatrix();
    
    
    glRotatef(monthAngle, 0, 1, 0);
    glTranslatef(0,0,3);
    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, blue);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, blue);
    
    // glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, black);	//13
    [self executePlanet:j_Earth];
    
    glPushMatrix();
    glRotatef(angle, 0, 1, 0);
    glTranslatef(0,0,0.8);
    
    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, paleYellow);	//12
    [self executePlanet:j_Month];
    
    glPopMatrix();
    glPopMatrix();
    glPopMatrix();
}

- (void)executePlanet:(JWPlanet *)planet {
    
    GLfloat posX, posY, posZ;
    
    //glPushMatrix();
    
    [planet getPositionX:&posX Y:&posY Z:&posZ];			//17
    
    //glTranslatef(posX,posY,posZ);				//18
    
    
    [planet execute];						//19
    
    //glPopMatrix();
}

@end








































