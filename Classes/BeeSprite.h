//
//  BeeSprite.h
//  Jumpy
//
//  Created by Sven Putze on 21.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"

enum beeDirections{
	BEEUP,
	BEEDOWN,
	BEELEFT,
	BEERIGHT,
	BEEWAIT,
	BEEATTACKLEFT,
	BEEATTACKRIGHT,
	BEEDIRCOUNT
};

	// this value is added as a constant to directionFrameCount
#define HCBeeDirectionFrameOffset 10
	// this is the random range for directionFrameCount
#define HCBeeDirectionFrameModulo 50


@interface BeeSprite : Sprite {
    
		// direction of the bee sprite
	int currentDirection;
		// number of frames the direction will be kept
	int directionFrameCount;
	
}

@end
