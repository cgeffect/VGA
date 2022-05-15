//
// Created by Jason on 2021/3/9.
//

#import "VGAVideoInfo.h"

@implementation VGAVideoInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        _qualityForAlpha = 0.5;
    }
    return self;
}
- (instancetype)initWithPath:(nonnull NSString *)path {
    self = [self init];
    if (self) {
        NSURL *url = [NSURL fileURLWithPath:path];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        _durationMs = (NSUInteger) (CMTimeGetSeconds(asset.duration) * 1000);
        _videoTrackMs = CMTimeGetSeconds(asset.duration) * 1000;

        for (AVAssetTrack *track in asset.tracks) {
            if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
                _videoTrackMs = CMTimeGetSeconds(track.timeRange.duration) * 1000;
                _minFrameDuration = CMTimeGetSeconds(track.minFrameDuration) * 1000;
                _frameRate = track.nominalFrameRate;
                _width = (NSInteger) track.naturalSize.width;
                _height = (NSInteger) track.naturalSize.height;
                _rotate = [VGAVideoUtil getVideoRotateFromTransform:track.preferredTransform];
            }
        }
    }
    return self;
}

@end

@implementation VGAVideoUtil
+ (AVAssetTrack *)extractAssetTrackWithAsset:(AVAsset *)videoAsset mediaType:(AVMediaType)mediaType {
    NSArray <AVAssetTrack *> *list = [videoAsset tracksWithMediaType:mediaType];
    if (list.count != 0) {
        return list[0];
    }
    NSLog(@"%@资源的 %@ 轨道不存在", videoAsset, mediaType);
    return nil;
}

+ (AVAssetTrack *)extractAssetTrackWithPath:(NSString *)filePath mediaType:(AVMediaType)mediaType {
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AVAsset *asset = [AVAsset assetWithURL:url];
    return [self extractAssetTrackWithAsset:asset mediaType:mediaType];
}

+ (BOOL)hasAudioTrack:(nonnull NSString *)filePath {
    AVAssetTrack *track = [VGAVideoUtil extractAssetTrackWithPath:filePath mediaType:AVMediaTypeAudio];
    return track != nil;
}

/*
 // 0 水平 不需要转
 // 90 270 交换宽高，转成竖的
 // 180 水平反向，宽高不用交换，但需要转正
 */
+ (int)getVideoRotateFromTransform:(CGAffineTransform)transform {
    int degree = 0;
    if (transform.a == 0 && transform.b == 1 && transform.c == -1 && transform.d == 0) {
        // Portrait
        degree = 90;
    } else if (transform.a == 0 && transform.b == -1 && transform.c == 1 && transform.d == 0) {
        // PortraitUpsideDown
        degree = 270;
    } else if (transform.a == 1 && transform.b == 0 && transform.c == 0 && transform.d == 1) {
        // LandscapeRight 横屏home键在右边
        degree = 0;
    } else if (transform.a == -1 && transform.b == 0 && transform.c == 0 && transform.d == -1) {
        // LandscapeLeft 横屏home键在左边
        degree = 180;
    }
    return degree;
}

+ (NSInteger)compatVideoRotate:(NSInteger)srcRotate {
    switch (srcRotate) {
        case 90:                // 竖着录制的视频
            return 90;
        case 270:               // 竖着录制的视频
            return 270;
        case 0:                 // 横着录制的视频
            return 180;
        case 180:               // 横着录制的视频
            return 0;
    }
    return srcRotate;
}

@end
