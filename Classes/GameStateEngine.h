	//
	// GameStateEngine.h
	//
	// 20110415, Sven Putze
	//
#import <UIKit/UIKit.h>

#import "SpriteResourceHandler.h"
#import "TileMapLevelFile.h"
#import "Texture.h"

#import "Layer.h"
#import "SoundEngine.h"



extern int viewControllerDisplayWidth; 
extern int viewControllerDisplayHeight;

@class SpriteResourceHandler;
@class LevelResourceHandler;
@class GameStatus;

	// This class provides the central mechanismn of the game. The playfield and all sprites are controlled and rendered.
@interface GameStateEngine : NSObject {

		// reference to the used tilemap
	TileMapLevelFile *levelTileMap;
		// current orientation of the device
	UIInterfaceOrientation interfaceOrientation;
		// did the orientation change?
	bool orientationDidChange;
		// integer value representing in which direction the player is headed
	int playerControl;
		// wait for next touch when level has ended
	bool newTouchHasBegun;
		// stores information of the game, like e.g.
		// levelnumber, score, gamestatus etc.
	GameStatus *gameStatus;
		// stores information about any sprite used in the game
	SpriteResourceHandler *spriteResourceHandler;
		// stores resources for the level
	LevelResourceHandler *levelResourceHandler;
		// stores all soundeffects
	SoundEngine *soundEngine;
		// buffer where the drawing commands are rendered
	GLuint renderBuffer;

}

@property (readwrite) UIInterfaceOrientation interfaceOrientation;
@property (readwrite) bool orientationDidChange;
@property (nonatomic, readonly) int playerControl;
@property (nonatomic, readonly) TileMapLevelFile *levelTileMap;
@property (nonatomic, readwrite) int coinsInLevel;
@property (nonatomic, readwrite, assign) GameStatus *gameStatus;
@property (nonatomic, readwrite) bool newTouchHasBegun;
@property (nonatomic, readonly) SoundEngine *soundEngine;


	// Selector creates a singleton instance of this class and returns the reference object.
- (id) initWithSoundEngine: (SoundEngine*) aSoundEngine withGameStatus: (GameStatus*) aGameStatus;


	// Selector initializes NSMutableArray *spritesArray, newCreatedSpritesArray and destroyableSpritesArray. All png files are
	// preloaded and converted into textures. This was sprites will have a faster access to the needed resources.
	// The selector setOGLProjection is called to setup global values for Open GL.
- (void) preloader;


	// Selector builds the filename of the next TilEd TMX/XML file and parses the tilemap.
	// After that all sprites are generated by calling createSpritesFromTileMap.
- (void) loadNextLevel;



	// Selector is called when a level is complete to save the current status to disk. So a user can restart
	// in the next level, if he is interrupted in any way.
- (void) storeLevelStatus;


	// Selector draws the complete level with the information coded in the tilemap. So far that is:
	// background, maze and sprites.
- (void) buildLevel;


	// Selector draws the background of the level when the game is in state PLAY_GAME.
	// So far the level is drawn based on the layers background and maze. If this is a performance killer this
	// will be changed to drawing a complete texture.
- (void) drawLevelBackground;


	// touchhandling -> screen was touched on a new position
- (void) touchBegan: (CGPoint) p;


	// touchhandling -> finger was moved but still on the screen
- (void) touchMoved: (CGPoint) p;


	// touchhandling -> finger was lifted of the screen
- (void) touchEnded: (CGPoint) pointOfTouch;


	// reset the last touch -> clean beginning in a new level
- (void) resetTouch;


	// Selector checks the different gamstates and controls the flow of the whole game
- (void) drawGameStateInsideFrame: (CGRect) frame onRenderBuffer: (GLuint) aRenderBuffer;


	// Selector performs update of the sprite arrays, draws the background and moves/drwas the sprites
- (void) playGame;


	// Selector draws the HeadUpDisplay (player energy level, keys, score)
- (void) drawHud;


	// Selector substracts aValue from coinsInLevel.
- (void) DecreaseCoinsInLevel: (int) aValue;


	// Selector adds aValue from coinsInLevel.
- (void) IncreaseCoinsInLevel: (int) aValue;


	// Selector adds aValue to totalScore.
- (void) IncreaseTotalScore: (int) aValue;

@end