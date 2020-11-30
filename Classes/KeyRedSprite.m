//
//  KeyRedSprite.m
//  Jumpy
//
//  Created by Sven Putze on 21.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "KeyRedSprite.h"
#import "Globals.h"


@implementation KeyRedSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = false;
	doNotAnimate = true;
	doNotMove = true;
}


- (void) moveSprite{
	
		// only active sprites can move
	if (isActive && !doNotMove) {
		
		moveCount++;
			// sprite was show long enough, disable in next step.
		if(moveCount>HCKeyMaxPixelLifetime) isActive=false;
		
		
		rotationAngle += HCKeyRotationAngle;
		if(rotationAngle > 360) rotationAngle = rotationAngle - 360;
		
			// only active sprites can move
		if (isActive) {
			
			currentPosition.x+=movementDelta.x;
			currentPosition.y+=movementDelta.y;
			
		}
	}
}


@end
