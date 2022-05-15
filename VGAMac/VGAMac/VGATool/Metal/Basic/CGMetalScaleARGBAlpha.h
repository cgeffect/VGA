//
//  CGMetalScaleARGBAlpha.h
//  CGMetalMac
//
//  Created by Jason on 2022/1/6.
//

#import "CGMetalBasic.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGMetalScaleARGBAlpha : CGMetalBasic

- (instancetype)initWithAlphaMode:(CGMetalAlphaMode)blendAlphaMode;

@end

NS_ASSUME_NONNULL_END
