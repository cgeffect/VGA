//
//  VGAPreviewController.h
//  VGAMac
//
//  Created by Jason on 2021/12/3.
//

#import <Cocoa/Cocoa.h>
#import "VGAConvertEncoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface VGAPreviewController : NSViewController
@property(nonatomic, strong)NSString *srcPath;
@property(nonatomic, strong)NSString *dstPath;
@property(nonatomic, assign)VGAInputAlphaMode inputMode;
@property(nonatomic, assign)VGAOutputAlphaMode outputMode;
@end

NS_ASSUME_NONNULL_END
