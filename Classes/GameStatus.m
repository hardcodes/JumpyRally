//
//  GameStatus.m
//  Jumpy
//
//  Created by Sven Putze on 28.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "GameStatus.h"
#import "HealthStatusBar.h"

	// predefine strings for filename and propertykeys
NSString* const HCGameStatusFileName=@"HCJumyGameStatus.xml";
NSString* const HCGameState=@"gameState";
NSString* const HCLevelNumber=@"levelNumber";
NSString* const HCTotalScore=@"totalScore";
NSString* const HCLevelStartScore=@"levelStartScore";
NSString* const HCHealthStatus=@"healthStatus";
NSString* const HCLevelStartHealth=@"levelStartHealth";
NSString* const HCHighScoreDate=@"highScoreDate";
NSString* const HCHighScore=@"highScore";
NSString* const HCGotBluyKey=@"gotBlueKey";
NSString* const HCGotRedKey=@"gotRedKey";
NSString* const HCGotGoldKey=@"gotGoldKey";


@implementation GameStatus


@synthesize gotBlueKey;
@synthesize gotGoldKey;
@synthesize gotRedKey;
@synthesize gameState;
@synthesize lastGameState;
@synthesize totalScore;
@synthesize levelNumber;
@synthesize healthStatus;
@synthesize highScore;
@synthesize highScoreDate;
@synthesize levelStartScore;
@synthesize levelStartHealth;


#pragma mark - init/decode/encode


- (id) init{
	
	self = [super init];
	if(self){
		[self resetGameStatus];
		highScore = 0;
			// use the dedicated setter method here to use the retain of the synthesized property
		[self setHighScoreDate: [NSDate dateWithTimeIntervalSince1970: 0]];
	}
	return self;
}



- (void) resetGameStatus{
	gameState =  LOAD_LEVEL;
	lastGameState = UNKNOWNGAMESTATE;
	levelNumber = 1;
	totalScore = 0;
	levelStartScore = 0;
	healthStatus = HCDefaultHealth;
}



- (id)initWithCoder:(NSCoder *)aDecoder{
	
	self = [super init];
	if (self){
		self.gameState = [aDecoder decodeIntForKey: HCGameState];
		self.levelNumber = [aDecoder decodeIntForKey: HCLevelNumber];
		self.totalScore= [aDecoder decodeIntForKey: HCTotalScore];
		self.levelStartScore = [aDecoder decodeIntForKey: HCLevelStartScore];
		self.healthStatus = [aDecoder decodeIntForKey: HCHealthStatus];
		self.levelStartHealth = [aDecoder decodeIntForKey: HCLevelStartHealth];
		self.highScore = [aDecoder decodeIntegerForKey: HCHighScore];
		self.highScoreDate = [aDecoder decodeObjectForKey: HCHighScoreDate];
		self.gotBlueKey = [aDecoder decodeBoolForKey: HCGotBluyKey];
		self.gotRedKey = [aDecoder decodeBoolForKey: HCGotRedKey];
		self.gotGoldKey = [aDecoder decodeBoolForKey: HCGotGoldKey];
	}
	return self;
}



- (void)encodeWithCoder:(NSCoder *)aCoder{
		
	[aCoder encodeInteger: [self gameState] forKey: HCGameState];
	[aCoder encodeInteger: [self levelNumber] forKey: HCLevelNumber];
	[aCoder encodeInteger: [self totalScore] forKey: HCTotalScore];
	[aCoder encodeInteger: [self levelStartScore] forKey: HCLevelStartScore];
	[aCoder encodeInteger: [self healthStatus] forKey: HCHealthStatus];
	[aCoder encodeInteger: [self levelStartHealth] forKey: HCLevelStartHealth];
	[aCoder encodeInteger: [self highScore] forKey: HCHighScore];
	[aCoder encodeObject: [self highScoreDate] forKey: HCHighScoreDate];
	[aCoder encodeBool: [self gotBlueKey] forKey: HCGotBluyKey];
	[aCoder encodeBool: [self gotRedKey] forKey: HCGotRedKey];
	[aCoder encodeBool: [self gotGoldKey] forKey: HCGotGoldKey];
	
}



- (void) dealloc{
#if DEBUG
	NSLog(@"START dealloc: GameStatus");
#endif
	
	[highScoreDate release];
	[super dealloc];
	
#if DEBUG
	NSLog(@"END dealloc: GameStatus");
#endif
}


# pragma mark - helper methods


	// overridden to set the lastGameState
- (void) setGameState: (int) aGameState{

#if DEBUG
	NSLog(@"START setGameState");
	NSLog(@"incoming gamestate: %i", aGameState);
#endif
	if(aGameState == COUNTDOWNGAMESTATE || aGameState == PREPARECOUNTDOWNGAMESTATE) lastGameState = PLAY_GAME;
	else lastGameState = gameState;
	gameState = aGameState;
	
#if DEBUG
	NSLog(@"lastGameState: %i", lastGameState);
	NSLog(@"gameState (=incoming): %i", gameState);
	NSLog(@"END setGameState");
#endif
	
	
}


- (void) increaseTotalScore: (int) aValueToAdd{
	
	totalScore += aValueToAdd;
}



@end
