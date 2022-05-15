//
// Created by Jason on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VGAFrame.h"
#import "VGAVideoInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface VGAVideoDecoder : NSObject {
@protected
    VGAVideoInfo *_videoInfo;
@protected
    AVTPixelFormat _outputPixFormat;
}
@property(nonatomic, strong, readonly) VGAVideoInfo *videoInfo;

- (instancetype)init;

- (void)loadResource:(NSString *)inPath;

- (void)copyNextPixelBuffer:(void (^)(_Nullable CVPixelBufferRef pixelBuffer, NSInteger index, CMTime frameTime))processHandler
                            finishHandler:(void (^)(BOOL isCancel))finishHandler;

- (void)cancel;

- (void)destroy;

@end
NS_ASSUME_NONNULL_END
