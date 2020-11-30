//
//  GoldCoinSprite.m
//  Jumpy
//
//  Created by Sven Putze on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoldCoinSprite.h"


@implementation GoldCoinSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = false;
	doNotMove = true;
	boundingBoxSpriteOffset = 3;
	animationSequenceIndex = (arc4random() % animationSequence[0]-1) +1;
}



@end
