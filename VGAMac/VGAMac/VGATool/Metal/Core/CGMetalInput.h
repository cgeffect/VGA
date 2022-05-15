//
//  CGMetalInput.h
//  CGMetal
//
//  Created by Jason on 2021/5/13.
//  Copyright © 2021 CGMetal. All rights reserved.
//

@import Foundation;
@import CoreMedia;
#import "CGMetalTexture.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CGMetalRotationMode) {
    kCGMetalNoRotation,
    kCGMetalRotateLeft,
    kCGMetalRotateRight,
    kCGMetalFlipVertical,
    kCGMetalFlipHorizonal,
    kCGMetalRotateRightFlipVertical,
    kCGMetalRotateRightFlipHorizontal,
    kCGMetalRotate180
};

typedef NS_ENUM(NSUInteger, CGMetalContentMode)
{
    CGMetalContentModeScaleToFill,
    CGMetalContentModeScaleAspectFit,
    CGMetalContentModeScaleAspectFill
};

typedef NS_ENUM(NSInteger, CGMetalAlphaMode) {
    CGMetalAlphaModeNone,
    CGMetalAlphaModeLeftAlpha,
    CGMetalAlphaModeLeftScaleAlpha,
    CGMetalAlphaModeRightAlpha,
    CGMetalAlphaModeRightScaleAlpha,
    CGMetalAlphaModeHevcWithAlpha,
    CGMetalAlphaModeRGBA
};

#pragma mark -
#pragma mark subclass implementation
@protocol CGMetalRenderEvent <NSObject>
/**
 * setp1
 * set Vertex/Fragment value
 */
- (void)mslEncodeCompleted;
/**
 * setp2
 * Receive the parameter passed in from the previous filter
 */
- (void)newTextureInput:(CGMetalTexture *)texture;
/**
 * setp3
 * Parameter ready, ready to render
 */
- (void)prepareScheduled;
/**
 * setp4
 * render finished
 */
- (void)renderCompleted;

@end

@protocol CGMetalInput <NSObject>

//协议中定义属性, 实现类使用 @synthesize 关键字使用, 目的是把公共的一些属性抽象出来
@property(nonatomic, strong)CGMetalTexture *inTexture;

- (void)newTextureAvailable:(CGMetalTexture *)inTexture;

@optional
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;

- (void)setInputRotation:(CGMetalRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;

- (void)stopRender:(BOOL)isComplete;

- (void)_waitUntilCompleted;

- (void)_waitUntilScheduled;

@end

@protocol CGMetalViewOutput <NSObject>
@property(nonatomic, assign)CGMetalContentMode contentMode;
@property(nonatomic, assign)BOOL isWaitUntilCompleted;
@property(nonatomic, assign)BOOL isWaitUntilScheduled;
@end

@protocol CGMetalPlayerInput <NSObject>

- (instancetype)initWithURL:(NSURL *)url;

- (void)play;

- (void)pause;

- (void)resume;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
