//
//  WoodBoxSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "WoodBoxSprite.h"
#import "SpriteResourceHandler.h"


@implementation WoodBoxSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = false;
	doNotAnimate = true;
	checkMoveType = true;
}



#pragma mark - no movement 

- (void) noMove{
	
	int gid = [self getSpriteLayerTileGidAtPoint: CGPointMake(currentPosition.x+8, currentPosition.y+HCTileInnerSizeHalf)];
	if(tileGidOnLayer != gid){
			// if we are not moving and for some reason our tileGid is not stored in the layer/map
			// then destroy ourself.
		isActive = false;
		canCollide = false;
		isLethal = false;
		[spriteResourceHandler createSpriteOfType: SMOKE atPosition: currentPosition];
		
	}
	else [super noMove];
}


#pragma mark - falling on ground 

- (void) fallenSpriteHasHitBottomAction{
	
	if(fallenDistance > HCBoxMaxFallPixels){
			// rock has fallen too many pixels - when it hits something it will be destroyed
		isActive = false;
		canCollide = false;
		isLethal = false;
		[spriteResourceHandler createSpriteOfType: SMOKE atPosition: currentPosition];
	}
	else{
		
		[super fallenSpriteHasHitBottomAction];
		
	}
}

@end
