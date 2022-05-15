//
//  VGAMacros.h
//  VGAPlayer
//
//  Created by Jason on 2022/1/13.
//

#ifndef VGAMacros_h
#define VGAMacros_h

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

#define kQGVAPModuleCommon @"kQGVAPModuleCommon"

#define VGA_Info(module, format) NSLog(@"%@, %@", module, format);

#import <UIKit/UIKit.h>

extern NSInteger const kQGHWDMP4DefaultFPS;      //默认fps 25
extern NSInteger const kQGHWDMP4MinFPS;          //最小fps 1
extern NSInteger const QGHWDMP4MaxFPS;          //最大fps 60

extern NSInteger const VapMaxCompatibleVersion; //最大兼容版本

@class QGVAPSourceDisplayItem;

typedef UIView VAPView; //特效播放容器

/* mp4素材中每一帧alpha通道数据的位置*/
typedef NS_ENUM(NSInteger, QVGATextureBlendMode){
    
    VGATextureBlendMode_AlphaLeft                 = 0,          // 左侧alpha
    QVGATextureBlendMode_AlphaRight                = 1,          // 右侧alpha
    QVGATextureBlendMode_AlphaTop                  = 2,          // 上侧alpha
    QVGATextureBlendMode_AlphaBottom               = 3,          // 下测alpha
};

typedef void(^VAPImageCompletionBlock)(UIImage * image, NSError * error,NSString *imageURL);

typedef void(^VAPGestureEventBlock)(UIGestureRecognizer *gestureRecognizer, BOOL insideSource, QGVAPSourceDisplayItem *source);

#endif /* VGAMacros_h */
