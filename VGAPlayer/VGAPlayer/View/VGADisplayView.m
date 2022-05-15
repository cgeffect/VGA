//
//  VGADisplayView.m
//  VGAPlayer
//
//  Created by Jason on 2021/12/23.
//

#import "VGADisplayView.h"
#import <AVFoundation/AVFoundation.h>

@implementation VGADisplayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.opaque = YES;
    }
    return self;
}

+ (Class)layerClass {
    return [AVSampleBufferDisplayLayer class];
}

@end
