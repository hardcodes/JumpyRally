//
//  BombTimerSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "BombTimerSprite.h"
#import "GameStateEngine.h"
#import "SpriteResourceHandler.h"


@implementation BombTimerSprite



- (void) additionalSetup{
	canCollide = true;
	isLethal = false;
	autoDestroy = true;
	moveType = NOMOVE;
	checkMoveType = true;
}

- (void) autoDestroyAction{
	
		// create an explosion
	[spriteResourceHandler createSpriteOfType: EXPLOSION atPosition: CGPointMake(currentPosition.x-HCBombTimerDistance, currentPosition.y-HCBombTimerDistance)];
		// delete the bomb from the layer so that the player sprite or other sprites can not collide anymore
	int xCoordinate = [self getTileXCoordinateForPoint:currentPosition];
	int yCoordinate = [self getTileYCoordinateForPoint:currentPosition];
	[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
	[[spriteResourceHandler soundEngine] playSoundOfType: EXPLOSIONSOUND at2DPosition: currentPosition];
	
}


- (void) nextAnimationSequenceFrameSelected{
	 [[spriteResourceHandler soundEngine] playSoundOfType: BOMBTIMERSOUND at2DPosition: currentPosition];
}


@end
