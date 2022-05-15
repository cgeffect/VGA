//
//  CGMetalScaleAlpha.h
//  VGAMac
//
//  Created by Jason on 2022/1/2.
//

#import "CGMetalBasic.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGMetalScaleAlpha : CGMetalBasic

- (instancetype)initWithAlphaMode:(CGMetalAlphaMode)blendAlphaMode;

@end

NS_ASSUME_NONNULL_END
