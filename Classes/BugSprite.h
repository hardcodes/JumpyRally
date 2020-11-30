//
//  BugSprite.h
//  Jumpy
//
//  Created by Sven Putze on 21.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"

	// Bug is moving this fast
#define HCBugMove 3

enum bugDirections{
	BUGUP,
	BUGRIGHT,
	BUGDOWN,
	BUGLEFT,
	BUGUNKNOWN,
	BUGDIRCOUNT
};


@interface BugSprite : Sprite {
    
		// -1 = undefined
		//  0 = up
		//  1 = right
		//  2 = down
		//  3 = left
	int currentDirection;
	int bugSpriteSpeed;
	
}

@end
