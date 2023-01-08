//
//  UIView+VGA.m
//  VGAPlayer
//
//  Created by Jason on 2022/1/6.
//

#import "UIView+VGA.h"

@implementation UIView (VGA)

+ (void)addConstraintWithView:(UIView *)displayerView superView:(UIView *)superView {
    NSLayoutConstraint *LayoutConstraintCenterX = [self equalConstraintWithView:displayerView superView:superView attribute:NSLayoutAttributeCenterX];
    NSLayoutConstraint *LayoutConstraintCenterY = [self equalConstraintWithView:displayerView superView:superView attribute:NSLayoutAttributeCenterY];
    NSLayoutConstraint *LayoutConstraintWidth = [self equalConstraintWithView:displayerView superView:superView attribute:NSLayoutAttributeWidth];
    NSLayoutConstraint *LayoutConstraintHeight = [self equalConstraintWithView:displayerView superView:superView attribute:NSLayoutAttributeHeight];
    [superView addConstraint:LayoutConstraintCenterX];
    [superView addConstraint:LayoutConstraintCenterY];
    [superView addConstraint:LayoutConstraintWidth];
    [superView addConstraint:LayoutConstraintHeight];
}

+ (NSLayoutConstraint *)equalConstraintWithView:(UIView *)view superView:(UIView *)superView attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:superView
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

@end
