//
//  AVTVideoEncoderAV.h
//  AVTCodecSDK
//
//  Created by Jason on 2021/6/1.
//

#import <Foundation/Foundation.h>
#import "VGACodecConstant.h"
#import "VGAFrame.h"

NS_ASSUME_NONNULL_BEGIN

@import CoreGraphics;
typedef NS_ENUM(NSUInteger, AVTVideoCodecMode) {
    AVTVideoCodecModeHevcWithAlpha,
    AVTVideoCodecModeAVC,
};

/// 编码参数
@interface VGAEncodeParam : NSObject
@property(nonatomic, strong) NSString *savePath;
@property(nonatomic, assign) int srcWidth;
@property(nonatomic, assign) int srcHeight;
@property(nonatomic, assign) int videoRate; //帧率
@property(nonatomic, assign) int maxFrameCount;
@property(nonatomic, assign) unsigned int bitRate;  // kilobits/sec.
@property(nonatomic, assign) float qualityForAlpha; //0-1
@property(nonatomic, assign) AVTVideoCodecMode codecMode;
- (VGAEncodeParam *)cloneObj;

@end

@class VGAVideoEncoder;

@protocol CGVideoEncoderDelegate <NSObject>
@optional
- (void)encodeOnStart:(VGAVideoEncoder *)videoEncoder;

- (void)videoEncoder:(VGAVideoEncoder *)videoEncoder onProgress:(float)progress;

- (void)videoEncoder:(VGAVideoEncoder *)videoEncoder onFinish:(NSString *)filePath;

- (void)videoEncoder:(VGAVideoEncoder *)videoEncoder onError:(NSInteger)errorCode;

@end

@interface VGAVideoEncoder : NSObject
{
}
@property(nonatomic, weak) id <CGVideoEncoderDelegate> delegate;

- (void)startEncode:(VGAEncodeParam *)param;

- (void)stopEncode;

- (void)addVideoFrame:(VGAVideoFrame *)videoFrame;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
