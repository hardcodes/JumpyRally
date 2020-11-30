//
//  GoCountDownSprite.m
//  Jumpy
//
//  Created by Putze Sven on 02.10.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "GoCountDownSprite.h"
#import "GameStateEngine.h"
#import "GameStatus.h"
#import "SoundEngine.h"

@implementation GoCountDownSprite


- (void) additionalSetup{
	
		[super additionalSetup];
		[[spriteResourceHandler soundEngine] playSoundOfType: GOSOUND at2DPosition: currentPosition];
}



- (void) autoDestroyAction{
	
	[[gameStateEngine gameStatus] setGameState: [[gameStateEngine gameStatus] lastGameState]];
	[gameStateEngine resetTouch];
}

@end
