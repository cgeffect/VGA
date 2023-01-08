//
//  VGAVideoDecoder.h
//  VGAPlayer
//
//  Created by Jason on 2022/1/4.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "VGAMacros.h"

@protocol VGAOpenGLViewDelegate <NSObject>

- (void)onViewUnavailableStatus;

@end

@interface VGAOpenGLView : UIView

@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, weak) id<VGAOpenGLViewDelegate> displayDelegate;
@property (nonatomic, assign) QVGATextureBlendMode blendMode;
@property (nonatomic, assign) BOOL pause;

- (void)setupGL;
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (void)dispose;

//update glcontext's viewport size by layer bounds
- (void)updateBackingSize;

@end
