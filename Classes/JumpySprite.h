//
//  JumpySprite.h
//  Jumpy
//
//  Created by Sven Putze on 14.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"


	// when jumping up from bottom this is the start value
#define HCJumpStartValue 14
	// if the peak is reached while jumping up this is the next jumpOffset
#define HCJumpPeakValue 3
	// if the y coordinate is changed jumpOffset/HCJumpUpFactor is subtracted
#define HCJumpUpFactor 3
	// if the y coordinate is changed jumpOffset/HCJumpDownFactor is added
#define HCJumpDownFactor 1.1
	// max. pixelcount that is added in one frame
#define HCMaxJumpDownOffset 14
	// y coordinate is updated every HCFrameOffset' frame
#define HCFrameOffset 2
	// moving left/right is altered by this value
#define HCXDelta 4.0
#define HCXCollisionControlOffset 2


@interface JumpySprite : Sprite {
		// binary representation of current direction
		// bit 1 = left
		// bit 2 = right
		// bit 1&2 = hold on floor
	int currentDirection;
		// this value is added to the y ccordinate of the every HCFrameOffset' frame.
	int jumpOffset;
		// this value is added to the y ccordinate of the jumpy/player.
	int currentJumpoffset;
		// Y coordinate is updated every frameOffset frame.
	int frameOffset;
	
		// these bool values are used for collsion control:
		// the complete surface of the sprite is checked using the bitmask stored in jumpyBitmask[].
		// depending on the area where a collision happended, one of the following values is set to YES
		// otherwise to NO.
	BOOL collisionTop;
	BOOL collisionBottom;
	BOOL collisionLeft;
	BOOL collisionRight;
}

@property (nonatomic, readwrite) int currentDirection;


	// Selector checks if the jumpy sprite has collided with a background tile on any pixel
	// on the given bitmask array.
- (bool) checkCollisionWithBackgroundForBitmaskArray: (unsigned short int*) aBitmaskArray;



@end
