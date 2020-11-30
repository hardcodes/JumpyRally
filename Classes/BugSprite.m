//
//  BugSprite.m
//  Jumpy
//
//  Created by Sven Putze on 21.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "BugSprite.h"
#import "Globals.h"


@implementation BugSprite


- (void) additionalSetup{
	canCollide = true;
	isLethal = true;
//	bugSpriteSpeed = (arc4random() % HCBugMove) +1;
	boundingBoxBackgroundOffset = 0;
	animationSequenceIndex = (arc4random() % animationSequence[0]-1) +1;
	currentDirection= BUGUNKNOWN;
	[self changeDirection];
}


- (void) moveSprite{
	
	[super moveSprite];
	
	if([self boundingBoxHasCollidedWithBackground]){
		
		[self changeDirectionAfterCollision];
	}
	
}


- (void) changeDirectionAfterCollision{
	
		// sprite has collided somewhere set sprite back to old position
	currentPosition = lastPosition;
	int yDelta = ((int)currentPosition.y) % HCTileInnerSize;
	if (yDelta < HCTileInnerSizeHalf) currentPosition.y = ((int)currentPosition.y) - yDelta;

	int xDelta = ((int)currentPosition.x) % HCTileInnerSize;
	if (xDelta < HCTileInnerSizeHalf) currentPosition.x = ((int)currentPosition.x) - xDelta;
	
	[self changeDirection];
}


- (void) changeDirection{
	
		// random new direction
	int oldDirection = currentDirection;
		// be sure to choose a new direction
	while(currentDirection == oldDirection){
		currentDirection = (arc4random() % (BUGDIRCOUNT-1));
		
	}
		// rotate sprite depending on direction
	rotationAngle = currentDirection * 90;
		// random speed
	bugSpriteSpeed = (arc4random() % HCBugMove) +1;
	
	switch (currentDirection) {
		case BUGUP:
				// up
			movementDelta = CGPointMake(0,-bugSpriteSpeed );
			break;
			
		case BUGRIGHT:
				// right
			movementDelta = CGPointMake(bugSpriteSpeed,0);
			break;
			
		case BUGDOWN:
				// down
			movementDelta = CGPointMake(0,bugSpriteSpeed );
			break;
			
		case BUGLEFT:
				// left
			movementDelta = CGPointMake(-bugSpriteSpeed,0);
			break;
			
		default:
				// should never happen
			movementDelta = CGPointMake(0,0);
			break;
	}

}


@end
