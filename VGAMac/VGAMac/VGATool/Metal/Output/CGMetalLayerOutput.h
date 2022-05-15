//
//  CGMetalLayerOutput.h
//  VGAMac
//
//  Created by Jason on 2021/12/3.
//

#import <QuartzCore/QuartzCore.h>
#import "CGMetalInput.h"

NS_ASSUME_NONNULL_BEGIN
@interface CGMetalLayerOutput : CAMetalLayer<CGMetalInput, CGMetalViewOutput>

- (instancetype)initWithScale:(CGFloat)nativeScale;

@property (nonatomic, assign)CGMetalAlphaMode alphaChannelMode;

@end

NS_ASSUME_NONNULL_END
