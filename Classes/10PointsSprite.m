//
//  10PointsSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "10PointsSprite.h"


@implementation Points10Sprite


- (void) additionalSetup{
	canCollide = false;
	isLethal = false;
	doNotAnimate = true;
	moveCount = 0;
}

- (void) moveSprite{
	
	moveCount++;
		// sprite was show long enough, disable in next step.
	if(moveCount>HCPoints10MaxPixelLifetime) isActive=false;
	
		// only active sprites can move
	if (isActive) {
		
		currentPosition.x+=movementDelta.x;
		currentPosition.y+=movementDelta.y;

	}
}


@end
