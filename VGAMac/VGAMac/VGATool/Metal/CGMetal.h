//
//  CGMetal.h
//  CGMetal
//
//  Created by Jason on 2021/5/25.
//

#import <Foundation/Foundation.h>

//! Project version number for CGMetal.
FOUNDATION_EXPORT double CGMetalVersionNumber;

//! Project version string for CGMetal.
FOUNDATION_EXPORT const unsigned char CGMetalVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CGMetal/PublicHeader.h>

#pragma mark -
#pragma mark Basic
#import "CGMetalBasic.h"
#import "CGMetalFlipX.h"
#import "CGMetalBlendAlpha.h"
#import "CGMetalScaleAlpha.h"
#import "CGMetalCrop.h"
#import "CGMetalBlendScaleAlpha.h"
#import "CGMetalScaleARGBAlpha.h"
#import "CGMetalSwitchAlpha.h"

#pragma mark -
#pragma mark Input
#import "CGMetalPixelBufferInput.h"
#import "CGMetalVideoInput.h"
#import "CGMetalPlayerInputMac.h"

#pragma mark -
#pragma mark Output
#import "CGMetalPixelBufferSurfaceOutput.h"
#import "CGMetalLayerOutput.h"
#import "CGMetalNSViewOutput.h"
