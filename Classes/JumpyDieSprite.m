//
//  JumpyDieSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "JumpyDieSprite.h"
#import "SpriteResourceHandler.h"


@implementation JumpyDieSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = false;
	autoDestroy = true;
	doNotMove = true;
}

- (void) autoDestroyAction{
	
	CGPoint position = currentPosition;
	position.x = position.x-8;
	[spriteResourceHandler createSpriteOfType: JUMPYANGEL atPosition: position];
	[[gameStateEngine soundEngine] stopAllSounds];
	[[gameStateEngine soundEngine] setGlobalSfxVolume: 0];
	[[gameStateEngine soundEngine] setMasterMusicVolume: HCDefaultMusicVolume];
	[[gameStateEngine soundEngine] playMusicOfType: GAMEOVERSONG timesToRepeat: HCGameOverMusicRepeatCount];

	
}

@end
