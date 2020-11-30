	//
	//  EAGL.m
	//  Jumpy
	//
	//  Created by Sven Putze on 17.04.11.
	//  Copyright 2011 hardcodes.de. All rights reserved.
	//

#import "EAGL.h"
#import "Globals.h"


	// Class provides methods for OpenGL fucntions.
@implementation EAGL


#pragma mark - build texture


+ (void) createTextureIdForImage: (NSString *) aImageName forTextureId: (GLuint*) aTextureId{
	
	int textureWidth;
	int textureHeight;
	
	UIImage *sourceImage = [[UIImage imageNamed: aImageName] retain];
	if (sourceImage) {
		
		textureWidth = sourceImage.size.width;
		textureHeight = sourceImage.size.height;
			// OpenGL/GPU can only work with textures with dimensions that are power of 2.
		if ((textureWidth & (textureWidth-1)) != 0 ||
			(textureHeight & (textureHeight-1)) != 0 ||
			textureWidth > 2048 ||
			textureHeight > 2048) {
			NSLog(@"ERROR: %@ width %i or height %i is no power of two or > 2048!", aImageName, textureWidth, textureHeight); 
		}
		else{
				// create pixeldata (AKA convert png image)
			GLubyte *pixelData = [self generatePixelDataFromImage: sourceImage];
				// create texture and store id in texturedID class variable
			[self generateTextureFromArrayOfGLubyte:pixelData widthTextureWidth:textureWidth andTextureHeight:textureHeight forTextureId:aTextureId]; 
				// cleanup
			int usedMemory = textureWidth*textureHeight*4;
			NSLog(@"created %@-texture, size: %i KB, ID: %i", aImageName, usedMemory/1024, *aTextureId);
			free(pixelData);
			
			
		}
		[sourceImage release];
		
	} else {
		NSLog(@"ERROR: %@ can not find picture (typo?), no texture created!", aImageName);
	}
	
}


	// returns an array of GLUbytes representing the png sourceImage
+ (GLubyte *) generatePixelDataFromImage: (UIImage *) aUIImageWithTextureSource {
		// reserve enough memory for the texture
	int textureWidth;
	int textureHeight;
	textureWidth = aUIImageWithTextureSource.size.width;
	textureHeight = aUIImageWithTextureSource.size.height;
	GLubyte *pixelData = (GLubyte *) calloc( textureWidth*textureHeight*4, sizeof(GLubyte) );
		// get current colorspace from Core Graphics
	CGColorSpaceRef imageColorSpace = CGImageGetColorSpace(aUIImageWithTextureSource.CGImage);
		// create graphicscontext which will be used to render the GLUbytes
		// Core Graphics is "misused" to convert the png image into a byte format.
	CGContextRef gfxContext = CGBitmapContextCreate( pixelData, 
													textureWidth, textureHeight, 8, textureWidth*4, 
													imageColorSpace, 
													kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(gfxContext, CGRectMake(0, 0, textureWidth, textureHeight), aUIImageWithTextureSource.CGImage);
	CGContextRelease(gfxContext);
		//CGColorSpaceRelease(imageColorSpace);
	
	return pixelData;
}


+ (void) generateTextureFromArrayOfGLubyte: (GLubyte *) aGLubyteArrayWithPixelData
						 widthTextureWidth: (int) aTextureWidth
						  andTextureHeight: (int) aTextureHeight
							  forTextureId: (GLuint*) aTextureId{
	
	glGenTextures(1, aTextureId);
	glBindTexture(GL_TEXTURE_2D, *aTextureId);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, aTextureWidth, aTextureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, aGLubyteArrayWithPixelData); 
	glEnable(GL_BLEND); glBlendFunc(GL_ONE, GL_SRC_COLOR);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
#if DEBUG
	[self printGLErrorCode];
#endif
	
}


#pragma mark - drawing


//+ (void) drawTextureWithId: (GLuint*) aTextureId
//			andFrameNumber:  (int) aFrameNumber 
//				frameWidth: (int) aFrameWidth
//   rotatedByAngleInDegrees: (int) aRotationAngle
//				atPosition: (CGPoint) aDrawingPosition
//			  textureWidth: (int) aTextureWidth
//			 textureHeight: (int) aTextureHeight{
//	
//		// define the two triangles that add to a rectangle
//	GLshort imageVertices[ ] = {
//			// left lower corner
//		0, aTextureHeight,
//			// right lower corner
//		aFrameWidth, aTextureHeight,
//			// left upper corner
//		0, 0,
//			// right upper corner
//		aFrameWidth,0
//	};
//	
//		// choose the part of the texture that should be rendered
//	GLfloat textureXWidth = 1.0/(aTextureWidth/aFrameWidth);
//	GLfloat x1= aFrameNumber * textureXWidth;
//	GLfloat x2= x1 + textureXWidth;
//	GLfloat textureCoords[8] = {
//			// left lower corner
//		x1,1,
//			// right lower corner
//		x2,1,
//			// left upper corner
//		x1,0,
//			// right upper corner
//		x2,0
//	};
//	
//		//glColor4f(1, 1, 1, 1);
//
//	glBindTexture(GL_TEXTURE_2D, *aTextureId);
//	glVertexPointer(2, GL_SHORT, 0, imageVertices);
//	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
//	
//	glPushMatrix();
//	
//	glTranslatef((int)aDrawingPosition.x+(int)(aFrameWidth/2), (int)aDrawingPosition.y+(int)(aTextureHeight/2), 0);
//	if(aRotationAngle!=0) glRotatef(aRotationAngle, 0, 0, 1);
//	glTranslatef(0-(int)(aFrameWidth/2), 0-(int)(aTextureHeight/2), 0);
//	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//	
//	glPopMatrix();
//	
//#if DEBUG
//	[self printGLErrorCode];
//#endif
//	
//}



//+ (void) drawTextureWithId: (GLuint*) aTextureId
//			andFrameNumber: (int) aFrameNumber 
//					 width: (int) aWidth
//					height: (int) aHeight
//				frameWidth: (int) aFrameWidth
//   rotatedByAngleInDegrees: (int) aRotationAngle
//				atPosition: (CGPoint) aDrawingPosition
//			  textureWidth: (int) aTextureWidth
//			 textureHeight: (int) aTextureHeight{
//	
//	
//		// define the two triangles that add to a rectangle
//	GLshort imageVertices[ ] = {
//			// left lower corner
//		0, aHeight,
//			// right lower corner
//		aWidth,aHeight,
//			// left upper corner
//		0, 0,
//			// right upper corner
//		aWidth,0
//	};
//	
//		// choose the part of the texture that should be rendered
//	GLfloat textureXWidth = 1.0/(aTextureWidth/aFrameWidth);
//	GLfloat x1= aFrameNumber*textureXWidth;
//	GLfloat x2= x1 + textureXWidth;
//	GLfloat textureCoords[ ] = {
//			// left lower corner
//		x1,1,
//			// right lower corner
//		x2,1,
//			// left upper corner
//		x1,0,
//			// right upper corner
//		x2,0
//	};
//	
//	
//	glColor4f(1, 1, 1, 1);
//	glBindTexture(GL_TEXTURE_2D, *aTextureId); 
//	glVertexPointer(2, GL_SHORT, 0, imageVertices);	
//	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
//	
//	glPushMatrix();
//	glTranslatef(aDrawingPosition.x+aFrameWidth/2, aDrawingPosition.y+aTextureHeight/2, 0);
//	glRotatef(aRotationAngle, 0, 0, 1);
//	glTranslatef(0-aFrameWidth/2, 0-aTextureHeight/2, 0); 
//	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); 
//	glPopMatrix();
//#if DEBUG
//	[self printGLErrorCode];
//#endif
//	
//}



+ (void) drawTextureWithId: (GLuint*) aTextureId 
		  withDrawingWidth: (int) aWidth
   rotatedByAngleInDegrees: (int) aRotationAngle
				atPosition: (CGPoint) aDrawingPosition
		  withTextureWidth: (int) aTextureWidth
		  andTextureHeight: (int) aTextureHeight{
	
	
		// define the two triangles that add to a rectangle
	GLshort imageVertices[ ] = {
			// left lower corner
		0, aTextureHeight,
			// right lower corner
		aWidth,aTextureHeight,
			// left upper corner
		0, 0,
			// right upper corner
		aWidth,0
	};
	
		// choose the part of the texture that should be rendered
	GLfloat textureXWidth = 1.0/HCDefaultHealth;
	GLfloat x1= aWidth*textureXWidth;
	GLfloat textureCoords[ ] = {
			// left lower corner
		0,1,
			// right lower corner
		x1,1,
			// left upper corner
		0,0,
			// right upper corner
		x1,0
	};
	
	
	glColor4f(1, 1, 1, 1);
	glBindTexture(GL_TEXTURE_2D, *aTextureId); 
	glVertexPointer(2, GL_SHORT, 0, imageVertices);	
	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
	
	glPushMatrix();
	glTranslatef(aDrawingPosition.x+aWidth/2, aDrawingPosition.y+aTextureHeight/2, 0);
	glRotatef(aRotationAngle, 0, 0, 1);
	glTranslatef(0-aWidth/2, 0-aTextureHeight/2, 0); 
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); 
	glPopMatrix();
#if DEBUG
	[self printGLErrorCode];
#endif
	
}



+ (void) drawTextureWithId: (GLuint*) aTextureId
					 width: (int) aWidth
					height: (int) aHeight
			  textureWidth: (int) aTextureWidth
			 textureHeight: (int) aTextureHeight
   rotatedByAngleInDegrees: (int) aRotationAngle
				atPosition: (CGPoint) aDrawingPosition{
	
		// define the two triangles that add to a rectangle
	GLshort imageVertices[ ] = {
			// left lower corner
		0, aHeight,
			// right lower corner
		aWidth,aHeight,
			// left upper corner
		0, 0,
			// right upper corner
		aWidth,0
	};
	
	
	GLfloat textureTileWidth = 1.0 / aTextureWidth * aWidth;
	GLfloat textureTileHeight = 1.0 / aTextureHeight * aHeight;
	
	
	GLfloat textureCoords[ ] = {
			// left lower corner
		0,textureTileWidth,
			// right lower corner
		textureTileHeight,textureTileWidth,
			// left upper corner
		0,0,
			// right upper corner
		textureTileHeight,0
	};
	
	
	glColor4f(1, 1, 1, 1);
	glBindTexture(GL_TEXTURE_2D, *aTextureId); 
	glVertexPointer(2, GL_SHORT, 0, imageVertices);	
	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
	
	glPushMatrix();
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); 
	glPopMatrix();
	
		//	glDisable(GL_TEXTURE_2D);
	
#if DEBUG
	[self printGLErrorCode];
#endif
	
	
}


#pragma mark - setup

+ (void) setEAGLProjectionWithWidth: (int) aWidth andHeight: (int) aHeight{
		//Set View
	glMatrixMode(GL_PROJECTION); 
	glLoadIdentity();
		// 2D perspective, width and height are seen from protrait perspective
	glOrthof(0, aWidth, aHeight, 0, 0, 1);
		// tell EAGL to rotate all content, so it is seen as UIInterfaceOrientationLandscapeLeft
	glTranslatef( 160, 240, 0);
	glRotatef(-90, 0, 0, 1);
	glTranslatef(-240,-160,0);
		// enable GL_MODELVIEW: from now on just render vertex-arrays
	glMatrixMode(GL_MODELVIEW);
	glEnableClientState(GL_VERTEX_ARRAY); 
	glDisable(GL_DEPTH_TEST); //2D only
	glDisable(GL_DITHER);
	glDisable(GL_ALPHA_TEST);
	glDisable(GL_STENCIL_TEST);
	glDisable(GL_FOG);
	
	
}



+ (void) printGLErrorCode{
	
	GLenum errorCode;
		//	const GLubyte *errorString;
	
	if ((errorCode = glGetError()) != GL_NO_ERROR){
			//		errorString = glGetString(errorCode);
		
		NSLog(@"EAGL error: %i", errorCode);
	}
		//errorCode = glGetError();
	
}


@end
