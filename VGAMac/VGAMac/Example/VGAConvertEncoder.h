//
//  VGAVideoEncoder.h
//  VGAMac
//
//  Created by Jason on 2021/11/30.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VGAInputAlphaMode) {
    VGAInputAlphaModeRGBA = 0,
    VGAInputAlphaModeLeftAlpha,
    VGAInputAlphaModeRightAlpha,
};

typedef NS_ENUM(NSInteger, VGAOutputAlphaMode) {
    VGAOutputAlphaModeHevcWithAlpha = 0,
    VGAOutputAlphaModeLeftAlpha,
    VGAOutputAlphaModeRightAlpha,
    VGAOutputAlphaModeLeftScaleAlpha,
    VGAOutputAlphaModeRightScaleAlpha
};

@class VGAConvertEncoder;

@protocol VGAEncodeDelegate <NSObject>

@optional

- (void)videoEncode:(VGAConvertEncoder *)thiz progress:(float)progress;

- (void)videoEncode:(VGAConvertEncoder *)thiz notSupport:(BOOL)sup;

@end

@interface VGAConvertEncoder : NSObject

@property(nonatomic, assign)VGAInputAlphaMode inputMode;
@property(nonatomic, assign)VGAOutputAlphaMode outputMode;

@property (nonatomic, weak) _Nullable id <VGAEncodeDelegate> delegate;

- (void)gotoEncode:(NSURL * _Nonnull)srcUrl outUrl:(NSURL * _Nonnull)outUrl;

@property(nonatomic, strong)NSString *srcIden;
@property(nonatomic, strong)NSString *dstIden;

@property(nonatomic, assign) float width;
@property(nonatomic, assign) float height;
@property(nonatomic, assign) int averageBitRate;  // kilobits/sec.
@property(nonatomic, assign) float qualityForAlpha; //0-1
@end
NS_ASSUME_NONNULL_END
