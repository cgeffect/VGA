//
// Created by Jason on 2021/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VGASemaphore : NSObject

- (instancetype)initWithValue:(int)value;

- (void)lock;

- (void)signal;

@end

NS_ASSUME_NONNULL_END
