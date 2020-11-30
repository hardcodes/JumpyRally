	//
	// SpriteTexture.m
	//
	// 20110415, Sven Putze
	//
#import "SpriteTexture.h"
#import "EAGL.h"

@implementation SpriteTexture


#pragma mark - drawing 

- (void) drawFrame: (int) aFrameNumber 
		frameWidth: (int) aFrameWidth
rotatedByAngleInDegrees: (int) aRotationAngle
		atPosition: (CGPoint) aDrawingPosition {
	
	int frameWidthHalf = aFrameWidth/2;
	
	GLuint x1Int = aFrameNumber * aFrameWidth;
	GLuint y1Int = 0;
	GLuint x2int = x1Int + aFrameWidth;
	GLuint y2int = y1Int + textureHeight;
	
	GLfloat x1 = x1Int * texturePixelWidth;
	GLfloat x2 = x2int * texturePixelWidth; 
	GLfloat y1 = y1Int * texturePixelHeight;
	GLfloat y2 = y2int * texturePixelHeight;
	
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
	
		// define the two triangles that add to a rectangle
	GLshort imageVertices[8] = {
			// left lower corner
		0, textureHeight,
			// right lower corner
		aFrameWidth, textureHeight,
			// left upper corner
		0, 0,
			// right upper corner
		aFrameWidth,0
	};
	
	
	glBindTexture(GL_TEXTURE_2D, textureID);
	glVertexPointer(2, GL_SHORT, 0, imageVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
	
	glPushMatrix();
	
	if(aRotationAngle!=0){
		glTranslatef((int)aDrawingPosition.x +frameWidthHalf, (int)aDrawingPosition.y+textureHeightHalf, 0);
		glRotatef(aRotationAngle, 0, 0, 1);
		glTranslatef(-frameWidthHalf, -textureHeightHalf, 0);
	}
	else{
			// save one transformation if no rotation needed
		glTranslatef((int)aDrawingPosition.x, (int)aDrawingPosition.y, 0);
	}
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glPopMatrix();
	
#if DEBUG
	[EAGL printGLErrorCode];
#endif
	
}



- (void) drawFrame: (int) aFrameNumber 
		frameWidth: (int) aFrameWidth
	  drawingWidth: (int) aDrawingWidth
	 drawingHeight: (int) aDrawingHeight
rotatedByAngleInDegrees: (int) aRotationAngle
		atPosition: (CGPoint) aDrawingPosition{
	
	int drawingWidthHalf = aDrawingWidth/2;
	int drawingHeightHalf = aDrawingHeight/2;
	
	GLuint x1Int = aFrameNumber * aFrameWidth;
	GLuint y1Int = 0;
	GLuint x2int = x1Int + aFrameWidth;
	GLuint y2int = y1Int + textureHeight;
	
	GLfloat x1 = x1Int * texturePixelWidth;
	GLfloat x2 = x2int * texturePixelWidth; 
	GLfloat y1 = y1Int * texturePixelHeight;
	GLfloat y2 = y2int * texturePixelHeight;
	
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
	
		// define the two triangles that add to a rectangle
	GLshort scaledImageVertices[8] = {
			// left lower corner
		0, aDrawingHeight,
			// right lower corner
		aDrawingWidth, aDrawingHeight,
			// left upper corner
		0, 0,
			// right upper corner
		aDrawingWidth,0
	};
	
	
	glBindTexture(GL_TEXTURE_2D, textureID);
	glVertexPointer(2, GL_SHORT, 0, scaledImageVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
	
	glPushMatrix();
	
	if(aRotationAngle!=0){
		glTranslatef((int)aDrawingPosition.x +drawingWidthHalf, (int)aDrawingPosition.y +drawingHeightHalf, 0);
		glRotatef(aRotationAngle, 0, 0, 1);
		glTranslatef(-drawingWidthHalf, -drawingHeightHalf, 0);
	}
	else{
			// save one transformation if no rotation needed
		glTranslatef((int)aDrawingPosition.x, (int)aDrawingPosition.y, 0);
	}
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glPopMatrix();
	
#if DEBUG
	[EAGL printGLErrorCode];
#endif
	
}




@end
