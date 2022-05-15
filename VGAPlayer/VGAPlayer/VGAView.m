//
//  VGAView.m
//  VGAPlayer
//
//  Created by Jason on 2022/1/5.
//

#import "VGAView.h"
#import "IVGAVideoPlayer.h"

@implementation VGAViewConfig

@end

@interface VGAView ()<IVGAPlayerDelegate>
@property(nonatomic, strong)IVGAVideoPlayer *playerController;
@end

@implementation VGAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addBackgroundObserver];
    }
    return self;
}

- (instancetype)initWithConfig:(VGAViewConfig *)config {
    self = [self init];
    if (self) {
        VGAPlayItem *item = [[VGAPlayItem alloc] init];
        item.canvasSize = config.canvanSize;
        item.alphaMode = config.alphaMode;
        _playerController = [[IVGAVideoPlayer alloc] initWithItem:item];
        [_playerController setWrapView:self];
        _playerController.playerDelegate = self;
    }
    return self;
}

- (void)onDestroy:(id)player {
    
}

- (id<IVGAPlayer>)player {
    return _playerController;
}

- (void)dealloc {
    [self removeBackgroundObserver];
}

#pragma mark - background observer
/// 下拉通知栏 willResignActiveNotification -> didBecomeActiveNotification -> willResignActiveNotification
- (void)addBackgroundObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)removeBackgroundObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)handleApplicationBecomeActive:(UIApplication *)application {
    [_playerController didBecomeActive];
}

- (void)handleApplicationWillResignActive:(UIApplication *)application {
    [_playerController willResignActive];
}


@end
