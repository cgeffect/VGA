//
//  VGAVideoCodec.h
//  VGA
//
//  Created by Jason on 2021/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VGAVideoCodecMode)
{
    VGAVideoCodecModeNone = 0,
    VGAVideoCodecModeHevc,
    VGAVideoCodecModeAvc,
    VGAVideoCodecModeHevcWithAlpha
};

@interface VGAVideoCodec : NSObject

+ (VGAVideoCodecMode)getVideoCodec:(NSURL *)URL;

+ (void)loadValuesAsynchronously:(NSURL *)URL completionHandler:(nullable void (^)(VGAVideoCodecMode))handler;

@end

NS_ASSUME_NONNULL_END
