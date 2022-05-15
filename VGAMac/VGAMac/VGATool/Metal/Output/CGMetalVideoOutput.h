//
//  CGMetalVideoSurfaceOutput.h
//  CGMetal
//
//  Created by Jason on 2021/12/1.
//

#import "CGMetalInput.h"
#import "VGAVideoInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGMetalVideoOutput : NSObject<CGMetalInput>

@property(nonatomic, strong)VGAVideoInfo *videoInfo;

- (instancetype)initWithVideoURL:(NSURL *)dstURL
              fileType:(NSString *)newFileType
        outputSettings:(NSMutableDictionary * _Nullable)outputSettings;

@end

NS_ASSUME_NONNULL_END
