//
//  JumpyAngelSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "JumpyAngelSprite.h"
#import "GameStateEngine.h"
#import "SpriteResourceHandler.h"
#import "Globals.h"
#import "GameStatus.h"
#import "PersistanceHandler.h"


@implementation JumpyAngelSprite

- (void) additionalSetup{
	canCollide = false;
	isLethal = false;
}


- (void) moveSprite{
	
	if (isActive) {
		
		currentPosition.y+=movementDelta.y;
		if(currentPosition.y <= 0 ) {
			isActive = false;
			[[gameStateEngine  gameStatus] setGameState: GAME_OVER];
			[spriteResourceHandler createSpriteOfType: GAMEOVER atPosition: CGPointMake(HCLogo256X, HCLogo256Y)];
			[spriteResourceHandler createSpriteOfType: POINTINGHANDSPRITE
														 atPosition: CGPointMake(HCPointingHandX, HCPointingHandY)];

			[gameStateEngine setNewTouchHasBegun: false];
		}

	}
	
}

@end
