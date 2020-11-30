	//
	//  BeeSprite.m
	//  Jumpy
	//
	//  Created by Sven Putze on 21.04.11.
	//  Copyright 2011 hardcodes.de. All rights reserved.
	//

#import "BeeSprite.h"
#import "SpriteResourceHandler.h"


@implementation BeeSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = true;
	moveType = MOVE;
	boundingBoxBackgroundOffset = -1;
	currentDirection=BEERIGHT;
	
	[self changeDirection];
	
}



- (void) moveSprite{
	
	if (isActive){
		
			// look left or right
		CGPoint jumpyPosition = [[spriteResourceHandler jumpySprite] currentPosition];
		if(jumpyPosition.x > currentPosition.x) animationSequenceIndexOffset = 2;
		else animationSequenceIndexOffset = 0;
		
			// change sprite coordinates
		[super moveSprite];
		
			// collision control
		if([self boundingBoxHasCollidedWithBackground]){
				// collision with backgropund, set sprite back to old position
				// and choose a new direction
			[self changeDirectionAfterCollision];
		}
		else{
				// keep on same direction for directionFrameCount frames;
			--directionFrameCount;
			if(directionFrameCount <=0) [self changeDirection];
			
		}
		
	}
	
}


- (void) changeDirectionAfterCollision{
	
		// sprite has collided somewhere set sprite back to old position
	currentPosition = lastPosition;
	[self changeDirection];
}



- (void) changeDirection{
	
		// randomly choose a new (and different) direction
	int oldDirection = currentDirection;
	while(oldDirection == currentDirection){
		currentDirection = (arc4random() % BEEDIRCOUNT);		
	}
		// number of frames the new direction will be kept before a new one will be chosen
	directionFrameCount = (arc4random() % HCBeeDirectionFrameModulo) + HCBeeDirectionFrameOffset;
		// stop any beesound before changing the direction
	[[spriteResourceHandler soundEngine] stopSoundOfType: BEEATTACKSOUND];
	
	switch(currentDirection){
			
		case BEEUP:
			
			movementDelta = CGPointMake(0, -2);
			
			break;
			
			
		case BEEDOWN:
			
			movementDelta = CGPointMake(0, 2);			
			
			break;
			
		case BEELEFT:
			
			movementDelta = CGPointMake(-2, 0);			
			
			break;
			
		case BEERIGHT:
			
			movementDelta = CGPointMake(2, 0);			
			
			break;
			
			
		case BEEATTACKRIGHT:
			
			movementDelta.x = 3;
			movementDelta.y = 4;
			[[spriteResourceHandler soundEngine] playSoundOfType: BEEATTACKSOUND at2DPosition: currentPosition];
			
			break;
			
		case BEEATTACKLEFT:
			
			movementDelta.x = -3;
			movementDelta.y = 4;
			
			[[spriteResourceHandler soundEngine] playSoundOfType: BEEATTACKSOUND at2DPosition: currentPosition];
			
			break;
			
			
		case BEEWAIT:
			movementDelta = CGPointMake(0, 0);
			
			break;
			
			
		default:
				// should never happen - this value causes immdiate direction change
			directionFrameCount = 0;
			break;
	}
	
}


@end
