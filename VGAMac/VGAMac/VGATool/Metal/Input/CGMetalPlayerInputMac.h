//
//  CGMetalPlayerInputMac.h
//  CGMetal
//
//  Created by Jason on 2021/12/7.
//

#import "CGMetalOutput.h"
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#else

#import <AVFoundation/AVFoundation.h>
#import "CGMetalPixelBufferInput.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGMetalPlayerInputMac : CGMetalOutput<CGMetalPlayerInput>

@end

NS_ASSUME_NONNULL_END
#endif
