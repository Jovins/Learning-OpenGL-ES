//
//  JWCaptureView.m
//  Study11-OpenGL实战旋转图表
//
//  Created by 黄进文 on 16/9/13.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "JWCaptureView.h"

@interface JWCaptureView() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *jCaptureSession; // 捕捉视图会话对象

@property (nonatomic, strong) CALayer *jPreviewLayer; // 显示视频的layer层

@property (nonatomic, strong) CIFilter *jFilter; // 滤波器

@property (nonatomic, strong) CIContext *jContext;

@end

@implementation JWCaptureView

#pragma mark - 懒加载
- (CIContext *)jContext {
    
    if (_jContext) {
        
        return _jContext;
    }
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSDictionary *options = @{kCIContextWorkingColorSpace: [NSNull null]};
    return [CIContext contextWithEAGLContext:context options:options];
}

#pragma mark - 初始化
- (void)setup:(Callback)callback {
    
    self.callback = callback;
    // 创建layer层
    self.jPreviewLayer = [CALayer layer];
    self.jPreviewLayer.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    
    // 调整摄像头位置
    self.jPreviewLayer.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    [self.jPreviewLayer setAffineTransform:CGAffineTransformMakeRotation(M_PI * 0.5)];
    [self.layer addSublayer:self.jPreviewLayer];
    
    // 创建摄像会话层
    self.jCaptureSession = [[AVCaptureSession alloc] init];
    [self.jCaptureSession beginConfiguration];
    self.jCaptureSession.sessionPreset = AVCaptureSessionPresetLow;
    AVCaptureDevice *captureDevice = [self getCameraDevice:AVCaptureDevicePositionBack];
    AVCaptureInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if ([self.jCaptureSession canAddInput:captureInput]) {
        
        [self.jCaptureSession addInput:captureInput];
    }
    
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    videoOutput.alwaysDiscardsLateVideoFrames = YES;
    if ([self.jCaptureSession canAddOutput:videoOutput]) {
        
        [self.jCaptureSession addOutput:videoOutput];
    }
    // 设置代理
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    [videoOutput setSampleBufferDelegate:self queue:queue];
    [self.jCaptureSession commitConfiguration];
    [self.jCaptureSession startRunning];
}

#pragma mark - <AVCaptureVideoDataOutputSampleBufferDelegate>
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CGImageRef imageRef = [self.jContext createCGImage:ciImage fromRect:ciImage.extent];
    dispatch_async(dispatch_get_main_queue(), ^{
       
        self.jPreviewLayer.contents = (__bridge id _Nullable)(imageRef);
    });
}

/**
 *  获取输入源
 */
- (AVCaptureDevice *)getCameraDevice:(AVCaptureDevicePosition)position {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]; // 获取设备
    for (AVCaptureDevice *device in devices) {
        
        if (device.position == position) {
            
            return device;
        }
    }
    return nil;
}


@end




















































