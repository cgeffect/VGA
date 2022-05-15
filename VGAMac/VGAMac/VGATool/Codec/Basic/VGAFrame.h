//
// Created by Jason on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import "VGACodecConstant.h"
@import CoreMedia;

NS_ASSUME_NONNULL_BEGIN

@interface VGAFrame : NSObject

- (void)destroy;

@end

@interface VGAVideoFrame : VGAFrame {
@protected
    AVTPixelFormat _pixelFormat;
}

@property(nonatomic, assign) UInt8 *data;
@property(nonatomic, assign) int width;
@property(nonatomic, assign) int height;
@property(nonatomic, assign) int size;
@property(nonatomic, assign) int rotate;
@property(nonatomic, assign, readonly) AVTPixelFormat pixelFormat;
@property(nonatomic, assign) CVPixelBufferRef buffer;
@property(nonatomic, assign) CMTime time;
- (instancetype)initWithWidth:(int)width height:(int)height size:(int)size;

- (instancetype)initWithWidth:(int)width height:(int)height size:(int)size
                  pixelFormat:(AVTPixelFormat)pixelFormat;

+ (instancetype)frameWithWidth:(int)width height:(int)height size:(int)size;

+ (instancetype)frameWithWidth:(int)width height:(int)height size:(int)size
                   pixelFormat:(AVTPixelFormat)pixelFormat;

- (void)setPixelFormat:(AVTPixelFormat)pixelFormat;

@end

NS_ASSUME_NONNULL_END
