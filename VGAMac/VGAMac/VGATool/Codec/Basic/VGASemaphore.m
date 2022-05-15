//
// Created by Jason on 2021/6/23.
//

#import "VGASemaphore.h"

@implementation VGASemaphore {
    dispatch_semaphore_t _semaphore;
}

- (instancetype)initWithValue:(int)value {
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(value);
    }
    return self;
}

- (void)lock {
    if (Nil != _semaphore) {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    }
}

- (void)signal {
    if (Nil != _semaphore) {
        dispatch_semaphore_signal(_semaphore);
    }
}

- (void)dealloc {
//    [self signal];
}

@end
