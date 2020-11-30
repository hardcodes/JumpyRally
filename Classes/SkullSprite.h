//
//  SkullSprite.h
//  Jumpy
//
//  Created by Sven Putze on 21.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"
#import "Globals.h"

	// rotationrange for skull
#define HCSkullMinAngle -32
#define HCSkullMaxAngle 32
#if TARGET_IPHONE_SIMULATOR
	#define HCSkullAngleDelta 2
#else
	#define HCSkullAngleDelta 3
#endif


	// Skull is moved this fast
#define HCSkullMove 2
#define HCSkullBoundingBoxSpriteOffset 2


enum rotationDirections{
	ROTATELEFT,
	ROTATERIGHT
};


@interface SkullSprite : Sprite {
	
	int rotationDirection;
}


@end
