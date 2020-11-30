//
//  EyeSprite.m
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "EyeSprite.h"
#import "Globals.h"
#import "SpriteResourceHandler.h"


@implementation EyeSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = true;
	boundingBoxSpriteOffset = 1;
}


- (int) getNextAnimationFrameNumber{
	
		// eye looks in the direction of the player sprite if player is near enough.
	CGPoint jumpyPosition = [[spriteResourceHandler jumpySprite] currentPosition];
	CGRect neutralRectangle = 	CGRectMake(jumpyPosition.x - HCEyeRectSize, jumpyPosition.y - HCEyeRectSize, 2*HCEyeRectSize+HCTileInnerSize, 2*HCEyeRectSize+HCTileInnerSize );
	if([self checkCollisionWithBoundingBox: neutralRectangle]) return 8;
	
	if(currentPosition.y > jumpyPosition.y){
			// jumpy is higher
			
		if(currentPosition.x > jumpyPosition.x){
				// jumpy is left
			
				// jumpy is almost on same right/left position
			if(currentPosition.x - jumpyPosition.x < HCEyeRectSize) return 1;
				// jumpx is almost on same height
			if(currentPosition.y - jumpyPosition.y < HCEyeRectSize) return 7;
				// left, upper corner
			return 0;
			
		}
		else{
				// jumpy is right
			
				// jumpx is almost on same height
			if(currentPosition.y - jumpyPosition.y < HCEyeRectSize) return 3;
				// right, upper corner
			else return 2;
		}
	}
	else{
			// jumpy is lower
		if(currentPosition.x > jumpyPosition.x){
				// jumpy is left
			
				// jumpy is almost on same right/left position
			if(currentPosition.x - jumpyPosition.x < HCEyeRectSize) return 5;
				// jumpx is almost on same height
			if(currentPosition.y - jumpyPosition.y < HCEyeRectSize) return 6;
				// left, lower corner
			return 7;
			
		}
		else{
				// jumpy is right
			
				// jumpx is almost on same height
			if(jumpyPosition.y - currentPosition.y < HCEyeRectSize) return 3;
				// right, lower corner
			else return 4;
		}
	}

	
	return 0;
}


- (void) moveSprite{
	
	if(movementDelta.x <0){
		if([self hasCollidedWithBackGroundAtPoint: CGPointMake(currentPosition.x - HCEyeMove, currentPosition.y)])
			movementDelta = CGPointMake(HCEyeMove,0);
		
	}
	if(movementDelta.x >0){
		if([self hasCollidedWithBackGroundAtPoint: CGPointMake(currentPosition.x+HCTileInnerSize + HCEyeMove, currentPosition.y)])
			movementDelta = CGPointMake(-HCEyeMove,0);
		
	}
	
	[super moveSprite];
}


- (void) changeDirectionAfterCollision{
	
		// sprite has collided somewhere set sprite back to old position
	currentPosition = lastPosition;
	[self changeDirection];
}



- (void) changeDirection{
	
	if(movementDelta.x <0){
		movementDelta = CGPointMake(HCEyeMove,0);
		
	}
	if(movementDelta.x >0){
		movementDelta = CGPointMake(-HCEyeMove,0);
		
	}
}


@end
