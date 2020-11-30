//
//  FireSprite.m
//  Jumpy
//
//  Created by Sven Putze on 21.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "FireSprite.h"
#import "SpriteResourceHandler.h"


@implementation FireSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = true;
	autoDestroy = true;
	doNotMove = true;
	animationSequenceIndex = (arc4random() % animationSequence[0]-1) +1;
	[[spriteResourceHandler soundEngine] playSoundOfType: BURNINGSOUND at2DPosition: currentPosition];
	
}


- (void) autoDestroyAction{
		// fire resolves in smoke...
	[spriteResourceHandler createSpriteOfType: SMOKE atPosition: currentPosition];
}


- (void) endOfAnimationSequenceReachedAction{
		// fire keeps burning
	[[spriteResourceHandler soundEngine] playSoundOfType: BURNINGSOUND at2DPosition: currentPosition];
}


@end
