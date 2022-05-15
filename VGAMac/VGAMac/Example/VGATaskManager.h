//
//  VGATaskManager.h
//  VGAMac
//
//  Created by Jason on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VGATaskManager : NSObject
@property(nonatomic, strong)NSArray <NSURL *>*srcURLs;
@property(nonatomic, strong, readonly)NSMutableArray <NSNumber *>*srcFileSizes;
@property(nonatomic, strong)NSURL *outDicURL;
@property(nonatomic, strong)NSArray <NSURL *>*outURLs;
- (void)clearOutURL;
+ (float)getFileSize:(NSString *)path;
@end

@interface VGAFileParam : NSObject
@property(nonatomic, assign)float progress;
@property(nonatomic, assign)float fileSize;
@property(nonatomic, strong)NSURL *URL;
@end

NS_ASSUME_NONNULL_END
