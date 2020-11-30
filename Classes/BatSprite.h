//
//  BatSprite.h
//  Jumpy
//
//  Created by Sven Putze on 21.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"

enum batDirections{
	BATSEQ01,
	BATSEQ02,
	BATSEQ03,
	BATSEQ04,
	BATSEQ05,
	BATSEQ06,
	BATSEQ07,
	BATDIRCOUNT
};

	// this value is added as a constant to directionFrameCount
#define HCBatDirectionFrameOffset 30
	// this is the random range for directionFrameCount
#define HCBatDirectionFrameModulo 60
	// number of frames before the next element of the animationpath is read
#define HCBatAnimationPathOffset 5
	// number of frames the direction is kept after collision
#define HCBatDirectionFrameCountAfterCollision 4
	// fix number of frames the direction is kept after collision (added to HCBatDirectionFrameCountAfterCollision)
#define HCBatDirectionFrameCountAfterCollisionOffset 1
#define HCBatBoundingBoxSpriteOffset -1
#define HCBatBoundingBoxBackgroundOffset -2


@interface BatSprite : Sprite {
    
		// direction of the bat sprite
	int currentDirection;
		// number of frames the direction will be kept
	int directionFrameCount;
		// points to the next angle in the animationpath array
	int animationPathIndex;
		// stores the current angle resulting from the animationpath
	int animationPathAngle;
		// points to the currently used animationpath
	int *currentAnimationPath;
		// number of frames before the next animationpath elemet is read
	int animationPathFrameOffset;
		// offset that is added to the angle each frame
	int animationPathAngleOffset;
	
	int scalarX;
	
	int scalarY;
	
}

//
//	// Selector is called to check if a collision has occured. If so then the sprite is
//	// moved away depending on the point of collision.
//- (void) changeDirectionOnCollision;

@end
