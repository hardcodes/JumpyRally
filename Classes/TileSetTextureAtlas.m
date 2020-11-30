	//
	//  TileSetTexture.m
	//  Jumpy
	//
	//  Created by Sven Putze on 18.04.11.
	//  Copyright 2011 hardcodes.de. All rights reserved.
	//

#import "TileSetTextureAtlas.h"
#import "GameStateEngine.h"
#import "EAGL.h"


@implementation TileSetTextureAtlas



- (void)drawTileAtXCoordinate: (GLuint) aDrawingXCoordinate
				andYCordinate: (GLuint) aDrawingYCoordinate
				withTileWidth: (GLuint) aTileWidth
				andTileHeight: (GLuint) aTileHeight
		  withTileXCoordinate: (GLuint) aAtlasXCoordinate
		   andTileYCoordinate: (GLuint) aAtlasYCoordinate{

		// choose the part of the texture that should be rendered
		// calculate the position of the tile in pixels
		// then transform to OpenGLES texturesize
	
		// TODO replace hardcoded values
	
	GLuint x1Int = aAtlasXCoordinate * aTileWidth +1;
	GLuint y1Int = aAtlasYCoordinate * aTileHeight +1;
	GLuint x2int = x1Int + HCTileInnerSize;
	GLuint y2int = y1Int + HCTileInnerSize;
	
	GLfloat x1= x1Int * texturePixelWidth;
	GLfloat x2= x2int * texturePixelWidth; 
	GLfloat y1= y1Int * texturePixelHeight;
	GLfloat y2= y2int * texturePixelHeight;
	
	GLfloat textureCoords[8] = {
			// left lower corner
		x1,y2,
			// right lower corner
		x2,y2,
			// left upper corner
		x1,y1,
			// right upper corner
		x2,y1
	};
	
		// define the two triangles that add to a rectangle (pixelsize)
	GLshort imageVertices[8] = {
			// left lower corner
		0, 16,
			// right lower corner
		16,16,
			// left upper corner
		0, 0,
			// right upper corner
		16,0
	};
	
	glVertexPointer(2, GL_SHORT, 0, imageVertices);	
	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
		// texture would be drawn in the upper left corner, place it on the right position
	glPushMatrix();
	glTranslatef(aDrawingXCoordinate, aDrawingYCoordinate, 0);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); 
	glPopMatrix();
	
#if DEBUG
	[EAGL printGLErrorCode];
#endif
	
	
}


@end
