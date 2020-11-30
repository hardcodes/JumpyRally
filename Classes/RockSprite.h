//
//  RockSprite.h
//  Jumpy
//
//  Created by Sven Putze on 22.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"


	// throttles the speed of a "thrown" rock
#define HCRockMovementDeltaFraction 3
	// this values is added to the flying speed
#define HCRockMovementDeltaOffset 2
	// define number of pixels a rock can fall without breaking apart
#define HCRockMaxFallPixels 60
	// flying rocks are rotated by this angle
#define HCRockAngle 4
#define HCRockBoundingBoxSpriteOffset 2


@interface RockSprite : Sprite {
	
}


	// Selector is called when this sprite is hit by an explosion with aPoint marking the center of
	// the explosion
	// depending on the distance and angle the flightpath AKA movementDelta is calculated.
- (void) setFlightPathRelativeToPoint: (CGPoint) aPoint;


@end
