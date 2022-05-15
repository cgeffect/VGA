//
// Created by Jason on 2021/3/9.
//

#import "VGAFrame.h"


@implementation VGAFrame
- (void)destroy {
    
}
@end

@implementation VGAVideoFrame
- (instancetype)initWithWidth:(int)width height:(int)height size:(int)size {
    self = [self initWithWidth:width height:height size:size pixelFormat:AVTPixelFormatNV21];
    return self;
}

- (instancetype)initWithWidth:(int)width height:(int)height size:(int)size
                  pixelFormat:(AVTPixelFormat)pixelFormat {
    self = [super init];
    _data = nil;
    if (self) {
        self.width = width;
        self.height = height;
        self.size = size;
        _data = malloc((size_t) size);
        memset(_data, 0, size);
        _pixelFormat = pixelFormat;
    }
    return self;
}

+ (instancetype)frameWithWidth:(int)width height:(int)height size:(int)size {
    return [[self alloc] initWithWidth:width height:height size:size];
}

+ (instancetype)frameWithWidth:(int)width height:(int)height size:(int)size
                   pixelFormat:(AVTPixelFormat)pixelFormat {
    return [[self alloc] initWithWidth:width height:height size:size pixelFormat:pixelFormat];
}

- (void)setPixelFormat:(AVTPixelFormat)pixelFormat {
    _pixelFormat = pixelFormat;
}

- (void)destroy {
    if (nil != _data) {
        free(_data);
        _data = nil;
    }
}

@end

