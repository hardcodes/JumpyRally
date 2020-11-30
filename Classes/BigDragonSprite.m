//
//  BigDragonSprite.m
//  Jumpy
//
//  Created by Putze Sven on 01.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import "BigDragonSprite.h"

@implementation BigDragonSprite

#pragma mark - init

- (void) additionalSetup{
	canCollide = true;
	isLethal = true;
	boundingBoxSpriteOffset = 0;
	boundingBoxBackgroundOffset = HCDragonBoundingBoxBackgroundOffset;
	currentDirection = -1;
	animationSequenceIndex = 0;
	positionHistoryArraySize = (sizeof(positionHistory) / sizeof(CGPoint) -1);
	[self initPositionHistoryArray: currentPosition];
	
	scalarY = HCDragonScalarY;	
	animationPathAngle = 0;
	headAngle = 0;
	animationPathAngleOffset = HCDragonYAngleOffset;
	rotationAngleOffset = -90;
	[self changeDirection];
}


- (void) initPositionHistoryArray: (CGPoint) aDefaultPosition{
		// run through all members of array
	for (int counter = 0; counter <= positionHistoryArraySize; counter++){
		positionHistory[counter] = aDefaultPosition;
	}
	
	positionHistoryCounter = 0;
	positionHistoryBodyPart1Counter = positionHistoryArraySize - HCDragonBodyPart1Offset;
	positionHistoryBodyPart2Counter = positionHistoryBodyPart1Counter - HCDragonBodyPart2Offset;
	positionHistoryBodyPart3Counter = positionHistoryBodyPart2Counter - HCDragonBodyPart3Offset;
	positionHistoryBodyTailCounter = positionHistoryBodyPart3Counter - HCDragonBodyTailOffset;
}




#pragma mark - movmement

- (void) drawNextAnimationFrame {
	
		//NSLog(@"drawFrame");
	if (isActive) {
		
		if (doNotAnimate && movementDelta.x == 0 && movementDelta.y == 0) {
			frameNumber = 0;
		}
		else{
			frameNumber = [self getNextAnimationFrameNumber];
			
		}
		
			// render tail
		[spriteTexture drawFrame: frameNumber+2
					  frameWidth: frameWidth
		 rotatedByAngleInDegrees: rotationAngle
					  atPosition: positionHistory[positionHistoryBodyTailCounter]];
		
			// render bodyparts
		[spriteTexture drawFrame: frameNumber+1
					  frameWidth: frameWidth
		 rotatedByAngleInDegrees: rotationAngle
					  atPosition: positionHistory[positionHistoryBodyPart3Counter]];
		
		[spriteTexture drawFrame: frameNumber+1
					  frameWidth: frameWidth
		 rotatedByAngleInDegrees: rotationAngle
					  atPosition: positionHistory[positionHistoryBodyPart2Counter]];
		
		[spriteTexture drawFrame: frameNumber+1
					  frameWidth: frameWidth
		 rotatedByAngleInDegrees: rotationAngle
					  atPosition: positionHistory[positionHistoryBodyPart1Counter]];
		
			// render head
		[spriteTexture drawFrame: frameNumber
					  frameWidth: frameWidth
		 rotatedByAngleInDegrees: 0
					  atPosition: CGPointMake(currentPosition.x, currentPosition.y)];
	}
}


- (int) getNextAnimationFrameNumber{
	
	return animationSequenceIndex + animationSequenceIndexOffset;
}


- (void) moveSprite{
	
	if(isActive){		
		
		animationPathAngle += animationPathAngleOffset;
		if (animationPathAngle > 360) animationPathAngle = animationPathAngle - 360;
		if (animationPathAngle < 0) animationPathAngle = 360 + animationPathAngle;
		
		movementDelta.y = -cos([self getRadForAngle: animationPathAngle]) * scalarY;
		currentPosition.y += upDownOffset;
		
		int oldAnimationPathAngle = animationPathAngle;
		
		[super moveSprite];

			// collision control

		
		switch (currentDirection) {
			case BIGDRAGONLEFT:
				
				
				if(animationPathAngle < 180) headAngle = animationPathAngle;
				else headAngle = 180 - (animationPathAngle % 180);
				headAngle +=  rotationAngleOffset;
				
				if([self boundingBoxHasCollidedWithBackgroundOnDirection: LEFT]){
					currentPosition = lastPosition;
					currentDirection = BIGDRAGONRIGHT;
					animationSequenceIndexOffset = 4;
					movementDelta.x = HCBigDragonSpeed;
					animationPathAngleOffset = -animationPathAngleOffset;
					animationPathAngle = oldAnimationPathAngle;

					
					
				}
				break;
				
			case BIGDRAGONRIGHT:
				if([self boundingBoxHasCollidedWithBackgroundOnDirection: RIGHT]){
					currentPosition = lastPosition;
					currentDirection = BIGDRAGONLEFT;
					animationSequenceIndexOffset = 0;
					movementDelta.x = -HCBigDragonSpeed;
					animationPathAngleOffset = -animationPathAngleOffset;
					animationPathAngle = oldAnimationPathAngle;
					
				}
				break;
				
			default:
				break;
		}
		
		if([self boundingBoxHasCollidedWithBackgroundOnDirection: TOP]){
			currentPosition = lastPosition;
			currentPosition.y += HCDragonTopCollisionOffset;
			animationPathAngleOffset = -animationPathAngleOffset;
			animationPathAngle = 180;
			upDownOffset = HCDragonUpDownOffset;
			
		}
		
		if([self boundingBoxHasCollidedWithBackgroundOnDirection: BOTTOM]){
			currentPosition = lastPosition;
			currentPosition.y -= HCDragonBottomCollisionOffset;
			animationPathAngleOffset = -animationPathAngleOffset;
			animationPathAngle = 0;
			upDownOffset = -HCDragonUpDownOffset;
			
		}

			// remember current position in array after the position was checked for collision
			// (and may be corrected)
		positionHistory[positionHistoryCounter] = currentPosition;
		if(positionHistoryCounter < positionHistoryArraySize) positionHistoryCounter++;
		else positionHistoryCounter = 0;
			// move the counter/pointer for the other bodyparts
		if(positionHistoryBodyPart1Counter < positionHistoryArraySize) positionHistoryBodyPart1Counter++;
		else positionHistoryBodyPart1Counter = 0;
		if(positionHistoryBodyPart2Counter < positionHistoryArraySize) positionHistoryBodyPart2Counter++;
		else positionHistoryBodyPart2Counter = 0;
		if(positionHistoryBodyPart3Counter < positionHistoryArraySize) positionHistoryBodyPart3Counter++;
		else positionHistoryBodyPart3Counter = 0;
		if(positionHistoryBodyTailCounter < positionHistoryArraySize) positionHistoryBodyTailCounter++;
		else positionHistoryBodyTailCounter = 0;
			
	}
	
}



#pragma mark - collision control

- (void) changeDirectionAfterCollision{
	
	currentPosition = lastPosition;
	[self changeDirection];
	
}


- (void) changeDirection{
	
		// randomly choose a new direction
	int oldDirection = currentDirection;
	while(oldDirection == currentDirection){
		currentDirection = (arc4random() % BIGDRAGONDIRCOUNT);		
	}
	
	switch (currentDirection) {
		case BIGDRAGONLEFT:
			animationSequenceIndexOffset = 0;
			movementDelta.x = -HCBigDragonSpeed;
			upDownOffset = HCDragonUpDownOffset;
			break;
			
		case BIGDRAGONRIGHT:
			animationSequenceIndexOffset = 4;
			movementDelta.x = HCBigDragonSpeed;
			upDownOffset = -HCDragonUpDownOffset;
			break;
			
		default:
			break;
	}
	
	animationPathAngleOffset = -animationPathAngleOffset;

}


@end
