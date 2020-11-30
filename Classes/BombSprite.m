//
//  BombSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "BombSprite.h"
#import "SpriteResourceHandler.h"
#import "GameStateEngine.h"


@implementation BombSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = false;
	doNotAnimate = true;
	moveType=NOMOVE;
	checkMoveType=true;
}


- (void) fallenSpriteHasHitBottomAction{
	
		// bombs that hit the ground, explode
	isActive = false;
	canCollide = false;
		// create an explosion
	[spriteResourceHandler createSpriteOfType: EXPLOSION atPosition: CGPointMake(currentPosition.x-HCBombTimerDistance, currentPosition.y-HCBombTimerDistance)];
		// delete the bomb from the layer so that the player sprite or other sprites can not collide anymore
	int xCoordinate = [self getTileXCoordinateForPoint:currentPosition];
	int yCoordinate = [self getTileYCoordinateForPoint:currentPosition];
	[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
	
}


@end
