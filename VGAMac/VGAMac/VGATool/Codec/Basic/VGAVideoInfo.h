//
// Created by Jason on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VGAVideoEncoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface VGAVideoInfo : NSObject
@property(nonatomic, assign) NSInteger width;
@property(nonatomic, assign) NSInteger height;
@property(nonatomic, assign) NSInteger rotate;
@property(nonatomic, assign) double durationMs; //容器的时长
@property(nonatomic, assign) double videoTrackMs; //视频轨道的时长
@property(nonatomic, assign) float frameRate; //帧率 (1000 / 帧率 = 帧间隔)
@property(nonatomic, assign) float minFrameDuration; //帧间隔 毫秒
@property(nonatomic, assign) float bitRate;
@property(nonatomic, assign) float qualityForAlpha; //0-1, 默认0.5
@property(nonatomic, assign) AVTVideoCodecMode codecMode;

- (instancetype)init;

- (instancetype)initWithPath:(nonnull NSString *)path;

@end

@interface VGAVideoUtil : NSObject

+ (AVAssetTrack *)extractAssetTrackWithAsset:(AVAsset *)videoAsset mediaType:(AVMediaType)mediaType;

+ (AVAssetTrack *)extractAssetTrackWithPath:(NSString *)filePath mediaType:(AVMediaType)mediaType;

+ (BOOL)hasAudioTrack:(nonnull NSString *)filePath;

+ (int)getVideoRotateFromTransform:(CGAffineTransform)transform;

+ (NSInteger)compatVideoRotate:(NSInteger)srcRotate;

@end

NS_ASSUME_NONNULL_END
