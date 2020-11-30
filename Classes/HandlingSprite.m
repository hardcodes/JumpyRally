//
//  handlingSprite.m
//  Jumpy
//
//  Created by Putze Sven on 29.09.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "HandlingSprite.h"
#import "GameStateEngine.h"
#import "GameStatus.h"

@implementation HandlingSprite



- (void) additionalSetup{
	canCollide = false;
	isLethal = false;
	moveType = NOMOVE;
	doNotAnimate = true;
	doNotMove = true;
	
}


- (void) drawNextAnimationFrame{
	
	if([[gameStateEngine gameStatus] totalScore] > 0) isActive = false;

		// render sprite
	[spriteTexture drawFrame: 0
			  frameWidth: frameWidth
	 rotatedByAngleInDegrees: rotationAngle
				  atPosition: CGPointMake(currentPosition.x, currentPosition.y)];
	
}


@end
