	//
	//  JumpySprite.m
	//  Jumpy
	//
	//  Created by Sven Putze on 14.04.11.
	//  Copyright 2011 hardcodes.de. All rights reserved.
	//

#import "JumpySprite.h"
#import "GameStateEngine.h"
#import "GameStatus.h"

	// these bitmasks are used for collision control: if a bit is set it it's position must be checked in collision contr
static unsigned short int jumpyTopBitmask[16]={
	0b0011111111111100,
	0b0111111111111110,
	0b0111111111111110,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000
};

static unsigned short int jumpyBottomBitmask[16]={
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0111111111111110,
	0b0111111111111110,
	0b0011111111111100
};

static unsigned short int jumpyLeftBitmask[16]={
	0b0000011100000000,
	0b0110000000000000,
	0b1110000000000000,
	0b1110000000000000,
	0b1110000000000000,
	0b1110000000000000,
	0b1110000000000000,
	0b1110000000000000,
	0b1110000000000000,
	0b1110000000000000,
	0b1110000000000000,
	0b1110000000000000,
	0b1110000000000000,
	0b0110000000000000,
	0b0110000000000000,
	0b0000000000000000
};

static unsigned short int jumpyRightBitmask[16]={
	0b0000000000000000,
	0b0000000000001110,
	0b0000000000001110,
	0b0000000000001111,
	0b0000000000001111,
	0b0000000000001111,
	0b0000000000001111,
	0b0000000000001111,
	0b0000000000001111,
	0b0000000000001111,
	0b0000000000001111,
	0b0000000000001111,
	0b0000000000001111,
	0b0000000000001110,
	0b0000000000001110,
	0b0000000000000000
};


@implementation JumpySprite


@synthesize currentDirection;


- (void) additionalSetup{
	
	canCollide = true;
	isLethal = false;
	boundingBoxSpriteOffset = 0;
	
	jumpOffset = -HCJumpStartValue;
	frameOffset = HCFrameOffset;
	
}

- (void)moveSprite{
	
		// only active sprites can move
	if (isActive) {
			// remember last position for collision
		lastPosition = currentPosition;

#pragma mark - left/right
		
		
		
		switch (currentDirection) {
				
					// binary representation of current direction
					// bit 1 = left
					// bit 2 = right
					// bit 1&2 = hold on floor (not yet implemented)
			case 1:
					// change the coordinates = move sprite
				currentPosition.x -= HCXDelta;
					// collision control
				if([self checkCollisionWithBackgroundForBitmaskArray: jumpyLeftBitmask]){
					int xDelta = ((int)lastPosition.x) % HCTileInnerSize;
					currentPosition.x = ((int)lastPosition.x) -xDelta;
				}
				animationSequenceIndexOffset = 0;
				
				break;
				
			case 2:
					// change the coordinates = move sprite
				currentPosition.x += HCXDelta;
					// collision control
				if([self checkCollisionWithBackgroundForBitmaskArray: jumpyRightBitmask]){
					int xDelta = ((int)lastPosition.x) % HCTileInnerSize;
					currentPosition.x = ((int)lastPosition.x) -xDelta;
				}
				animationSequenceIndexOffset = 16;
				
				break;
				
			case 3:
					// TODO
				animationSequenceIndexOffset = 8;
				break;
				
			default:
				movementDelta.x=0;
				animationSequenceIndexOffset = 8;
					// collision control
					// even if we don't move left/right. Jumpysprite may fall down or jump up
					// half in background
				if([self checkCollisionWithBackgroundForBitmaskArray: jumpyLeftBitmask]){
					currentPosition.x += 1;
				}
				if([self checkCollisionWithBackgroundForBitmaskArray: jumpyRightBitmask]){
					currentPosition.x -= 1;
				}
				break;
		}
		
#pragma mark - up/down
		
		
			// Y coordinate offset is updated if frameOffset is equal 0
		if(frameOffset==0){
			
			frameOffset = HCFrameOffset;
			
				// remember old value to check if we have reached the peak.
			int oldOffset = jumpOffset;
			
			if(jumpOffset < 0){
					// jump up
				jumpOffset -= jumpOffset / HCJumpUpFactor;
			}
			if(jumpOffset > 0){
					// jump down
				jumpOffset += jumpOffset * HCJumpDownFactor;
			}
			if(jumpOffset == 0){
				jumpOffset = HCJumpPeakValue;
				frameOffset = 0;
			}
				// peak? (no more change)
			if(oldOffset == jumpOffset) jumpOffset = 0;
			
		}
		else frameOffset -=1;
		
		currentJumpoffset = jumpOffset / HCFrameOffset;
		if (currentJumpoffset > HCMaxJumpDownOffset) currentJumpoffset = HCMaxJumpDownOffset;
		
			// change the y-coordinates = move sprite
		currentPosition.y+=currentJumpoffset;
		
			// TODO orientation change
		
		if(jumpOffset > 0){
			// jump down
			if([self checkCollisionWithBackgroundForBitmaskArray: jumpyBottomBitmask]){
				
				currentPosition.y = [self getExcactYCoordinateOfBottom];
				
				jumpOffset = -HCJumpStartValue;
				frameOffset = HCFrameOffset;
				[[spriteResourceHandler soundEngine] playSoundOfType: JUMPYBOUNCESOUND at2DPosition: currentPosition];
			}
		}

		if(jumpOffset < 0){
				// jump up
			if([self checkCollisionWithBackgroundForBitmaskArray: jumpyTopBitmask]){
				
				currentPosition.y = [self getExcactYCoordinateOfTop];
				
				jumpOffset = HCJumpPeakValue;
				frameOffset = HCFrameOffset;
			}
		}
		
			// safetynet - whatever happens, sprites should stay in the playfield
		if(currentPosition.x < HCminX) currentPosition.x=HCminX;
		if(currentPosition.x > HCmaxX) currentPosition.x=HCmaxX;
		if(currentPosition.y < HCminY){
			currentPosition.y=HCminY;
			jumpOffset = 0;
			frameOffset = 0;
		}
		if(currentPosition.y > HCmaxY){
			currentPosition.y=HCmaxY;
			jumpOffset = -HCJumpStartValue;
			frameOffset = 0;
		}
		
	}
	
}


#pragma mark - collision control


	// override of superclass
- (bool) hasCollidedWithBackGroundAtPoint: (CGPoint) aPoint{
		// We override this selector to check collisions with the sprite layer and reactions upon it
	
		// Values are needed two times so storing is faster
	int xCoordinate = [self getTileXCoordinateForPoint:aPoint];
	int yCoordinate = [self getTileYCoordinateForPoint:aPoint];
	
	int tileGid = [[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"maze"] getTileGIdAtXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
		// Collision with the background
	if(tileGid != 0) return true;
	
	tileGid = [[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] getTileGIdAtXCoordinate: xCoordinate AndYCoordinate: yCoordinate] - HCFirstSpriteGID + 1;
		// Collision with a door (6,7,8)
		// if we don't have a key a door is like background
	if(tileGid == 6 && ! [[gameStateEngine gameStatus] gotBlueKey]) return true;
	if(tileGid == 7 && ! [[gameStateEngine gameStatus]  gotGoldKey]) return true;
	if(tileGid == 8 && ! [[gameStateEngine gameStatus]  gotRedKey]) return true;
	if(tileGid == 9) return true;
	if(tileGid == 11) return true;
	
		//Default: no collision
	return false;
}



- (bool) checkCollisionWithBackgroundForBitmaskArray: (unsigned short int*) aBitmaskArray{
	
	bool hasCollided = false;
	
		// run from top side to bottom
	for (int yCounter=0;yCounter<16;yCounter++){
		
			// get the bits to compare with
		unsigned short int rowBitmask = aBitmaskArray[yCounter];
		unsigned short int bitmaskToCheck = 1;
		
			// run from right to left (from binary view)
		for(int xCounter=0;xCounter<16;xCounter++){
			
			if(bitmaskToCheck & rowBitmask){
					// this position must be checked
					// addf the relative coordinates to the left upper corner of the sprite
					// yCounter is the relative y position (from top to bottom)
					// xCounter is the relative x position (from right to left)
				if([self hasCollidedWithBackGroundAtPoint: CGPointMake(currentPosition.x + 15 - xCounter, currentPosition.y + yCounter)]){
						// OK, jumpysprite has collided with background somewhere.
					hasCollided = true;
					break;
				}
			}

			if(hasCollided) break;
			bitmaskToCheck <<=1;
			
		}
		
	}
	
	return hasCollided;
}



- (int) getExcactYCoordinateOfTop{
	
	int yDelta;
	yDelta = ((int)lastPosition.y) % HCTileInnerSize;
	return ((int)lastPosition.y) - yDelta;
	
		//		// check directly above the sprite
		//	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+2, lastPosition.y-HCTileSize)]){
		//		yDelta = ((int)lastPosition.y) % HCTileSize;
		//		return ((int)lastPosition.y) - yDelta;
		//	}
		//	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+14, lastPosition.y-HCTileSize)]){
		//		yDelta = ((int)lastPosition.y) % HCTileSize;
		//		return ((int)lastPosition.y) - yDelta;
		//	}
		//	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+8, lastPosition.y-HCTileSize)]){
		//		yDelta = ((int)lastPosition.y) % HCTileSize;
		//		return ((int)lastPosition.y) - yDelta;
		//	}
		//	
		//	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+4, lastPosition.y-HCTileSize)]){
		//		yDelta = ((int)lastPosition.y) % HCTileSize;
		//		return ((int)lastPosition.y) - yDelta;
		//	}
		//	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+12, lastPosition.y-HCTileSize)]){
		//		yDelta = ((int)lastPosition.y) % HCTileSize;
		//		return ((int)lastPosition.y) - yDelta;
		//	}
		//	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+6, lastPosition.y-HCTileSize)]){
		//		yDelta = ((int)lastPosition.y) % HCTileSize;
		//		return ((int)lastPosition.y) - yDelta;
		//	}
		//	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+10, lastPosition.y-HCTileSize)]){
		//		yDelta = ((int)lastPosition.y) % HCTileSize;
		//		return ((int)lastPosition.y) - yDelta;
		//	}
		//	
		//	return (int)lastPosition.y;
}



@end
