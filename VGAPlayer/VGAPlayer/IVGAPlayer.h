//
//  IVGAPlayer.h
//  VGAPlayer
//
//  Created by Jason on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VGAViewContentMode)
{
    VGAViewContentModeScaleToFill = 0,
    VGAViewContentModeScaleAspectFit,
    VGAViewContentModeScaleAspectFill
};

typedef NS_ENUM(NSUInteger, VGAAlphaMode) {
    VGAAlphaModeNone = 0,
    VGAAlphaModeRGBA,
    VGAAlphaModeLeftAlpha,
    VGAAlphaModeLeftScaleAlpha,
    VGAAlphaModeRightAlpha,
    VGAAlphaModeRightScaleAlpha,
    VGAAlphaModeHevcWithAlpha,
    VGAAlphaModeMaskScaleAlpha
};

typedef NS_ENUM(NSUInteger, VGABackgroundMode) {
    VGABackgroundModeStop,
    VGABackgroundModePauseAndResume,
    VGABackgroundModeContinue,
    VGABackgroundModeStopAndPlay,
};

@class IVGAPlayer;
@protocol IVGAPlayerDelegate <NSObject>
@optional
- (void)onReady:(nonnull id)player;

- (void)onPlay:(nonnull id)player;

- (void)onStop:(nonnull id)player;

- (void)onDestroy:(nonnull id)player;

- (void)onPlayFinished:(nonnull id)player;

- (void)player:(id)player onError:(NSInteger)errorCode;

@end

@protocol IVGALogger <NSObject>

//+ (void)registerVGALog:(VGALoggerFunc)func;

@end

@protocol IVGAControl <IVGALogger>
@optional
- (void)play;

- (void)resume;

- (void)pause;

- (void)stop;

- (void)destroy;

@end

@interface VGAVideoItem : NSObject
@property(nonatomic, assign)BOOL isLoopPlay;
@property(nonatomic, assign)BOOL isAutoPlay;
@property(nonatomic, assign)VGAViewContentMode contentMode;
@property(nonatomic, assign)VGABackgroundMode backgroundMode;
@end

@protocol IVGAPlayer <IVGAControl>
@optional
@property(nonatomic, weak)id<IVGAPlayerDelegate>delegate;

- (void)replaceVideoItem:(nonnull VGAVideoItem *)item;

- (void)loadResource:(nonnull NSURL *)URL;

- (void)didBecomeActive;

- (void)willResignActive;

@end

NS_ASSUME_NONNULL_END
