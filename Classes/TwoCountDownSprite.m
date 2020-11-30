//
//  TwoCountDownSprite.m
//  Jumpy
//
//  Created by Putze Sven on 02.10.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "TwoCountDownSprite.h"
#import "SpriteResourceHandler.h"
#import "SoundEngine.h"

@implementation TwoCountDownSprite


- (void) additionalSetup{
		
	[super additionalSetup];
	[[spriteResourceHandler soundEngine] playSoundOfType: TWOSOUND at2DPosition: currentPosition];
}




- (void) autoDestroyAction{
	
	[spriteResourceHandler createSpriteOfType: ONESEQUENCESPRITE atPosition: currentPosition];
	
}

@end
