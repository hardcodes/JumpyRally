//
//  SpriteResourceHandler.h
//  Jumpy
//
//  Created by Sven Putze on 15.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "GameStateEngine.h"
#import "Sprite.h"
#import "Texture.h"
#import "JumpySprite.h"
#import "GoldCoinSprite.h"
#import "KeyBlueSprite.h"
#import "KeyGoldSprite.h"
#import "KeyRedSprite.h"
#import "FireSprite.h"
#import "BatSprite.h"
#import "BeeSprite.h"
#import "BugSprite.h"
#import "SkullSprite.h"
#import "EyeSprite.h"
#import "DoorBlueSprite.h"
#import "DoorGoldSprite.h"
#import "DoorRedSprite.h"
#import "RockSprite.h"
#import "WoodBoxSprite.h"
#import "BombSprite.h"
#import "ExplosionSprite.h"
#import "10PointsSprite.h"
#import "20PointsSprite.h"
#import "50PointsSprite.h"
#import "SparkleSprite.h"
#import "SmokeSprite.h"
#import "JumpyAngelSprite.h"
#import "JumpyDieSprite.h"
#import "BombTimerSprite.h"
#import "FirstAidSprite.h"
#import "TileMapLevelFile.h"
#import "HealthStatusBar.h"
#import "FireSprite.h"
#import "ScoreSprite.h"
#import "StandardDieSprite.h"
#import "GameOverSprite.h"
#import "LevelCompleteSprite.h"
#import "PointingHandSprite.h"
#import "GameCompleteSprite.h"
#import "HandlingSprite.h"
#import "OneCountDownSprite.h"
#import "TwoCountDownSprite.h"
#import "ThreeCountDownSprite.h"
#import "GoCountDownSprite.h"
#import "BigDragonSprite.h"

#define HCInitialArraySize 50

@class LevelResourceHandler;
@class GameStateEngine;
@class SoundEngine;

@interface SpriteResourceHandler : NSObject {
    
		// resource dictionary that references the images/textures of a sprite
	NSMutableDictionary* resourceDictionary;
		// reference to the player object
	JumpySprite *jumpySprite;
		// reference to the health status bar
	HealthStatusBar *healthStatusBar;
		// reference to the sprite that displays the current score in the HUD.
	ScoreSprite *scoreSprite;
		// Key sprites for the HUD
	KeyBlueSprite *keyBlueSprite;
	KeyGoldSprite *keyGoldSprite;
	KeyRedSprite *keyRedSprite;
		// active sprites that need to be rendered
	NSMutableArray *spritesArray;
		// new sprites thatshould be added to spritesArray
	NSMutableArray *createdSpritesArray;
		// sprites that don't need to be rendered anymore and must be removed from spritesArray
	NSMutableArray *destroyableSpritesArray;
		// position where the player sprite was initially placed into the level
	CGPoint jumpyStartPosition;
		// stores resources for the level
	LevelResourceHandler *levelResourceHandler;
		// reference to the GameStateEngine
	GameStateEngine *gameStateEngine;
		// reference to the SoundEngine
	SoundEngine *soundEngine;
}


@property (nonatomic, retain, readwrite) NSMutableDictionary* resourceDictionary;
@property (nonatomic, readonly) JumpySprite *jumpySprite;
@property (nonatomic, readonly) HealthStatusBar *healthStatusBar;
@property (nonatomic, readonly) ScoreSprite *scoreSprite;
@property (nonatomic, readonly) KeyBlueSprite *keyBlueSprite;
@property (nonatomic, readonly) KeyGoldSprite *keyGoldSprite;
@property (nonatomic, readonly) KeyRedSprite *keyRedSprite;
@property (nonatomic, retain, readwrite) NSMutableArray *spritesArray;
@property (nonatomic, retain, readwrite) NSMutableArray *createdSpritesArray;
@property (nonatomic, retain, readwrite) NSMutableArray *destroyableSpritesArray;
@property (nonatomic, readonly) CGPoint jumpyStartPosition;
@property (nonatomic, readonly) SoundEngine *soundEngine;


	// init this class and get a GameStateEngine as a reference
- (id) initWithGameStateEngine: (GameStateEngine*) aGameStateEngine
	  withLevelResourceHandler: (LevelResourceHandler*) aLevelResourceHandler
			   withSoundEngine: (SoundEngine*) aSoundEngine;



	// Selector is called when the singleton instance is created
	// all known sprites are preloaded into the resource dictionary
- (void) preloader;


	// Selector returns the (file)name of a sprite for the given type.
	// aTypeOfSprite must be one out of class Sprite.h/enum typesOfSprites {}
- (NSString*) getNameForTypeOfSprite: (int) aTypeOfSprite;



	// Selector creates the given type of sprite - so that it can be added to a resource array.
- (void) createSpriteOfType: (int) aTypeOfSprite
			   atPosition: (CGPoint) aPosition;



	// Selector uses the tilemap layer "sprites" to create the needed sprites after the level has been build.
	// The layer encodes the type of sprite and position.
- (void) createSpritesFromTileMap;



	// Selector returns a class of type SpriteTexture that was stored in the NSDictionary resourceDictionary by the Selector preloader.
- (SpriteTexture *) getSpriteTextureFromDictionaryForImage: (NSString*) aImageName;



	// perform checks for the different sprite types
	// e.g.	has the playersprite collided with an enemy?
	// 		has the player collected a coin?
	//		has the player collected a health bonus?
- (void) checkCollisionsForSprite: (Sprite *) sprite;



	// Selector is called every frame to update the status of all sprites. NSMutableArray *destroyableSpritesArray is walked to remove
	// all sprites that should be deleted. Next the NSMutableArray *newCreatedSpritesArray is walked to add new created sprites to the
	// NSMutableArray *spritesArray.
- (void) updateSpriteArrays;


	// Selector is called every frame and walks NSMutableArray *spritesArray to check if a sprite in the array is still active. If it is
	// active then the selctor checkSprites is called (for collision control etc.). Depending on its type some selectors of the sprite itself are called. E.g., moveSprite, drawFrame. If it is not
	// active anymore it is added to NSMutableArray *destroyableSpritesArray and will be deleted in the next gamelop.
- (void) moveAndCheckSprites;


	// Selector is called each frame to draw the sprites on top of the background
- (void) drawSprites;



@end
