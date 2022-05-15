//
//  IVGAPlayer.m
//  VGAPlayer
//
//  Created by Jason on 2021/12/7.
//

#import "IVGAPlayer.h"

@implementation VGAVideoItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLoopPlay = YES;
        _isAutoPlay = YES;
        _contentMode = VGAViewContentModeScaleAspectFit;
    }
    return self;
}
@end

