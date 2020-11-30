	//
	// SpriteTexture.h
	//
	// 20110415, Sven Putze
	//
#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import "Texture.h"


	// Class that is used for sprite texture resources in the game. It simply
	// stores the integer ID of a texture.
	// All methods are wrappers for the EAGL class.
@interface SpriteTexture : Texture {

}

	// Selector draws a part of the texture to the framebuffer.
- (void) drawFrame: (int) aFrameNumber 
		frameWidth: (int) aFrameWidth
rotatedByAngleInDegrees: (int) aRotationAngle
		atPosition: (CGPoint) aDrawingPosition;



	// Selector draws a part of the texture with a given zoomfactor
	// to the framebuffer.
- (void) drawFrame: (int) aFrameNumber 
		frameWidth: (int) aFrameWidth
	  drawingWidth: (int) aDrawingWidth
	 drawingHeight: (int) aDrawingHeight
rotatedByAngleInDegrees: (int) aRotationAngle
		atPosition: (CGPoint) aDrawingPosition;


@end
