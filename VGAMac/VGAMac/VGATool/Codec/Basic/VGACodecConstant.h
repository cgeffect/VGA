//
// Created by Jason on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, AVTPixelFormat) {
    AVTPixelFormatNONE = 0,
    AVTPixelFormatRGBA = 1,
    AVTPixelFormatNV21,
    AVTPixelFormatNV12,
    AVTPixelFormatBGRA
};

typedef NS_ENUM (NSInteger, AVTControlStatus) {
    AVTControlStatusNone = 0,
    AVTControlStatusPlaying = 1,
    AVTControlStatusPaused,
    AVTControlStatusStopped,
    AVTControlStatusEncoding
};

