//
//  StandardDieSprite.m
//  Jumpy
//
//  Created by Sven Putze on 15.05.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "StandardDieSprite.h"
#import "Globals.h"


@implementation StandardDieSprite

- (void) additionalSetup{
	canCollide = false;
	isLethal = false;
	doNotMove = true;
	remainingFrames = HCStandardDieSequenceFrameCount;
	rotationAngle = 360;
}


- (void)drawNextAnimationFrame{
	
	remainingFrames -=1;
	if(remainingFrames <=0) isActive = false;
	
	rotationAngle -= HCStandardDieAngle;
	if(rotationAngle <= 0) rotationAngle = rotationAngle + 360;
	
	[super drawNextAnimationFrame];
}


@end
