//
//  VGAVideoCodec.m
//  VGA
//
//  Created by Jason on 2021/12/20.
//

#import "VGAVideoCodec.h"
#import <AVFoundation/AVFoundation.h>

@implementation VGAVideoCodec

+ (void)loadValuesAsynchronously:(NSURL *)URL completionHandler:(void (^)(VGAVideoCodecMode))handler {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        VGAVideoCodecMode mode = [VGAVideoCodec getVideoCodec:URL];
        handler(mode);
    }];
    [thread start];
}

+ (VGAVideoCodecMode)getVideoCodec:(NSURL *)URL {
    VGAVideoCodecMode codecMode;
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:URL options:nil];
    NSArray <AVAssetTrack *> *videoTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    if (videoTracks.count <= 0) {
        NSLog(@"VGAVideoCodec error: 输入视频资源不存在视频轨道");
        codecMode = VGAVideoCodecModeNone;
        return codecMode;
    }
    
    AVAssetTrack *videoTrack = videoTracks.firstObject;
    NSArray *formatDescriptions = [videoTrack formatDescriptions];
    if (formatDescriptions.count <= 0) {
        NSLog(@"VGAVideoCodec error: 输入视频资源不存在formatDescriptions");
        codecMode = VGAVideoCodecModeNone;
        return codecMode;
    }
    
    CMFormatDescriptionRef desc = (__bridge CMFormatDescriptionRef)(formatDescriptions.firstObject);
    CMVideoCodecType codecType = CMVideoFormatDescriptionGetCodecType(desc);
    if (codecType == kCMVideoCodecType_HEVC) {
        codecMode = VGAVideoCodecModeHevc;
    } else {
        codecMode = VGAVideoCodecModeAvc;
    }
    
//    CMMediaType type = CMFormatDescriptionGetMediaType(desc);
    CFDictionaryRef dicRef = CMFormatDescriptionGetExtensions(desc);
    NSDictionary *dic = (__bridge NSDictionary *)dicRef;
    if ([dic.allKeys containsObject:@"AlphaChannelMode"]) {
        codecMode = VGAVideoCodecModeHevcWithAlpha;
    }

    return codecMode;
}


@end

/*
 Printing description of dic:
 {
     CVFieldCount = 1;
     CVImageBufferChromaLocationBottomField = Left;
     CVImageBufferChromaLocationTopField = Left;
     Depth = 24;
     FormatName = "'avc1'";
     FullRangeVideo = 0;
     RevisionLevel = 0;
     SampleDescriptionExtensionAtoms =     {
         avcC = {length = 44, bytes = 0x01640032 ffe1001b 67640032 ac720440 ... 000668e8 438f2c8b };
     };
     SpatialQuality = 0;
     TemporalQuality = 0;
     VerbatimISOSampleEntry = {length = 138, bytes = 0x0000008a 61766331 00000000 00000001 ... 000668e8 438f2c8b };
     Version = 0;
 }
 */

/*
 Printing description of dic:
 {
     AlphaChannelMode = StraightAlpha;
     BitsPerComponent = 8;
     CVFieldCount = 1;
     CVImageBufferChromaLocationBottomField = Left;
     CVImageBufferChromaLocationTopField = Left;
     CVImageBufferColorPrimaries = "ITU_R_709_2";
     CVImageBufferTransferFunction = "ITU_R_709_2";
     CVImageBufferYCbCrMatrix = "ITU_R_601_4";
     ContainsAlphaChannel = 1;
     Depth = 24;
     FormatName = HEVC;
     FullRangeVideo = 0;
     RevisionLevel = 0;
     SampleDescriptionExtensionAtoms =     {
         almo = {length = 4, bytes = 0x00000100};
         hvcC = {length = 180, bytes = 0x01016000 0000b000 00000000 96f000fc ... 01a50400 007f9080 };
     };
     SpatialQuality = 512;
     TemporalQuality = 512;
     VerbatimSampleDescription = {length = 308, bytes = 0x00000134 68766331 00000000 00000001 ... 00000100 00000000 };
     Version = 0;
 }
 */
