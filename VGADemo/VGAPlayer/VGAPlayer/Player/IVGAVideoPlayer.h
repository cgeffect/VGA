//
//  IVGAVideoPlayer.h
//  VGAPlayer
//
//  Created by Jason on 2022/1/5.
//

#import "IVGAPlayer.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VGAPlayerStatus) {
    VGAPlayerStatusUnknow = 0,
    VGAPlayerStatusReady,
    VGAPlayerStatusPlaying,
    VGAPlayerStatusPaused,
    VGAPlayerStatusResumed,
    VGAPlayerStatusStopped,
    VGAPlayerStatusDestroyed,
};

@interface VGAPlayItem : NSObject
@property(nonatomic, assign)VGAAlphaMode alphaMode;
@property(nonatomic, assign)CGSize canvasSize;
@end

@interface IVGAVideoPlayer : NSObject <IVGAPlayer>
{
@protected
    VGAPlayerStatus _status;
@protected
    VGAVideoItem *_videoItem;
@protected
    __weak UIView *_wrapView;
@protected
    VGAPlayItem *_playItem;
}

@property(nonatomic, weak)id<IVGAPlayerDelegate>playerDelegate;

- (IVGAVideoPlayer *)initWithItem:(VGAPlayItem *)playItem;

- (void)setWrapView:(UIView *)wrapView ;

@end

NS_ASSUME_NONNULL_END
