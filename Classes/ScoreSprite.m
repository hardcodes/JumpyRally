	//
	//  ScoreSprite.m
	//  Jumpy
	//
	//  Created by Sven Putze on 09.05.11.
	//  Copyright 2011 hardcodes.de. All rights reserved.
	//

#import "ScoreSprite.h"


@implementation ScoreSprite

@synthesize score;


- (void) additionalSetup{
	canCollide = false;
	isLethal = false;
	score = 0;
	positionCopy = currentPosition;

	
}

- (void) drawCurrentScore: (int) aScore{
	
	score = aScore;
		// safety net if score is too big for display
	if(score > 99999) return;
	
		// 10000
	frameNumber = score / 10000;
	currentPosition = positionCopy;
	[self drawNextAnimationFrame];
	score = aScore % 10000;
		// 1000
	frameNumber = score / 1000;
	currentPosition.x = positionCopy.x + 12;
	[self drawNextAnimationFrame];
	score = aScore % 1000;
		// 100
	frameNumber = score / 100;
	currentPosition.x = positionCopy.x + 24;
	[self drawNextAnimationFrame];
	score = aScore % 100;
		// 10
	frameNumber = score / 10;
	currentPosition.x = positionCopy.x + 36;
	[self drawNextAnimationFrame];
		// 1
	frameNumber = aScore % 10;
	currentPosition.x = positionCopy.x + 48;
	[self drawNextAnimationFrame];
	
}


- (void) drawNextAnimationFrame {
	
		// render sprite
	[spriteTexture drawFrame: frameNumber
				  frameWidth: frameWidth
	 rotatedByAngleInDegrees: rotationAngle
				  atPosition: CGPointMake(currentPosition.x, currentPosition.y)];
	
}


@end
