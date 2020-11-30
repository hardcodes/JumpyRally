//
//  ScoreSprite.h
//  Jumpy
//
//  Created by Sven Putze on 09.05.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"

	// ScoreSprite implements a special sprite. The gamescore is displayed in the HUD with help of this sprite.
@interface ScoreSprite : Sprite {
    
		// stores the score of the player
	int score;
		// Stores Copy of the Position
	CGPoint positionCopy;
		
	
}

@property (nonatomic, readwrite) int score;


	// Selector draws the score of the player on the right side of the HUD.
- (void) drawCurrentScore: (int) aScore;

@end
