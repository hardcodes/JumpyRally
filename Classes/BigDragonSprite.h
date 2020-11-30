//
//  BigDragonSprite.h
//  Jumpy
//
//  Created by Putze Sven on 01.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"

#define HCBigDragonSpeed 3
#define HCDragonBodyPart1Offset 8
#define HCDragonBodyPart2Offset 8
#define HCDragonBodyPart3Offset 8
#define HCDragonBodyTailOffset 11
#define HCDragonYAngleOffset 5
#define HCDragonScalarY 3
#define HCDragonBoundingBoxBackgroundOffset -3
#define HCDragonTopCollisionOffset 3
#define HCDragonBottomCollisionOffset 3
#define HCDragonUpDownOffset 1

enum bigDragonDirections{
	BIGDRAGONLEFT,
	BIGDRAGONRIGHT,
	BIGDRAGONDIRCOUNT
};

@interface BigDragonSprite : Sprite {

		// stores the main direction (left, right) of the dragon
	int currentDirection;
		// stores the last positions of the dragon head
	CGPoint positionHistory[64];
		// points to the current position in positionHistory
	int positionHistoryCounter;
	int positionHistoryBodyPart1Counter;
	int positionHistoryBodyPart2Counter;
	int positionHistoryBodyPart3Counter;
	int positionHistoryBodyTailCounter;
		// this way the size of the array must only be calculated once
	int positionHistoryArraySize;
	
		// offset that is added to the angle each frame
	int animationPathAngleOffset;
		// stores the current angle resulting from the animationpath
	int animationPathAngle;
		// value is added to currentPosition.y every frame (constant up/down movement)
	int upDownOffset;
		// is added to the rotation angle
	int rotationAngleOffset;
		// scalar used for the cosinus movement
	int scalarY;
		// headframe is rotated this angle
	int headAngle;

}


	// sets all array members to the same CGPoint
- (void) initPositionHistoryArray: (CGPoint) aDefaultPosition;

@end
