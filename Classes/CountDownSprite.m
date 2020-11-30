//
//  CountDownSprite.m
//  Jumpy
//
//  Created by Putze Sven on 30.09.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "CountDownSprite.h"
#import "GameStateEngine.h"
#import "GameStatus.h"

@implementation CountDownSprite


- (void) additionalSetup{
	canCollide = false;
	isLethal = false;
	moveType = NOMOVE;
	doNotAnimate = false;
	doNotMove = true;
	autoDestroy = true;
	
	currentZoomWidth = frameWidth;
	currentZoomHeight = frameHeight;
	zoomFrameCount = HCCountDownZoomRate;
	
}



- (void) drawNextAnimationFrame{
	
	if(isActive){
		
		zoomFrameCount -= 1;
		if(zoomFrameCount <= 0){
			
			zoomFrameCount = HCCountDownZoomRate;
			
			currentZoomWidth += HCCountDownZoomRate;
			currentZoomHeight += HCCountDownZoomRate;
			
			if(currentZoomWidth > HCCountDownMaxZoomWidth) isActive = false;
		}
		
		frameNumber = [self getNextAnimationFrameNumber];
		
		[spriteTexture drawFrame: frameNumber
					  frameWidth: frameWidth
						   drawingWidth: currentZoomWidth
						  drawingHeight: currentZoomHeight
		 rotatedByAngleInDegrees: rotationAngle
					  atPosition: CGPointMake(currentPosition.x - (currentZoomWidth/2), currentPosition.y - (currentZoomHeight/2))];
		
	}
}

@end
