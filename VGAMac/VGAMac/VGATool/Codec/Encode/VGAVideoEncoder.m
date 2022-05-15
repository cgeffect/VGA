//
//  AVTVideoEncoderAV.m
//  AVTCodecSDK
//
//  Created by Jason on 2021/6/1.
//

#import "VGAVideoEncoder.h"
#import "VGASemaphore.h"
#import "VGACodecConstant.h"

@import VideoToolbox;
@import AVFoundation;

#define LIMIT_RETRY_COUNT 50

@interface VGAVideoEncoder () {
    AVAssetWriter *_assetWriter;
    AVAssetWriterInput *_assetWriterInput;
    AVAssetWriterInputPixelBufferAdaptor *_assetWriterPixelBufferAdaptor;

    BOOL _haveStartedSession; // 是否开始写数据
    int _succCount, _failCount, _repeatCount;
    NSTimeInterval _encodeCostTimeS;
    BOOL _isFinishedEncode, _isEncodeFail;
    VGASemaphore *_semLock;
    CGSize _videSize;
    VGAEncodeParam *_mEncodeParam;
    int _mEncodedFrameCount;
    AVTControlStatus _status;
}
@end

@implementation VGAVideoEncoder

- (instancetype)init {
    self = [super init];
    if (self) {
        _mEncodedFrameCount = 0;
    }
    return self;
}

#pragma mark - IVideoEncoder

- (void)startEncode:(VGAEncodeParam *)param {
    NSLog(@"======= encode start =========");
    _mEncodeParam = param;
    if (_status == AVTControlStatusEncoding) {
        return;
    }
    _videSize = CGSizeMake(param.srcWidth, param.srcHeight);
    BOOL isOK = [self prepareToRecord:[NSURL fileURLWithPath:param.savePath]];
    if (isOK == NO) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoEncoder:onError:)]) {
            [self.delegate videoEncoder:self onError:-100];
        }
        _isEncodeFail = YES;
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(encodeOnStart:)]) {
        [self.delegate encodeOnStart:self];
    }
    _status = AVTControlStatusEncoding;
    _encodeCostTimeS = [[NSDate date] timeIntervalSince1970];
}

- (void)stopEncode {
    _isFinishedEncode = YES;
    NSLog(@"total encode count: %d, once encode count: %d, repeat encode count: %d, fail encode count: %d", _mEncodedFrameCount, _succCount, _repeatCount, _failCount);
    NSLog(@"encode video costTime = %f s", ([[NSDate date] timeIntervalSince1970] - _encodeCostTimeS));
    //生成视频
    if (_assetWriter.status != AVAssetWriterStatusWriting) {
        NSLog(@"encode exception do not call finishWritingWithCompletionHandler when status is %ld", (long)_assetWriter.status);
        return;
    }
    _semLock = [[VGASemaphore alloc] initWithValue:0];
    //标记写文件结束
    [self->_assetWriterInput markAsFinished];
    [self->_assetWriter finishWritingWithCompletionHandler:^{
        [self->_semLock signal];
    }];
    [_semLock lock];
    NSLog(@"======= encode finished =========");
    if (!_isEncodeFail && self.delegate && [self.delegate respondsToSelector:@selector(videoEncoder:onFinish:)]) {
        [self.delegate videoEncoder:self onFinish:_mEncodeParam.savePath];
    }
}

#pragma mark life

- (void)destroy {
    NSLog(@"encode destroy");
    if (_assetWriter) {
        [self recordOnStop];
        _assetWriter = nil;
    }
    _assetWriterInput = nil;
    if (_semLock) {
        [_semLock signal];
        _semLock = nil;
    }
    _status = AVTControlStatusStopped;
}

- (void)addVideoFrame:(VGAVideoFrame *)videoFrame {
    if (videoFrame == nil) {
        NSLog(@"Encode Param is Nil");
        return;
    }
    if (_isEncodeFail) {
        NSLog(@"Encode Failure");
        return;
    }
    if (_isFinishedEncode) {
        return;
    }
    
    [self addVideoPixelBuffer:videoFrame.buffer time:videoFrame.time];
}

#pragma mark encode
- (void)addVideoPixelBuffer:(CVPixelBufferRef)pixelBuffer time:(CMTime)time {
    CMTime presentationTime = kCMTimeZero;
    if (CMTIME_IS_VALID(kCMTimeInvalid)) {
        int fps = _mEncodeParam.videoRate;
        int oneFrameDuration = 1000 / fps;
        int pts = _mEncodedFrameCount * oneFrameDuration;
        presentationTime = CMTimeMake(pts * 6, 6000);
    } else {
        presentationTime = time;
    }
    _mEncodedFrameCount++;

    NSTimeInterval startMs = [[NSDate date] timeIntervalSince1970];
    [self appendVideoPixelBuffer:pixelBuffer withPresentationTime:presentationTime];
    NSTimeInterval endMs = [[NSDate date] timeIntervalSince1970];
    NSLog(@"encode addVideoPixelbuffer, frame index:%d,total:%d time: %f, costTime: %f",_mEncodedFrameCount, _mEncodeParam.maxFrameCount, CMTimeGetSeconds(presentationTime) * 1000, (endMs - startMs) * 1000);
    float progress = self->_mEncodedFrameCount * 1.0f /self-> _mEncodeParam.maxFrameCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoEncoder:onProgress:)]) {
            [self.delegate videoEncoder:self onProgress:MIN(1, progress)];
        }
    });
}

- (BOOL)prepareToRecord:(NSURL *)saveURL {
    @autoreleasepool {
        _isEncodeFail = false;
        NSError *error = nil;
        //saveURL不需要自己创建文件,AVAssetWriter会自动创建
        AVFileType outputFileType = AVFileTypeQuickTimeMovie;
        if (_mEncodeParam.codecMode == AVTVideoCodecModeHevcWithAlpha) {
            outputFileType = AVFileTypeQuickTimeMovie;
        } else {
            outputFileType = AVFileTypeMPEG4;
        }
        self->_assetWriter = [[AVAssetWriter alloc] initWithURL:saveURL fileType:outputFileType error:&error];
        self->_assetWriter.shouldOptimizeForNetworkUse = false;
        self->_assetWriter.movieFragmentInterval = kCMTimeZero;
        int bitPerSec = _mEncodeParam.bitRate;
        NSDictionary *outputSettings = nil;
        NSDictionary *compressionProperties = nil;
        CFArrayRef dataRateLimits = getDataRateLimit(bitPerSec);
        if (_mEncodeParam.codecMode == AVTVideoCodecModeHevcWithAlpha) {
            if (@available(iOS 13.0, *)) {
                compressionProperties = @{
                    (id)kVTCompressionPropertyKey_Quality:@(0.5),//only JPEG, HEIC and Apple ProRAW
                    (id)kVTCompressionPropertyKey_AverageBitRate: @(bitPerSec),//only h264, VT仅支持ABR
                    /*
                     * 非M1芯片
                     * kVTCompressionPropertyKey_MaxKeyFrameInterval和kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration在hevc的编码器下不能同时设置
                     * kVTCompressionPropertyKey_AllowOpenGOP不支持
                     */
                    //Set a relatively large value for keyframe emission (7200 frames or 4 minutes).
                    (id)kVTCompressionPropertyKey_MaxKeyFrameInterval: @(7200), //only h264
        //            (id)kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration:@(240),//only h264
        //            (id)kVTCompressionPropertyKey_AllowOpenGOP:@(YES),
                    (id)kVTCompressionPropertyKey_RealTime:@(NO),
                    (id)kVTCompressionPropertyKey_AllowFrameReordering:@(YES),//allow b frame
                    //这个参数会影响带有背景颜色的视频, 如果使用预乘模式, 则视频会出现花屏现象
                    (id)kVTCompressionPropertyKey_AlphaChannelMode:(id)kVTAlphaChannelMode_StraightAlpha,
                    //压缩值越低, 宏块越大, 马赛克越严重
                    (id)kVTCompressionPropertyKey_TargetQualityForAlpha:@(_mEncodeParam.qualityForAlpha),
                    (id)kVTCompressionPropertyKey_ProfileLevel:(id)kVTProfileLevel_HEVC_Main_AutoLevel,
        //                (id)kVTCompressionPropertyKey_AllowTemporalCompression:@(YES), //无效果
        //                (id)kVTCompressionPropertyKey_DataRateLimits:(__bridge NSArray *)dataRateLimits
        //                (id)kVTCompressionPropertyKey_ExpectedFrameRate:@(1)
                };

                outputSettings = @{
                   AVVideoCodecKey: AVVideoCodecTypeHEVCWithAlpha,
                   AVVideoWidthKey: @(self->_videSize.width),
                   AVVideoHeightKey: @(self->_videSize.height),
                   AVVideoCompressionPropertiesKey: compressionProperties
               };
                
                if (dataRateLimits) {
                    CFRelease(dataRateLimits);
                }
            } else {
                NSAssert(NO, @"hevc with alpha 只能在iOS13及其以上的系统可用");
            }
        } else {
            compressionProperties = @{
                AVVideoAverageBitRateKey: @(bitPerSec),//only h264
                AVVideoMaxKeyFrameIntervalKey: @(7200), //only h264
                AVVideoMaxKeyFrameIntervalDurationKey:@(240),//only h264
                AVVideoAllowFrameReorderingKey: @(YES),
                AVVideoProfileLevelKey:AVVideoProfileLevelH264BaselineAutoLevel
//                AVVideoAppleProRAWBitDepthKey:@(8), //8-16
            };
            outputSettings = @{
               AVVideoCodecKey: AVVideoCodecTypeH264,
               AVVideoWidthKey: @(self->_videSize.width),
               AVVideoHeightKey: @(self->_videSize.height),
               AVVideoCompressionPropertiesKey: compressionProperties
           };
        }
        
        NSLog(@"outputSettings: %@", outputSettings);
        if ([self->_assetWriter canApplyOutputSettings:outputSettings forMediaType:AVMediaTypeVideo]) {
            self->_assetWriterInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
            if ([self->_assetWriter canAddInput:self->_assetWriterInput]) {
                [self->_assetWriter addInput:self->_assetWriterInput];
            }
        } else {
            return NO;
        }
        NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary
                dictionaryWithObjectsAndKeys:@(kCVPixelFormatType_32BGRA), kCVPixelBufferPixelFormatTypeKey,
                                             @((int) self->_videSize.width), kCVPixelBufferWidthKey,
                                             @((int) self->_videSize.height), kCVPixelBufferHeightKey,
                        nil];
        _assetWriterPixelBufferAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_assetWriterInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
        NSLog(@"Codec: %@, ABR: %d, fileType: %@, width: %d, height: %d, fps: %d", AVVideoCodecTypeHEVC, bitPerSec, AVFileTypeQuickTimeMovie, (int) self->_videSize.width, (int) self->_videSize.height, self->_mEncodeParam.videoRate);
        if (self->_assetWriterInput == NULL) {
            NSString *exceptionReason = [NSString stringWithFormat:@"sample buffer create failed "];
            NSLog(@"writerInput %@", exceptionReason);
        }
        BOOL success = [self->_assetWriter startWriting];
        if (!success) {
            error = self->_assetWriter.error;
            NSLog(@"startWriting %@", error);
            return NO;
        }
        return success;
    }
}

- (void)appendVideoPixelBuffer:(CVPixelBufferRef)pixelBuffer withPresentationTime:(CMTime)presentationTime {
    @autoreleasepool {
        if (pixelBuffer) {
            @autoreleasepool {
                if (!self->_haveStartedSession && _assetWriter.status == AVAssetWriterStatusWriting) {
                    [self->_assetWriter startSessionAtSourceTime:presentationTime];
                    self->_haveStartedSession = YES;
                }
                AVAssetWriterInput *writerInput = self->_assetWriterInput;
                BOOL isComplete = false;
                int loopCount = 0;
                NSTimeInterval costTime = [[NSDate date] timeIntervalSince1970] * 1000;
                while (!isComplete && loopCount < LIMIT_RETRY_COUNT) {
                    if (writerInput.readyForMoreMediaData) {
                        BOOL success = false;
                        //通过try-catch捕获startSessionAtSourceTime未开启的异常
                        @try {
                            success = [_assetWriterPixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:presentationTime];
                        } @catch (NSException *exception) {
                            [self recordOnStop];
                            _isEncodeFail = true;
                            if (self.delegate && [self.delegate respondsToSelector:@selector(videoEncoder:onError:)]) {
                                [self.delegate videoEncoder:self onError:-100];
                            }
                            break;
                        } @finally {

                        }
                        if (success) {
                            isComplete = true;
                        } else {
                            NSError *error = self->_assetWriter.error;
                            NSLog(@"encode fail: %@", error);
                            isComplete = false;
                        }
                        //无论成功或失败都要退出循环
                        break;
                    } else {
                        NSLog(@"input not ready for more media data, dropping buffer");
                        isComplete = false;
                        loopCount++;
                        usleep(5 * 1000);
                    }
                }
                if (isComplete) {
                    if (loopCount) {
                        self->_repeatCount++;
                        costTime = [[NSDate date] timeIntervalSince1970] * 1000 - costTime;
                        NSLog(@"encode once success cost time: %f ms, loop encode count %ld", (float) costTime, (long) loopCount);
                    } else {
                        self->_succCount++;
                    }
                } else {
                    self->_failCount++;
                    NSLog(@"encode once fail cost time: %f ms, loop encode count %ld", (float) costTime, (long) loopCount);
                }
            }
        }
    }
}

- (void)recordOnStop {
    NSLog(@"encode recordOnStop");
    //执行下一次startWriting, 必须要先cancel
    if (_assetWriter.status != AVAssetWriterStatusFailed || _assetWriter.status != AVAssetWriterStatusCompleted) {
        [_assetWriter cancelWriting];
    }
    _status = AVTControlStatusStopped;
}

- (void)dealloc {
    NSLog(@"encode dealloc");
}

// The function returns the max allowed sample rate (pixels per second) that
// can be processed by given encoder with `profile_level_id`.
// See https://www.itu.int/rec/dologin_pub.asp?lang=e&id=T-REC-H.264-201610-S!!PDF-E&type=items
// for details.
NSUInteger GetMaxSampleRate(CFStringRef profile_level_id) {
    if (profile_level_id == kVTProfileLevel_H264_Baseline_3_0) {
        return 10368000;
    } else if (profile_level_id == kVTProfileLevel_H264_Baseline_3_1) {
        return 27648000;
    } else if (profile_level_id == kVTProfileLevel_H264_Baseline_3_2) {
        return 55296000;
    } else if (profile_level_id == kVTProfileLevel_H264_Baseline_4_0
               || profile_level_id == kVTProfileLevel_H264_Baseline_4_1) {
        return 62914560;
    } else if (profile_level_id == kVTProfileLevel_H264_Baseline_4_2) {
        return 133693440;
    } else if (profile_level_id == kVTProfileLevel_H264_Baseline_5_0) {
        return 150994944;
    } else if (profile_level_id == kVTProfileLevel_H264_Baseline_5_1) {
        return 251658240;
    } else if (profile_level_id == kVTProfileLevel_H264_Baseline_5_2) {
        return 530841600;
    } else if (profile_level_id == kVTProfileLevel_H264_Baseline_AutoLevel) {
        // Zero means auto rate setting.
        return 0;
    }
    return 0;
}

CFArrayRef getDataRateLimit(int bitrateBps) {
    float kLimitToAverageBitRateFactor = 1.5;
    int64_t dataLimitBytesPerSecondValue = (bitrateBps * kLimitToAverageBitRateFactor / 8);
    CFNumberRef bytesPerSecond = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt64Type, &dataLimitBytesPerSecondValue);
    int64_t oneSecondValue = 1;
    CFNumberRef oneSecond = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt64Type, &oneSecondValue);
    const void *nums[2] = {bytesPerSecond, oneSecond};
    CFArrayRef dataRateLimits = CFArrayCreate(NULL, nums, 2, &kCFTypeArrayCallBacks);
    if (bytesPerSecond) {
        CFRelease(bytesPerSecond);
    }
    if (oneSecond) {
        CFRelease(oneSecond);
    }
    return dataRateLimits;
}

@end

@implementation VGAEncodeParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        _qualityForAlpha = 0.5;
    }
    return self;
}
- (VGAEncodeParam *)cloneObj {
    VGAEncodeParam *param = [[VGAEncodeParam alloc] init];
    param.savePath = self.savePath;
    param.srcWidth = self.srcWidth;
    param.srcHeight = self.srcHeight;
    param.videoRate = self.videoRate;
    param.maxFrameCount = self.maxFrameCount;
    return param;
}

@end
