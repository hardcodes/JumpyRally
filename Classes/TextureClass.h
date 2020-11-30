	//
	// TextureHandling2D.h
	//
	// 20110415, Sven Putze
	//
#import <OpenGLES/ES1/gl.h>


	// Class that is used for sprite texture resources in the game.
	// A given sourceimage (png-file) is converted in a format that is
	// used by the graphics processor (GPU) in the iPhone.
	// The created class itself is stored from the caller (Sprite).
	// Alle drawing routines for the texture are delivered by this class.
@interface TextureClass : NSObject {
	GLuint textureID;
	int textureWidth;
	int textureHeight;
}

	// Converts a given png image into a format that is understood by the GPU.
- (void) createTextureFromImage: (NSString *) imageName;

	// Selector coverts a given png image into an array of GLubyte.
- (GLubyte *) generatePixelDataFromImage: (UIImage *) sourceImage;

	// Selector converts a given array of GLubyte into a GPU understandable format.
- (void) generateTexture: (GLubyte *) pixelData;

	// Draws a part of the texture on the graphics context.
	// TODO: version that is capable of drawing tiles
- (void) drawFrame: (int) frameNumber 
		 withWidth: (int) frameWidth
		  rotatedByAngle: (int) degrees
		atPosition: (CGPoint) positionToRender;

	// Selector returns the OpenGLES ID of the texture in graphics memory
- (GLuint) getTextureID;

	// Selector returns the Width of the complete texture in pixels
- (int) getTextureWidth;

	// Selector returns the Height of the complete texture in pixels
- (int) getTextureHeight;

@end
