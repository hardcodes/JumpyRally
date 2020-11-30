	//
	// TextureHandling2D.m
	//
	// 20110415, Sven Putze
	//
#import "TextureClass.h"

@implementation TextureClass


- (void) createTextureFromImage: (NSString *) imageName {
	
	UIImage *sourceImage = [UIImage imageNamed: imageName];
	if (sourceImage) {
			// remember width and height from sourceimage = later render dimensions
		textureWidth = sourceImage.size.width;
		textureHeight = sourceImage.size.height;
		if ((textureWidth & (textureWidth-1)) != 0 || (textureHeight & (textureHeight-1)) != 0
			|| textureWidth > 2048 || textureHeight > 2048) {
			NSLog(@"ERROR: %@ width %i or height %i is no power of two or > 2048!", imageName, textureWidth, textureHeight); 
		}
		
			// create pixeldata (AKA convert png image)
		GLubyte *pixelData = [self generatePixelDataFromImage: sourceImage];
		
			// create texture and store id in texturedID class variable
		[self generateTexture: pixelData]; 
		
			// cleanup
		int usedMemory = textureWidth*textureHeight*4;
		NSLog(@"created %@-texture, size: %i KB, ID: %i", imageName, usedMemory/1024, textureID);
		free(pixelData);
		[sourceImage release]; 
	} else {
		NSLog(@"ERROR: %@ can not find picture (typo?), no texture created!", imageName);
	}
}


	// returns an array of GLUbytes representing the png sourceImage
- (GLubyte *) generatePixelDataFromImage: (UIImage *) sourceImage {
		// reserve enough memory for the texture
	GLubyte *pixelData = (GLubyte *) calloc( textureWidth*textureHeight*4, sizeof(GLubyte) );
		// get current colorpasce
	CGColorSpaceRef imageColorSpace = CGImageGetColorSpace(sourceImage.CGImage);
		// create graphicscontext which will be used to render the GLUbytes
	CGContextRef gfxContext = CGBitmapContextCreate( pixelData, 
											textureWidth, textureHeight, 8, textureWidth*4, 
											imageColorSpace, 
											kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(gfxContext, CGRectMake(0, 0, textureWidth, textureHeight), sourceImage.CGImage);
	CGContextRelease(gfxContext);
		//CGColorSpaceRelease(imageColorSpace);

	return pixelData;
}
 

- (void) generateTexture: (GLubyte *) pixelData {
	glGenTextures(1, &textureID);
	glBindTexture(GL_TEXTURE_2D, textureID);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureWidth, textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixelData); 
	
		// ???
	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

	// draw texture without any animantion, e.g. text/fonts
- (void) drawCompleteTextureAtPosition: (CGPoint) p {
	
		// define the two triangles that add to a rectangle
		// use the complete width and height of the texture for sizing
	GLshort imageVertices[ ] = {
			// left lower corner
		0,textureHeight,
			// eight lower corner
		textureWidth,textureHeight,
			// left upper corner
		0,0,
			// right upper corner
		textureWidth,0
	};
	
	GLshort textureCoords[ ] = {
			// left lower corner
		0, 1,
			// right lower corner
		1, 1,
			// left upper corner
		0, 0,
			// right upper corner
		1, 0
	};
	
		//
	glEnable(GL_TEXTURE_2D);
	
	glColor4f(1, 1, 1, 1);
	glBindTexture(GL_TEXTURE_2D, textureID); 
	glVertexPointer(2, GL_SHORT, 0, imageVertices);	
	glTexCoordPointer(2, GL_SHORT, 0, textureCoords);
	
	glPushMatrix();
	glTranslatef(p.x, p.y, 0);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); 
	glPopMatrix();
	
	glDisable(GL_TEXTURE_2D);
}


- (void) drawFrame: (int) frameNumber 
		 withWidth: (int) frameWidth
	rotatedByAngle: (int) degrees
		atPosition: (CGPoint) positionToRender {
	
		// define the two triangles that add to a rectangle
	GLshort imageVertices[ ] = {
			// left lower corner
		0, textureHeight,
			// right lower corner
		frameWidth,textureHeight,
			// left upper corner
		0, 0,
			// right upper corner
		frameWidth,0
	};
	
	GLfloat txW = 1.0/(textureWidth/frameWidth);
	GLfloat x1= frameNumber*txW;
	GLfloat x2= x1 + txW;
	GLfloat textureCoords[ ] = {
			// left lower corner
		x1,1,
			// right lower corner
		x2,1,
			// left upper corner
		x1,0,
			// right upper corner
		x2,0
	};
	
	glEnable(GL_TEXTURE_2D);
	
	glColor4f(1, 1, 1, 1);
	glBindTexture(GL_TEXTURE_2D, textureID); 
	glVertexPointer(2, GL_SHORT, 0, imageVertices);	
	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
	
	glPushMatrix();
	glTranslatef(positionToRender.x+frameWidth/2, positionToRender.y+textureHeight/2, 0);
	glRotatef(degrees, 0, 0, 1);
	glTranslatef(0-frameWidth/2, 0-textureHeight/2, 0); 
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); 
	glPopMatrix();
	
	glDisable(GL_TEXTURE_2D);
}


- (GLuint) getTextureID {
	return textureID;
}


- (int) getTextureWidth {
	return textureWidth;
}


- (int) getTextureHeight {
	return textureHeight;
}


- (void) dealloc {
	NSLog(@"Delete texture, ID: %i", textureID);
	glDeleteTextures(1, &textureID);
	[super dealloc];
}

@end
