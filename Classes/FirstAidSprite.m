//
//  FirstAidSprite.m
//  Jumpy
//
//  Created by Sven Putze on 03.05.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "FirstAidSprite.h"
#import "Globals.h"


@implementation FirstAidSprite

@synthesize healthBonus;


- (void) additionalSetup{
	canCollide = true;
	isLethal = false;
	healthBonus = HCHealthBonus;
	doNotAnimate = true;
	doNotMove = true;
	boundingBoxSpriteOffset = 2;
}


@end
