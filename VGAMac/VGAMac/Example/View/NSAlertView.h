//
//  NSAlertView.h
//  VGAMac
//
//  Created by Jason on 2022/1/9.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAlertView : NSObject

+ (void)alertView:(NSString *)msg confirm:(void(^)(void))okBlock cancel:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
