//
// Created by Jason on 2021/3/11.
//

#import "VGAVideoDecoder.h"
#import "VGAVideoInfo.h"

@implementation VGAVideoDecoder {
    NSInteger _totalFrameCount;
    AVAssetReader *_assetReader;
    AVAssetReaderTrackOutput *_trackOutput;
    BOOL _isReading;
    BOOL _flagCancel;
    dispatch_queue_t _serialQueue;
    NSString *_videoPath;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _outputPixFormat = AVTPixelFormatNV12;
        _serialQueue = dispatch_queue_create("com.reader.serial.queue", DISPATCH_QUEUE_SERIAL);
    }

    return self;
}

- (void)loadResource:(NSString *)inPath {
    if (inPath == nil) {
        return;
    }
    _videoPath = inPath;
    _videoInfo = [[VGAVideoInfo alloc] initWithPath:_videoPath];
    _totalFrameCount = (NSInteger) (_videoInfo.durationMs / 1000 * _videoInfo.frameRate);
}

- (void)copyNextPixelBuffer:(void (^)(CVPixelBufferRef _Nullable, NSInteger, CMTime))processHandler finishHandler:(void (^)(BOOL))finishHandler {
    if (_isReading) {
        return;
    }
    [self prepareAssetReader];
    if (nil == _assetReader || nil == _trackOutput) {
        return;
    }
    
    _isReading = YES;

    void (^processBlock)(void) = ^() {
        NSInteger index = 0;
        BOOL isCancel = self->_flagCancel;
        [self->_assetReader startReading];
        while (self->_assetReader.status == AVAssetReaderStatusReading && !isCancel) {
            @autoreleasepool {
                CMSampleBufferRef smBuffer = [self->_trackOutput copyNextSampleBuffer];
                if (nil != smBuffer) {
                    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(smBuffer);
                    CMTime time = CMSampleBufferGetPresentationTimeStamp(smBuffer);
                    NSInteger pts = (NSInteger) (CMTimeGetSeconds(time) * 1000);
                    NSInteger currentIndex = index;
                    if (nil != pixelBuffer && nil != processHandler) {
                        if (processHandler) {
                            processHandler(pixelBuffer, currentIndex, time);
                        }

                        NSLog(@"%@ decode success currentIndex %ld, pts %ld", self, (long)currentIndex, pts);
                        CVBufferRelease(pixelBuffer);
                    }
                }
                index++;
                isCancel = self->_flagCancel;
            }
        }
        if (self->_assetReader.status == AVAssetReaderStatusCompleted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (nil != finishHandler) {
                    finishHandler(NO);
                }
            });
        }
        if (self->_flagCancel) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (nil != finishHandler) {
                    finishHandler(YES);
                }
            });
        }
        [self destroyAssetReader];
        self->_isReading = NO;
    };

    dispatch_async(_serialQueue, ^{
        processBlock();
    });
}

- (void)prepareAssetReader {
    NSURL *url = [NSURL fileURLWithPath:_videoPath];
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetTrack *videoTrack = [videoAsset tracksWithMediaType:AVMediaTypeVideo][0];

    _assetReader = [[AVAssetReader alloc] initWithAsset:videoAsset error:nil];

    if (nil == _assetReader) {
        return;
    }

    NSDictionary *option = @{
            (NSString *) kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA),
//            (NSString *) kCVPixelBufferWidthKey: @(floorf(_videoInfo.width / 16) * 16),
//            (NSString *) kCVPixelBufferHeightKey: @(floorf(_videoInfo.height / 16) * 16),
            (NSString *) kCVPixelBufferWidthKey: @(floorf(_videoInfo.width)),
            (NSString *) kCVPixelBufferHeightKey: @(floorf(_videoInfo.height)),
            (id) kCVPixelBufferIOSurfacePropertiesKey: @{},
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
            (id)kCVPixelBufferOpenGLESCompatibilityKey: @(YES),
#else
#endif
            (id)kCVPixelBufferMetalCompatibilityKey:@(YES)
    };

    _trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:option];
    _trackOutput.alwaysCopiesSampleData = NO;
    [_assetReader addOutput:_trackOutput];
}

- (void)destroyAssetReader {
    _assetReader = nil;
    _trackOutput = nil;
}

- (void)cancel {
    _flagCancel = YES;
}

- (void)destroy {
    [self cancel];
    
    dispatch_barrier_sync(_serialQueue, ^{
        NSLog(@"queue operation empty");
    });
    _serialQueue = NULL;
    [self destroyAssetReader];
}

- (void)dealloc {

}

@end
