//
//  LevelCompleteSprite.m
//  Jumpy
//
//  Created by Sven Putze on 21.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "LevelCompleteSprite.h"


@implementation LevelCompleteSprite


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
