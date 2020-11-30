//
//  SkullSprite.m
//  Jumpy
//
//  Created by Sven Putze on 21.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "SkullSprite.h"


@implementation SkullSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = true;
	boundingBoxSpriteOffset = HCSkullBoundingBoxSpriteOffset;
	rotationDirection = ROTATERIGHT;
	rotationAngle = (arc4random() % HCSkullMaxAngle) +1;
}

- (int) getNextAnimationFrameNumber{

		// rotate the skull
		if(rotationDirection==ROTATELEFT && rotationAngle > HCSkullMinAngle) rotationAngle-=HCSkullAngleDelta;
		if(rotationDirection==ROTATELEFT && rotationAngle <= HCSkullMinAngle) rotationDirection=ROTATERIGHT;
		
		if(rotationDirection==ROTATERIGHT && rotationAngle < HCSkullMaxAngle) rotationAngle+=HCSkullAngleDelta;
		if(rotationDirection==ROTATERIGHT && rotationAngle >= HCSkullMaxAngle) rotationDirection=ROTATELEFT;
	
	return [super getNextAnimationFrameNumber];
}


- (void) moveSprite{
	
	if(movementDelta.y <0){
		if([self hasCollidedWithBackGroundAtPoint: CGPointMake(currentPosition.x+8, currentPosition.y - HCSkullMove)])
			movementDelta = CGPointMake(0,HCSkullMove);

	}
	if(movementDelta.y >0){
		if([self hasCollidedWithBackGroundAtPoint: CGPointMake(currentPosition.x+8, currentPosition.y+HCTileInnerSize + HCSkullMove)])
			movementDelta = CGPointMake(0, - HCSkullMove);
		
	}
	
	[super moveSprite];
}



- (void) changeDirectionAfterCollision{
	
		// sprite has collided somewhere set sprite back to old position
	currentPosition = lastPosition;
	[self changeDirection];
}



- (void) changeDirection{
	
	if(movementDelta.y <0){
		movementDelta = CGPointMake(0,HCSkullMove);
		
	}
	if(movementDelta.y >0){
		movementDelta = CGPointMake(0, - HCSkullMove);		
	}
}


@end
