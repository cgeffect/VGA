//
//  CGMetalSwitchAlpha.h
//  VGAMac
//
//  Created by Jason on 2022/1/12.
//

#import "CGMetalBasic.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGMetalSwitchAlpha : CGMetalBasic

- (instancetype)initWithAlphaMode:(CGMetalAlphaMode)blendAlphaMode;

@end

NS_ASSUME_NONNULL_END
