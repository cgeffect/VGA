//
//  VGAVideoRecode.h
//  VGAMac
//
//  Created by Jason on 2022/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VGAVideoRecode : NSObject

+ (void)recodeInput:(NSString *)input outputPath:(NSString *)output;

/**
 * 输入为视频或者音频封装格式
 */
+ (void)extractAAC:(NSString *)input outputPath:(NSString *)output;

/**
 * 输入为aac
 */
+ (void)extractPCM:(NSString *)input outputPath:(NSString *)output;

/**
 * 输入为视频或者音频封装格式
 */
+ (void)extractMp3:(NSString *)input outputPath:(NSString *)output;

+ (BOOL)muxVideo:(NSString *)vPath toAudio:(NSString *)aPath output:(NSString *)output;

+ (BOOL)muxAudio:(NSString *)aPath toVideo:(NSString *)vPath output:(NSString *)output;

@end

NS_ASSUME_NONNULL_END
