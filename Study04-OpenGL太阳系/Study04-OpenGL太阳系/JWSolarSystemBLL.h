//
//  JWSolarSystemBLL.h
//  Study04-OpenGL太阳系
//
//  Created by 黄进文 on 16/9/11.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWPlanet.h"
#import <OpenGLES/ES1/gl.h>

#define X_VALUE 0
#define Y_VALUE 1
#define Z_VALUE 2

@interface JWSolarSystemBLL : NSObject {
    
    JWPlanet *j_Sun;
    JWPlanet *j_Earth;
    JWPlanet *j_Month;
    GLfloat	  j_Eyeposition[3];
}

- (instancetype)init;
- (void)execute;
- (void)executePlanet:(JWPlanet *)planet;
- (void)initGeometry;

@end





























