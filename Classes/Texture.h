//
//  Texture.h
//  Jumpy
//
//  Created by Sven Putze on 18.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>


	// Superclass for texture resources in the game. It simply
	// stores the integer ID of a texture.
	// Drawing methods are defined in childclasses.
@interface Texture : NSObject {
	GLuint textureID;
	
	int textureWidth;
	int textureHeight;

	int textureWidthHalf;
	int textureHeightHalf;
	
	GLfloat texturePixelWidth;
	GLfloat texturePixelHeight;
}

@property (nonatomic, readonly) GLuint textureID;
@property (nonatomic, readonly) int textureWidth;
@property (nonatomic, readonly) int textureHeight;

	// Selector is the preferred init-selector. UIImage with name aImageName is converted into a texture
	// that can directly be used by the GPU. Conversion is made using the EAGL class.
- (id) initWithImageName: (NSString *) aImageName;


//	// Selector takes the texture from the current EAGL renderbuffer.
//- (id) initFromFramebufferWidthXCoordinate: (int) aXCoordinate AndYCoordinate: (int) aYCoordinate WithTextureWidth:(int)aTextureWidth AndTextureHeight:(int)aTextureHeight;


@end
