//
//  CGMetalPixelBufferInput.h
//  CGMetal
//
//  Created by Jason on 2021/6/1.
//

#import "CGMetalOutput.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CGPixelFormat) {
    CGPixelFormatBGRA,
    CGPixelFormatNV12
};

@interface CGMetalPixelBufferInput : CGMetalOutput

- (instancetype)initWithFormat:(CGPixelFormat)pixelFormat;

- (void)uploadPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (void)updatePixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
