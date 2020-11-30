//
//  BatSprite.m
//  Jumpy
//
//  Created by Sven Putze on 21.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "BatSprite.h"

static int animationPath01[41]={40,5,5,5,5,5,5,5,5,5,5,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1};
static int animationPath02[21]={20,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5};
static int animationPath03[13]={12,-10,-10,-10,0,0,0,-5,-5,-5,0,0,0};
static int animationPath04[13]={12,10,10,10,0,0,0,5,5,5,0,0,0};
static int animationPath05[9]={8,0,0,0,0,8,8,8,8};
static int animationPath06[2]={1,20};
static int animationPath07[2]={1,-20};
	// this path is used after collison = straight movement in opposite direction.
static int animationPath99[2]={1,0};


@implementation BatSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = true;
	boundingBoxSpriteOffset = HCBatBoundingBoxSpriteOffset;
	boundingBoxBackgroundOffset = HCBatBoundingBoxBackgroundOffset;
	
	scalarX = movementDelta.x;
	scalarY = movementDelta.y;
	
	animationPathAngle = 0;
	currentDirection = 0;
	
	animationSequenceIndex = (arc4random() % animationSequence[0]-1) +1;
	
	[self changeDirection];
}



- (void) moveSprite{
	
	if (isActive){

			// check if collision has occured
			// yes = direction will be changed
			// no = keep direction
		if([self boundingBoxHasCollidedWithBackground]){
				// collision with backgropund, set sprite back to old position
				// and choose a new direction
			[self changeDirectionAfterCollision];
		}
		
			// keep direction for directionFrameCount frames
		--directionFrameCount;
		if(directionFrameCount <=0) [self changeDirection];
		else{
			
				// next array element is fetched every HCBatAnimationPathOffset' frame
			++animationPathFrameOffset;
			if(animationPathFrameOffset > HCBatAnimationPathOffset){
				
				animationPathFrameOffset = 0;
				
					// fetch next array element
				animationPathAngleOffset = currentAnimationPath[animationPathIndex];
				
					// step on to next element
				++animationPathIndex;
				if(animationPathIndex > currentAnimationPath[0]) animationPathIndex = 1;
				
				
				
			}
		}
		
		animationPathAngle += animationPathAngleOffset;
		if (animationPathAngle > 360) animationPathAngle = animationPathAngle - 360;
		if (animationPathAngle < 0) animationPathAngle = 360 + animationPathAngle;
		
		movementDelta.x = sin([self getRadForAngle: animationPathAngle]) * scalarX;
		movementDelta.y = -cos([self getRadForAngle: animationPathAngle]) * scalarY;
		
		[super moveSprite];
		
	}
}


- (void) changeDirectionAfterCollision{
	
		// sprite has collided somewhere set sprite back to old position
	currentPosition = lastPosition;
	currentAnimationPath = animationPath99;
	animationPathFrameOffset = 0;
	animationPathIndex = 1;	
	animationPathAngleOffset = currentAnimationPath[animationPathIndex];
	directionFrameCount = (arc4random() % HCBatDirectionFrameCountAfterCollision) + HCBatDirectionFrameCountAfterCollisionOffset;
	animationPathAngle = (arc4random() % 360);

}



- (void) changeDirection{
	
		// randomly choose a new direction
	int oldDirection = currentDirection;
	while(oldDirection == currentDirection){
		currentDirection = (arc4random() % BATDIRCOUNT);		
	}

		// number of frames the new direction will be kept before a new one will be chosen
	directionFrameCount = (arc4random() % HCBatDirectionFrameModulo) + HCBatDirectionFrameOffset;
	
	
	switch(currentDirection){
			
		case BATSEQ01:
			
			currentAnimationPath = animationPath01;
			
			
			break;
			
		case BATSEQ02:
			
			currentAnimationPath = animationPath02;
			
			break;
			
		case BATSEQ03:
			
			currentAnimationPath = animationPath03;
			
			break;
			
		case BATSEQ04:
			
			currentAnimationPath = animationPath04;
			
			break;
			
		case BATSEQ05:
			
			currentAnimationPath = animationPath05;
			
			break;
			
			
		case BATSEQ06:
			
			currentAnimationPath = animationPath06;
			
			break;
			
			
		case BATSEQ07:
			
			currentAnimationPath = animationPath07;
			
			break;
			
		default:
			
				// should never happen
			currentAnimationPath = animationPath01;
			break;
			
	}
	
	
	animationPathFrameOffset = 0;
	animationPathIndex = 1;	
	animationPathAngleOffset = currentAnimationPath[animationPathIndex];
	
}


@end
