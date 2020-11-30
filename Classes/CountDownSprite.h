//
//  CountDownSprite.h
//  Jumpy
//
//  Created by Putze Sven on 30.09.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"

	// this is the maximum width of a zoomed sprite
#define HCCountDownMaxZoomWidth 172
	// wait this count of frames before the next zoom level applied
#define HCCountDownZoomFrameCount 1
	// number of pixels added to the current framewidth/height
#define HCCountDownZoomRate 2

	// implements the super class for the countdown at the beginning of each level.
	// Thus we don't need to implement the selectors several times.
@interface CountDownSprite : Sprite{
	
	int currentZoomWidth;
	int currentZoomHeight;
	int zoomFrameCount;
}

@end
