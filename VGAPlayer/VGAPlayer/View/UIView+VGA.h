//
//  UIView+VGA.h
//  VGAPlayer
//
//  Created by Jason on 2022/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (VGA)

+ (void)addConstraintWithView:(UIView *)displayerView superView:(UIView *)superView;

+ (NSLayoutConstraint *)equalConstraintWithView:(UIView *)view superView:(UIView *)superView attribute:(NSLayoutAttribute)attribute;

@end

NS_ASSUME_NONNULL_END
