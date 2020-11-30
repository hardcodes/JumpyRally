//
//  DoorBlueSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "DoorBlueSprite.h"


@implementation DoorBlueSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = false;
	doNotAnimate = true;
	doNotMove = true;
	boundingBoxSpriteOffset = -1;
}
	
@end
