//
//  GameOverSprite.m
//  Jumpy
//
//  Created by Sven Putze on 10.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "GameOverSprite.h"


@implementation GameOverSprite


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
