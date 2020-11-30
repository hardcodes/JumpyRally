//
//  StandardDieSprite.h
//  Jumpy
//
//  Created by Sven Putze on 15.05.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"

	// number of frames that the standard die sequence is displayed
#define HCStandardDieSequenceFrameCount 20
	// rotataion of sprite
#define HCStandardDieAngle 2

@interface StandardDieSprite : Sprite {
    
	int remainingFrames;
	
}

@end
