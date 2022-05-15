//
//  IVGAVideoPlayer.m
//  VGAPlayer
//
//  Created by Jason on 2022/1/5.
//

#import "IVGAVideoPlayer.h"
#import "VGAMetalPlayer.h"

@implementation VGAPlayItem

@end

@implementation IVGAVideoPlayer

@synthesize delegate = _delegate;

- (IVGAVideoPlayer *)initWithItem:(VGAPlayItem *)playItem {
    _playItem = playItem;
//    if (playItem.alphaMode == VGAAlphaModeHevcWithAlpha) {
//        return [[VGASampleBufferPlayer alloc] initWithItem:playItem]; //这个渲染会导致颜色失真
//    } else {
//        return [[VGAMetalPlayer alloc] initWithItem:playItem];;
//    }
    return [[VGAMetalPlayer alloc] initWithItem:playItem];;
}
- (void)setWrapView:(UIView *)wrapView {
    
}

//+ (void)registerVGALog:(VGALoggerFunc)func {
//    
//}


@end
