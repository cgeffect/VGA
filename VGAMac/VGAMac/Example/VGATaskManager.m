//
//  VGATaskManager.m
//  VGAMac
//
//  Created by Jason on 2021/11/30.
//

#import "VGATaskManager.h"

@interface VGATaskManager ()
@property (nonatomic, strong)NSMutableArray <NSURL *>*outURLArray;
@end

@implementation VGATaskManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        _outURLArray = [NSMutableArray array];
        _srcFileSizes = [NSMutableArray array];
    }
    return self;
}

- (void)setSrcURLs:(NSArray<NSURL *> *)srcURLs {
    _srcURLs = srcURLs;
    for (NSURL * url in srcURLs) {
        float size = [VGATaskManager getFileSize:url.relativePath];
        [_srcFileSizes addObject:@(size)];
    }
}

- (void)setOutDicURL:(NSURL *)outDicURL {
    _outDicURL = outDicURL;
    for (NSURL *url in _srcURLs) {
        NSString *name = [url.lastPathComponent componentsSeparatedByString:@"."].firstObject;
        NSString* outFilePath = [outDicURL.relativePath stringByAppendingPathComponent:[NSString stringWithFormat:@"out_%@.mp4", name]];
        NSURL *filePath = [NSURL fileURLWithPath:outFilePath];
        [_outURLArray addObject:filePath];
    }
    _outURLs = _outURLArray;
}

- (void)setOutURLs:(NSArray<NSURL *> *)outURLs {
    _outURLs = outURLs;
}

- (void)clearOutURL {
    [_outURLArray removeAllObjects];
    [_srcFileSizes removeAllObjects];
    _outURLs = nil;
    _srcURLs  = nil;
}

+ (float)getFileSize:(NSString *)path {
    NSError *error = nil;
    float size = [NSFileManager.defaultManager attributesOfItemAtPath:path error:&error].fileSize;
    return size / 1024 / 1024;
}
- (NSString *)creatFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *tmpPath = [path stringByAppendingPathComponent:@"temp"];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString* outFilePath = [tmpPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_%@", (int)time, fileName]];
    return outFilePath;
}

@end


@implementation VGAFileParam

@end
