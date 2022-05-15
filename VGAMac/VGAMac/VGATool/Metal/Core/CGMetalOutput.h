//
//  CGMetalOutput.h
//  CGMetal
//
//  Created by Jason on 21/3/3.
//

#import "CGMetalDevice.h"
#import "CGMetalInput.h"
@import Metal;

//顶点坐标
static const float _vertices[] = {
    -1,  1, 0, 1, // 左上角
     1,  1, 0, 1, // 右上角
    -1, -1, 0, 1, // 左下角
     1, -1, 0, 1, // 右下角
};

//Metal 纹理坐标使用UIKit坐标系
static const float _texCoord[] = {
    0, 0, // 左上角
    1, 0, // 右上角
    0, 1, // 左下角
    1, 1, // 右下角
};

static const float _texCoordFlipX[] = {
    0, 1, // 左下角
    1, 1, // 右下角
    0, 0, // 左上角
    1, 0, // 右上角
};

static const UInt32 _indices[] = {
    0, 1, 2,
    1, 3, 2
};

@interface CGMetalOutput : NSObject
{
@protected
    CGMetalTexture *_outputTexture;
@protected
    NSMutableArray <id<CGMetalInput>>*_targets;
@protected
    BOOL _isWaitUntilCompleted;
@protected
    BOOL _isWaitUntilScheduled;
}

@property(nonatomic, strong, readonly)CGMetalTexture *outTexture;

- (void)addTarget:(id<CGMetalInput>)newTarget;

- (void)removeTarget:(id<CGMetalInput>)targetToRemove;

- (void)removeAllTargets;

- (NSArray*)targets;

- (void)requestRender;

- (void)waitUntilCompleted;

- (void)waitUntilScheduled;

@end
