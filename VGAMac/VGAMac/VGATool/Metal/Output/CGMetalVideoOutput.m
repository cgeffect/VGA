//
//  CGMetalVideoSurfaceOutput.m
//  CGMetal
//
//  Created by Jason on 2021/12/1.
//

#import "CGMetalVideoOutput.h"
#import "VGAVideoEncoder.h"
#import "CGMetalPixelBufferSurfaceOutput.h"

@interface CGMetalVideoOutput ()<CGVideoEncoderDelegate, CGMetalRenderOutputDelegate>
{
    BOOL _isStart;
    CMTime _time;
}
@property(nonatomic, strong)VGAVideoEncoder *videoEncode;
@property(nonatomic, strong)NSURL *dstURL;
@property(nonatomic, strong)CGMetalPixelBufferSurfaceOutput *surfaceOutput;
@end

@implementation CGMetalVideoOutput

@synthesize inTexture = _inTexture;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_videoEncode = [[VGAVideoEncoder alloc] init];
        self->_videoEncode.delegate = self;

        _surfaceOutput = [[CGMetalPixelBufferSurfaceOutput alloc] init];
        _surfaceOutput.delegate = self;
    }
    return self;
}

- (instancetype)initWithVideoURL:(NSURL *)dstURL fileType:(NSString *)newFileType outputSettings:(NSMutableDictionary *)outputSettings {
    self = [self init];
    if (self) {
        _dstURL = dstURL;
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtURL:dstURL error:&error];
        NSLog(@"dstURL: %@", dstURL.relativePath);
    }
    return self;
}

- (void)newTextureAvailable:(nonnull CGMetalTexture *)inTexture {
    _inTexture = inTexture;
    
    [_surfaceOutput newTextureAvailable:inTexture];
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex {
    _time = frameTime;
}
- (void)stopRender:(BOOL)isComplete {
    [_videoEncode stopEncode];
}

#pragma mark - CGMetalRenderOutputDelegate
- (void)onRenderCompleted:(CGMetalPixelBufferSurfaceOutput *)thiz receivedPixelBufferFromTexture:(CVPixelBufferRef)pixelBuffer {
//    int width = (int)CVPixelBufferGetWidth(pixelBuffer);
//    int height = (int)CVPixelBufferGetHeight(pixelBuffer);
    if (_isStart == NO) {
        VGAEncodeParam *encodeParam = [[VGAEncodeParam alloc] init];
        encodeParam.codecMode =  _videoInfo.codecMode;
        encodeParam.srcWidth = (int)_videoInfo.width;
        encodeParam.srcHeight = (int)_videoInfo.height;
        encodeParam.bitRate = _videoInfo.bitRate;
        encodeParam.qualityForAlpha = _videoInfo.qualityForAlpha;
        encodeParam.savePath = _dstURL.relativePath;
        int maxFrameCount = _videoInfo.frameRate * (_videoInfo.durationMs / 1000);
        encodeParam.maxFrameCount = maxFrameCount;
        encodeParam.videoRate = _videoInfo.frameRate;
        [self->_videoEncode startEncode:encodeParam];
        _isStart = YES;
    }

    VGAVideoFrame *frame = [[VGAVideoFrame alloc] init];
    frame.time = _time;
    frame.pixelFormat = AVTPixelFormatBGRA;
    frame.buffer = pixelBuffer;
    [self->_videoEncode addVideoFrame:frame];
}

#pragma mark - CGVideoEncoderDelegate
- (void)encodeOnStart:(VGAVideoEncoder *)videoEncoder {
    
}

- (void)videoEncoder:(VGAVideoEncoder *)videoEncoder onProgress:(float)progress {
    
}

- (void)videoEncoder:(VGAVideoEncoder *)videoEncoder onFinish:(NSString *)filePath {
    
}

- (void)videoEncoder:(VGAVideoEncoder *)videoEncoder onError:(NSInteger)errorCode {
    NSLog(@"encode error %ld", (long)errorCode);
}

@end
