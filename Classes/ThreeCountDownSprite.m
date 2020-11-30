//
//  ThreeCountDownSprite.m
//  Jumpy
//
//  Created by Putze Sven on 02.10.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "ThreeCountDownSprite.h"
#import "SpriteResourceHandler.h"
#import "SoundEngine.h"

@implementation ThreeCountDownSprite


- (void) additionalSetup{
	
		[super additionalSetup];
		[[spriteResourceHandler soundEngine] playSoundOfType: THREESOUND at2DPosition: currentPosition];
}

- (void) autoDestroyAction{
	
	[spriteResourceHandler createSpriteOfType: TWOSEQUENCESPRITE atPosition: currentPosition];
	
}

@end
