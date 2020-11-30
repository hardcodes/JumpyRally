//
//  OneCountDownSprite.m
//  Jumpy
//
//  Created by Putze Sven on 02.10.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "OneCountDownSprite.h"
#import "SpriteResourceHandler.h"
#import "SoundEngine.h"

@implementation OneCountDownSprite


- (void) additionalSetup{
	
	[super additionalSetup];
	[[spriteResourceHandler soundEngine] playSoundOfType: ONESOUND at2DPosition: currentPosition];
}



- (void) autoDestroyAction{
	
	[spriteResourceHandler createSpriteOfType: GOSEQUENCESPRITE atPosition: currentPosition];
	[gameStateEngine setNewTouchHasBegun: false];
	
}

@end
