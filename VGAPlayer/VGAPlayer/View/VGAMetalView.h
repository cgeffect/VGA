//
//  VGAMetalView.h
//  VGAPlayer
//
//  Created by Jason on 2022/1/7.
//

#import <UIKit/UIKit.h>
#import "CGMetal.h"

NS_ASSUME_NONNULL_BEGIN

@interface VGAMetalView : UIView
@property(nonatomic, strong)CGMetalUIViewOutput *canvasView;
@end

NS_ASSUME_NONNULL_END
