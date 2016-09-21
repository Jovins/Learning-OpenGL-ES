//
//  JWCaptureView.h
//  Study11-OpenGL实战旋转图表
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>

typedef void (^Callback)(CGImageRef image);

@interface JWCaptureView : UIView

@property (nonatomic, strong) Callback callback;

- (void)setup:(Callback)callback;

@end
