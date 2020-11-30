//
//  Globals.h
//  Jumpy
//
//  Created by Sven Putze on 15.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//
#import <UIKit/UIKit.h>
// this file contains globals definitions that are valid throughout the whole project.


	// frameinterval that is used by the timer.
	// iOS hardware can display 60 frames per second - a value of 2 displays every second frame = 30 fps.
#define HCFrameInterval 2
	// Maximum size of a layer of a TilEd TMX/XML-file that we can/will store
#define HCMaxLayerWidth 30
#define HCMAXLayerHeight 20
	// GID of the first sprite (Jumpy)
#define HCFirstSpriteGID 197
	// width and height of one tile
#define HCTileOuterSize 18
#define HCTileInnerSize 16
#define HCTilePaddingSize 1
#define HCTileInnerSizeHalf 8
	// min and max coordinates for sprites (safetynet)
#define HCminX 10
#define HCmaxX 470
#define HCminY 10
#define HCmaxY 310
	// middle of screen (for player control)
#define HCmidScreenUIInterfaceOrientationLandscape 240
#define HCmidScreenUIInterfaceOrientationPortrait 160
	// position for nextlevel and gameover logo
#define HCLogo256X 112
#define HCLogo256Y 32
#define HCPointingHandX 224
#define HCPointingHandY 220
	// if player sprite hits an enemy this value is subtracted from the health level
#define HCDecreaseHealth 2
	// a bomb explosion is more lethal
#define HCDecreaseBombHealth 4
	// if player sprite hits a first aid kit this value is added to the health status
	// health status can never be higher than HCDefaultHealth
#define HCHealthBonus 32
	// this amount of points is added to the score if the player hits a coin
#define HCCoinScore 10
	// score for killing other sprites
#define HCEyeScore 20
#define HCSkullScore 20
#define HCBugScore 20
#define HCBeeScore 50
#define HCBatScore 50
	// value for no tile
#define HCTileNullValue 0
	// number of movements the keys lives after it has been collected
#define HCKeyMaxPixelLifetime 15
	// keys are rotated by this values they have been collected
#define HCKeyRotationAngle 20
	// delta to the center of a bombtimer where the explosion (sprite is bigger) must be created
#define HCBombTimerDistance 24
	// distance between the left upper corner and the center of an explosion
#define HCExplosionCenterDistance 32
	// value is added to HCExplosionCenterDistance if a rock is hit by an explosion
#define HCRockExplosionOffset 4
	// number of frames before a sprite starts falling after botom tile is gone
#define HCSpriteNoBottomFrameCount 5
	// speed of angel sprite if jumpy dies
#define HCJumpyAngelSpriteSpeed 1.0
	// coordinates for the countdown
#define HCCountDownXPosition 240
#define HCCountDownYPosition 160
#define HCCountDownFrameStep 7

extern NSString * const HCGameStatus;
extern BOOL const HCCheat;

@interface Globals : NSObject {
    
	
}

@end
	

 
