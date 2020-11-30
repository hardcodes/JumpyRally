//
//  HealthStatusBar.h
//  Jumpy
//
//  Created by Sven Putze on 03.05.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Texture.h"

	// default healthstatus
#define HCDefaultHealth 128


@class GameStateEngine;
@class LevelResourceHandler;

	// This class implements a kind of sprite: the health status bar. Just like a progressbar in cnmventional
	// coding this bar is a graphical representation of the health status of the player AKA Jumpy.

@interface HealthStatusBar : NSObject {
    
		// reference to the OpenGL texture
	Texture *texture;
		// position, where this sprite should be drawn
	CGPoint currentPosition;
		// health of the player sprite
	int healthStatus;
		// direction in which this sprite should be displayed
		// TODO: change on orientation change
	int rotationAngle;
		// reference to the LevelResouceHandler
	LevelResourceHandler *levelResourceHandler;
}

@property (nonatomic, readwrite) CGPoint currentPosition;
@property (nonatomic, readwrite) int healthStatus;
@property (nonatomic, readwrite) int rotationAngle;


- (id) initWithImage: (NSString *) aImageName 
   atCurrentPosition: (CGPoint) aCurrentPosition
	 andHealthStatus: (int) aHealthStatus
withLevelResourceHandler: (LevelResourceHandler*) aLevelResourceHandler;


	// Selector draws the healthstatus bar on top of the screen.
	// Length of the statusbar is equal healthStatus.
- (void) drawHealthStatus;


	// Selector is called when the player sprite hits the first aid kit.
	// A bonus is added to the current health level.
- (void) addHealthBonus: (int) aBonus;


@end
