//
//  VGAMetalView.m
//  VGAPlayer
//
//  Created by Jason on 2022/1/7.
//

#import "VGAMetalView.h"
#import "UIView+VGA.h"

@interface VGAMetalView ()

@end

@implementation VGAMetalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _canvasView = [[CGMetalUIViewOutput alloc] initWithFrame:frame];
        _canvasView.backgroundColor = UIColor.clearColor;
        _canvasView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_canvasView];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [UIView addConstraintWithView:_canvasView superView:self];
        [CATransaction commit];
    }
    return self;
}
@end
