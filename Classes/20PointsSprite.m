//
//  20PointsSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "20PointsSprite.h"


@implementation Points20Sprite


- (void) additionalSetup{
	canCollide = false;
	isLethal = false;
	doNotAnimate = true;
}


- (void) moveSprite{
	
	moveCount++;
		// sprite was show long enough, disable in next step.
	if(moveCount>HCPoints20MaxPixelLifetime) isActive=false;
	
		// only active sprites can move
	if (isActive) {
		
		currentPosition.x+=movementDelta.x;
		currentPosition.y+=movementDelta.y;
		
	}
}

@end
