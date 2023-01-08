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
#import "CGMetalBlendAlpha.h"
#import "CGMetalBlendScaleAlpha.h"

#pragma mark -
#pragma mark Input
#import "CGMetalPixelBufferInput.h"
#import "CGMetalVideoInput.h"
#import "CGMetalRawDataInput.h"
#import "CGMetalPlayerInput.h"

#pragma mark -
#pragma mark Output
#import "CGMetalVideoOutput.h"
#import "CGMetalPixelBufferSurfaceOutput.h"
#import "CGMetalUIViewOutput.h"

