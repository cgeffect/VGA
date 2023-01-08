//
//  VGAView.h
//  VGAPlayer
//
//  Created by Jason on 2022/1/5.
//

#import <UIKit/UIKit.h>
#import <VGAPlayer/IVGAPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface VGAViewConfig : NSObject
@property(nonatomic, assign)VGAAlphaMode alphaMode;
@property(nonatomic, assign)VGABackgroundMode backgroundMode;
//初始化时canvasSize的值要设置
@property(nonatomic, assign)CGSize canvanSize;
@end

@interface VGAView : UIView

- (instancetype)initWithConfig:(VGAViewConfig *)config;

@property(nonatomic, strong, readonly) id<IVGAPlayer> player;

@end

NS_ASSUME_NONNULL_END
