//
//  CGMetalVideoReaderInput.h
//  CGMetal
//
//  Created by Jason on 2021/12/1.
//

#import "CGMetalOutput.h"
#import "CGMetalPixelBufferInput.h"

@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@class CGMetalVideoInput;
@protocol CGMetalVideoReadDelegate <NSObject>

- (void)videoReader:(CGMetalVideoInput *)videoEncoder onProgress:(float)progress;

- (void)didCompletePlayingMovie;

@end

@interface CGMetalVideoInput : CGMetalOutput

@property (readwrite, nonatomic, assign) id <CGMetalVideoReadDelegate>delegate;

- (instancetype)initWithURL:(NSURL *)url pixelFormat:(CGPixelFormat)pixelFormat;

- (void)cancelReader;

@end

NS_ASSUME_NONNULL_END
