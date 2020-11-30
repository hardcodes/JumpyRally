//
//  GameStatus.h
//  Jumpy
//
//  Created by Sven Putze on 28.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import <Foundation/Foundation.h>

enum HCGameStates {
	LOAD_LEVEL,
	BUILD_LEVEL,
	PLAY_GAME,
	LEVEL_COMPLETE,
	GAME_COMPLETE,
	GAME_OVER,
	PLAYER_DIED,
	RETURNGAMECOMPLETE,
	RETURNGAMEOVER,
	WAITFORNEXTLEVEL,
	GAMEISPAUSED,
	COUNTDOWNGAMESTATE,
	PREPARECOUNTDOWNGAMESTATE,
	UNKNOWNGAMESTATE
};

extern NSString* const HCGameStatusFileName;
extern NSString* const HCGameState;
extern NSString* const HCLevelNumber;
extern NSString* const HCTotalScore;
extern NSString* const HCLevelStartScore;
extern NSString* const HCHealthStatus;
extern NSString* const HCLevelStartHealth;
extern NSString* const HCHighScore;
extern NSString* const HCHighScoreDate;
extern NSString* const HCGotBluyKey;
extern NSString* const HCGotRedKey;
extern NSString* const HCGotGoldKey;

@interface GameStatus : NSObject <NSCoding>{
    
		// stores the state of the game, see Globals.h/HCGameStates
	int gameState;
		// stores the previous gamestate
	int lastGameState;
		// contains the levelnumber
	int levelNumber;
		// score of the player
	int totalScore;
		// score of the player at the beginning of the level
	int levelStartScore;
		// health of the player sprite
	int healthStatus;
		// health of the player at the beginnig of the level
	int levelStartHealth;
		// highscore of the game
	int highScore;
		// date when the highscore was achieved
	NSDate *highScoreDate;
		// Has the player collected keys?
	bool gotBlueKey;
	bool gotRedKey;
	bool gotGoldKey;
	
}

@property (nonatomic, readwrite) bool gotBlueKey;
@property (nonatomic, readwrite) bool gotRedKey;
@property (nonatomic, readwrite) bool gotGoldKey;
@property (nonatomic, readwrite) int gameState;
@property (nonatomic, readwrite) int lastGameState;
@property (nonatomic, readwrite) int totalScore;
@property (nonatomic, readwrite) int levelNumber;
@property (nonatomic, readwrite) int healthStatus;
@property (nonatomic, readwrite) int highScore;
@property (nonatomic, readwrite, retain) NSDate *highScoreDate;
@property (nonatomic, readwrite) int levelStartScore;
@property (nonatomic, readwrite) int levelStartHealth;


	// Selector adds aValueToAdd to the current value of totalScore.
- (void) increaseTotalScore: (int) aValueToAdd;


	// Selector is used for starting a new game. Levelnumber is 001, score is 0, highscore stays untouched
- (void) resetGameStatus;

@end
