//
//  SmokeSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "SmokeSprite.h"


@implementation SmokeSprite


- (void) additionalSetup{
	canCollide = false;
	isLethal = false;
	autoDestroy = true;
	doNotMove = true;
}


@end
