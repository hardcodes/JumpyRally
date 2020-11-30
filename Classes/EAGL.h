	//
	//  EAGL.h
	//  Jumpy
	//
	//  Created by Sven Putze on 17.04.11.
	//  Copyright 2011 hardcodes.de. All rights reserved.
	//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CGImage.h>
#import "HealthStatusBar.h"


@interface EAGL : NSObject {
    
}

	// Converts a given png image into a format that is understood by the GPU.
+ (void) createTextureIdForImage: (NSString *) aImageName forTextureId: (GLuint*) aTextureId;


	// Selector coverts a given png image into an array of GLubyte.
+ (GLubyte *) generatePixelDataFromImage: (UIImage *) aUIImageWithTextureSource;


	// Selector converts a given array of GLubyte into a GPU understandable format.
+ (void) generateTextureFromArrayOfGLubyte: (GLubyte *) aGLubyteArrayWithPixelData
						 widthTextureWidth: (int) aTextureWidth
						  andTextureHeight: (int) aTextureHeight
							  forTextureId: (GLuint*) aTextureId;


	//	// Selector creates a texture/id from imagedata that has already been rendered in the framebuffer.
	//	// Thus a texture can be build up from smaller textures AKA tiles.
	//+ (void) createTextureIdFromFramebufferWidthXCoordinate: (int) aXCoordinate yCoordinate: (int) aYCoordinate textureWidth:(int)aTextureWidth textureHeight:(int)aTextureHeight border: (int) aBorder forGLuint:(GLuint*)aGLuint; 


//	// Draws a part of the texture on the EAGL graphics context.
//+ (void) drawTextureWithId: (GLuint*) aTextureId
//			andFrameNumber: (int) aFrameNumber 
//				frameWidth: (int) aFrameWidth
//   rotatedByAngleInDegrees: (int) aRotationAngle
//				atPosition: (CGPoint) aDrawingPosition
//			  textureWidth: (int) aTextureWidth
//			 textureHeight: (int) aTextureHeight;


//	// Draws a part of the texture on the EAGL graphics context.
//	// width and height are the current drawing size, can be used to
//	// zoom in or out
//+ (void) drawTextureWithId: (GLuint*) aTextureId
//			andFrameNumber: (int) aFrameNumber 
//					 width: (int) aWidth
//					height: (int) aHeight
//				frameWidth: (int) aFrameWidth
//   rotatedByAngleInDegrees: (int) aRotationAngle
//				atPosition: (CGPoint) aDrawingPosition
//			  textureWidth: (int) aTextureWidth
//			 textureHeight: (int) aTextureHeight;


	// Selector draws a part of the texture on the EAGL graphics context.
	// It is called from the special sprite HealthStatusSprite.
+ (void) drawTextureWithId: (GLuint*) aTextureId 
		  withDrawingWidth: (int) aWidth
   rotatedByAngleInDegrees: (int) aRotationAngle
				atPosition: (CGPoint) aDrawingPosition
		  withTextureWidth: (int) aTextureWidth
		  andTextureHeight: (int) aTextureHeight;


	// Selector draws a complete texture at the given position
+ (void) drawTextureWithId: (GLuint*) aTextureId
					 width: (int) aWidth
					height: (int) aHeight
			  textureWidth: (int) aTextureWidth
			 textureHeight: (int) aTextureHeight
   rotatedByAngleInDegrees: (int) aRotationAngle
				atPosition: (CGPoint) aDrawingPosition;



+ (void) setEAGLProjectionWithWidth: (int) aWidth andHeight: (int) aHeight;


+ (void) printGLErrorCode;

@end
