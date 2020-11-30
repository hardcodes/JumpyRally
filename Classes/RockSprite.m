//
//  RockSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "RockSprite.h"
#import "Globals.h"
#import "SpriteResourceHandler.h"


@implementation RockSprite



- (void) additionalSetup{
	canCollide = true;
	isLethal = false;
	doNotAnimate = true;
	checkMoveType = true;
	rotationAngle = (arc4random() % 360);
	boundingBoxSpriteOffset = HCRockBoundingBoxSpriteOffset;
}


#pragma mark - flying ==	

-(void) fly{
	
	if(movementDelta.x > 0){
			// moving right = rotate right
		rotationAngle += HCRockAngle;
		if(rotationAngle > 360) rotationAngle = rotationAngle - 360;
	}
	else{
			// moving left = rotate left
		rotationAngle -= HCRockAngle;
		if(rotationAngle <= 0) rotationAngle = rotationAngle + 360;
	}
	
	if ([self boundingBoxHasCollidedWithBackground]){
			// create dust = smoke
		isActive = false;
		canCollide = false;
		isLethal = false;
		[spriteResourceHandler createSpriteOfType: SMOKE atPosition: currentPosition];
		[[spriteResourceHandler soundEngine] playSoundOfType: ROCKRUMBLESOUND at2DPosition: currentPosition];
	}
	
	if(movementDelta.x==0 && movementDelta.y==0){
		movementDelta=CGPointMake(0,1);
		moveType = FALL;
	}
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
		[[spriteResourceHandler soundEngine] playSoundOfType: ROCKRUMBLESOUND at2DPosition: currentPosition];
		
	}
	else [super noMove];
}


#pragma mark - falling on ground 

- (void) fallenSpriteHasHitBottomAction{
	
	if(fallenDistance > HCRockMaxFallPixels){
			// rock has fallen too many pixels - when it hits something it will be destroyed
		isActive = false;
		canCollide = false;
		isLethal = false;
		[spriteResourceHandler createSpriteOfType: SMOKE atPosition: currentPosition];
		[[spriteResourceHandler soundEngine] playSoundOfType: ROCKRUMBLESOUND at2DPosition: currentPosition];
	}
	else{
		
		[super fallenSpriteHasHitBottomAction];

	}
}


#pragma mark - direction =

- (void) setFlightPathRelativeToPoint: (CGPoint) aPoint{
	
	isLethal = true;
	moveType = FLY;
	
	int value;
	if (currentPosition.x < aPoint.x){
			// rock is left from the explosion center
		value = -(HCExplosionCenterDistance + HCRockExplosionOffset - (aPoint.x - currentPosition.x));
		value = value / HCRockMovementDeltaFraction - HCRockMovementDeltaOffset;
		movementDelta.x = value;
	}
	else{
			// rock is right from the explosion
		value = HCExplosionCenterDistance + HCRockExplosionOffset - (currentPosition.x - aPoint.x);
		value = value / HCRockMovementDeltaFraction + HCRockMovementDeltaOffset;
		movementDelta.x = value;
	}
	
	if (currentPosition.y < aPoint.y){
			// rock is above the explosion center
		value = -(HCExplosionCenterDistance + HCRockExplosionOffset + HCRockExplosionOffset - (aPoint.y - currentPosition.y));
		value = value / HCRockMovementDeltaFraction - HCRockMovementDeltaOffset;
		movementDelta.y = value;
	}
	else{
			// rock is under the explosion
		value = HCExplosionCenterDistance + HCRockExplosionOffset - (currentPosition.y - aPoint.y);
		value = value / HCRockMovementDeltaFraction + HCRockMovementDeltaOffset;
		movementDelta.y = value;
	}
	
}



@end
