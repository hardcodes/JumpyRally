//
//  ExplosionSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "ExplosionSprite.h"


@implementation ExplosionSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = true;
	autoDestroy = true;
	doNotMove = true;
}
@end
