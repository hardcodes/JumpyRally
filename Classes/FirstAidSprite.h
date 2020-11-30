//
//  FirstAidSprite.h
//  Jumpy
//
//  Created by Sven Putze on 03.05.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Sprite.h"


@interface FirstAidSprite : Sprite {
    
		// health is increased by this amount if player hits this sprite
	int healthBonus;
	
}

@property (nonatomic, readonly) int healthBonus;


@end
