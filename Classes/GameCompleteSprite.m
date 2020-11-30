//
//  GameCompleteSprite.m
//  Jumpy
//
//  Created by Sven Putze on 30.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "GameCompleteSprite.h"


@implementation GameCompleteSprite


- (void) additionalSetup{
	canCollide = false;
	isLethal = false;
	moveType = NOMOVE;
	doNotAnimate = true;
	doNotMove = true;
	
}


- (void) drawNextAnimationFrame{
	
		// render sprite
	[spriteTexture drawFrame: 0
			  frameWidth: frameWidth
	 rotatedByAngleInDegrees: rotationAngle
				  atPosition: CGPointMake(currentPosition.x, currentPosition.y)];
	
}


@end
