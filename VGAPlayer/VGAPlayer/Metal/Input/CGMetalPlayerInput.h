//
//  CGMetalVideoPlayInput.h
//  CGMetal
//
//  Created by Jason on 2021/6/1.
//

#import "CGMetalOutput.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGMetalPlayerInput : CGMetalOutput<CGMetalPlayInputProtocol>

@property(nonatomic, assign)BOOL isLoopPlay;

@end

NS_ASSUME_NONNULL_END
