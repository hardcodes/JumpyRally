
#import "GameStateEngine.h"
#import "Globals.h"
#import "TileMapLevelFile.h"
#import "EAGL.h"
#import "MyGameAppDelegate.h"
#import "LevelResourceHandler.h"
#import "PersistanceHandler.h"
#import "GameStatus.h"



	// TODO : get from ViewController (future release: orientation change)
int viewControllerDisplayWidth=320;
int viewControllerDisplayHeight=480;



@implementation GameStateEngine

@synthesize interfaceOrientation;
@synthesize orientationDidChange;
@synthesize playerControl;
@synthesize levelTileMap;
@synthesize coinsInLevel;
@synthesize gameStatus;
@synthesize newTouchHasBegun;
@synthesize soundEngine;


#pragma mark - Init & Loading


- (id) init{
	
		// override standard init to prevent user from using this!
	[self dealloc];
	@throw [NSException exceptionWithName:@"HCBadInitCall" reason:@"You must use initWithSoundEngine: (SoundEngine*) aSoundEngine(...)" userInfo:nil];
	return nil;
}



- (id) initWithSoundEngine: (SoundEngine*) aSoundEngine withGameStatus: (GameStatus*) aGameStatus{
	
	self = [super init];
	if (self){
			// create class for storing game information
		if(! aGameStatus){
			gameStatus = [[GameStatus alloc] init];
			if (! gameStatus) return nil;
		}
		else gameStatus = [aGameStatus retain];
		
		levelResourceHandler = [[LevelResourceHandler alloc] init];
		if (! levelResourceHandler) return nil;
		
		soundEngine = [aSoundEngine retain];
		
		spriteResourceHandler = [[SpriteResourceHandler alloc] initWithGameStateEngine: self
															  withLevelResourceHandler: levelResourceHandler
																	   withSoundEngine: soundEngine];
		if (! spriteResourceHandler) return nil;

			
		[self preloader];
		[self resetTouch];
	}
	
	return self;
	
}



- (void) dealloc {
	
#if DEBUG
	NSLog(@"START dealloc: GameStateEngine");
#endif
	
	[soundEngine release];
	[levelTileMap release];
	[spriteResourceHandler release];
	[levelResourceHandler release];
	[gameStatus release];
	[super dealloc];
	
#if DEBUG
	NSLog(@"END dealloc: GameStateEngine");
#endif
}


- (void) preloader {
	
		// preload all sprite textures
	[spriteResourceHandler preloader];
		// preload all the sounds for the game
	[soundEngine preloadSounds];
		// set the OpenAL listener to its default position
	ALfloat listenerPosition[]={0.0,0.0,0.0};
	ALfloat listenerVelocity[]={0.0,0.0,0.0};
	ALfloat listenerOrientation[]={0.0,0.0,1.0, 0.0,1.0,0.0};
	
	[soundEngine setListenerPosition: listenerPosition];
	[soundEngine setListenerOrientation: listenerOrientation];
	[soundEngine setListenerVelocity: listenerVelocity];
	
		// set 2D mode and set GL_MODELVIEW
	[EAGL setEAGLProjectionWithWidth: viewControllerDisplayWidth andHeight: viewControllerDisplayHeight];

}


- (void) loadNextLevel{
	
		// build filename for next level
	NSString *levelFileName = [NSString stringWithFormat:@"level%.3d",[gameStatus levelNumber]];
	
		// release resources if there has been a level loaded before
	if (levelTileMap != nil) [levelTileMap release];
	levelTileMap = [[TileMapLevelFile alloc] initWithFileName: levelFileName
										withExtension:  @"tmx"
					withLevelResourceHandler: levelResourceHandler];
	[gameStatus setGameState: BUILD_LEVEL];
	[soundEngine fadeMusicVolumeFrom: HCDefaultMusicVolume toVolume: 0 duration: HCDefaultFadeDuration stopAfterFade: YES];
	[soundEngine setGlobalSfxVolume: HCDefaultSoundVolume];
	[self resetTouch];
}



- (void) storeLevelStatus{
	
	[gameStatus setGotRedKey: false];
	[gameStatus setGotBlueKey: false];
	[gameStatus setGotGoldKey: false];
		// remember score and health at the beginning of the level so that we can start from here again
		// if the game is interrupted
	[gameStatus setLevelStartHealth: [gameStatus healthStatus]];
	[gameStatus setLevelStartScore: [gameStatus totalScore]];
	
		// save gameStatus to disk, so we can continue from this gameState any time
	[PersistanceHandler archiveObject: gameStatus toNSDocumentDirectoryWithFileName: HCGameStatusFileName];
	
}



-(void) buildLevel{
	
#if DEBUG
	NSLog(@"build level");
#endif
	
		// Draw the background layer
	[[[levelTileMap tileMapLayers] objectForKey:@"background"] drawCompleteLayer];
		// Draw the maze layer (foreground)
	[[[levelTileMap tileMapLayers] objectForKey:@"maze"] drawCompleteLayer];

		// Insert the sprites
#if DEBUG
	NSLog(@"insert sprites");
#endif
	
	[spriteResourceHandler createSpritesFromTileMap];

}



#pragma mark - Touch Handling


- (void) touchBegan: (CGPoint) pointOfTouch {
	
	
	switch ([gameStatus gameState]){
			
		case PLAY_GAME:
			
			switch (interfaceOrientation) {
					
				case UIInterfaceOrientationLandscapeLeft:
					
					if(pointOfTouch.y > HCmidScreenUIInterfaceOrientationLandscape) playerControl = playerControl|1;
					else playerControl = playerControl|2;
					break;
					
				case UIInterfaceOrientationLandscapeRight:
					
					if(pointOfTouch.y < HCmidScreenUIInterfaceOrientationLandscape) playerControl = playerControl|1;
					else playerControl = playerControl|2;
					break;
					
				case UIInterfaceOrientationPortrait:
					
					if(pointOfTouch.x < HCmidScreenUIInterfaceOrientationPortrait) playerControl = playerControl|1;
					else playerControl = playerControl|2;
					break;
					
				case UIInterfaceOrientationPortraitUpsideDown:
					
					if(pointOfTouch.x > HCmidScreenUIInterfaceOrientationPortrait) playerControl = playerControl|1;
					else playerControl = playerControl|2;
					break;
					
				default:
					break;
			}
			
			[[spriteResourceHandler jumpySprite] setCurrentDirection:playerControl];
			
			break;
			
			
		case WAITFORNEXTLEVEL:
		case GAME_COMPLETE:
		case GAME_OVER:
			
			newTouchHasBegun = true;
			
		default:
			
			break;
			
	}
	
	
}



- (void) touchMoved: (CGPoint) pointOfTouch {
	
}



- (void) touchEnded: (CGPoint) pointOfTouch{
	
	switch ([gameStatus gameState]){
			
		case PLAY_GAME:
			
			switch (interfaceOrientation) {
					
					
				case UIInterfaceOrientationLandscapeLeft:
					
					if(pointOfTouch.y > HCmidScreenUIInterfaceOrientationLandscape) playerControl = playerControl^1;
					else playerControl = playerControl^2;
					break;
					
				case UIInterfaceOrientationLandscapeRight:
					
					if(pointOfTouch.y < HCmidScreenUIInterfaceOrientationLandscape) playerControl = playerControl^1;
					else playerControl = playerControl^2;
					break;
					
				case UIInterfaceOrientationPortrait:
					
					if(pointOfTouch.x < HCmidScreenUIInterfaceOrientationPortrait) playerControl = playerControl^1;
					else playerControl = playerControl^2;
					break;
					
				case UIInterfaceOrientationPortraitUpsideDown:
					
					if(pointOfTouch.x > HCmidScreenUIInterfaceOrientationPortrait) playerControl = playerControl^1;
					else playerControl = playerControl^2;
					break;
					
				default:
					break;
			}
			
			[[spriteResourceHandler jumpySprite] setCurrentDirection:playerControl];
			
			break;
			
		case GAME_OVER:
			
			if (newTouchHasBegun){
				[gameStatus setGameState: RETURNGAMEOVER];
					// unload the gameover logo
				[[spriteResourceHandler resourceDictionary] removeObjectForKey: [spriteResourceHandler getNameForTypeOfSprite:GAMEOVER]];
			}
			
			break;
			
		case GAME_COMPLETE:
			
			if (newTouchHasBegun){
				[gameStatus setGameState: RETURNGAMECOMPLETE];
				
					// unload the gameover logo
				[[spriteResourceHandler resourceDictionary] removeObjectForKey: [spriteResourceHandler getNameForTypeOfSprite:GAMECOMPLETESPRITE]];
			}
			
			break;
			
		case WAITFORNEXTLEVEL:
			
			if (newTouchHasBegun){
				[gameStatus setGameState: LEVEL_COMPLETE];
					// unload the level complete logo
				[[spriteResourceHandler resourceDictionary] removeObjectForKey: [spriteResourceHandler getNameForTypeOfSprite:LEVELCOMPLETESPRITE]];
			}
			
			break;
			
		default:
			
			break;
	}
	
}


- (void) resetTouch{
	
	newTouchHasBegun = false;
		// all bits cleared = stay in middle
	playerControl = 0;
}


#pragma mark - Gameplay

- (void) drawGameStateInsideFrame: (CGRect) frame  onRenderBuffer: (GLuint) aRenderBuffer{
	
	renderBuffer = aRenderBuffer;
	viewControllerDisplayWidth = frame.size.width;
	viewControllerDisplayHeight = frame.size.height; 
		//CGPoint o = [self getViewportOrigin];
	switch ([gameStatus gameState]) {
			
				// check this condition first - it is the most wanted
		case PLAY_GAME:
			[self playGame];
			break;
			
		case LOAD_LEVEL:
				//[self storeLevelStatus];
			[self loadNextLevel];
			break;
			
		case BUILD_LEVEL:
			[self buildLevel];
			[gameStatus setGameState: PREPARECOUNTDOWNGAMESTATE];
			break;
			
		case WAITFORNEXTLEVEL:
				// do nothing, wait until user touches the screen
			[self playGame];
			break;
			
		case LEVEL_COMPLETE:
				// new levelnumber has been set in playGame, now load the next level
			[gameStatus setGameState: LOAD_LEVEL];
			break;
			
		case GAME_COMPLETE:
				// do nothing, wait until user touches the screen
			[self playGame];
			[soundEngine stopAllSounds];
			break;
			
		case PLAYER_DIED:
				// player has no more health points
				// die sequence is displayed
				// angel sequence is displayed
				// when angel reaches top of screen the gameState is chaned to GAME_OVER
			[self playGame];
			break;
			
		case GAME_OVER:
			[self playGame];
				// display game over graphics and wait for touch of screen
				// to end the game completely
			break; 
			
		case RETURNGAMECOMPLETE:
		case RETURNGAMEOVER:
				// this state signals the MainView that we want to return
			[(MyGameAppDelegate *)[[UIApplication sharedApplication] delegate] setGameIsRunning:false];
			
			break;
			
		case GAMEISPAUSED:
				// game is paused, e.g. incoming call or display is locked - do nothing
			NSLog(@"pause - do nothing");
			break;
			
		case COUNTDOWNGAMESTATE:
			[self playGame];
			break;
			
		case PREPARECOUNTDOWNGAMESTATE:
			[gameStatus setGameState: COUNTDOWNGAMESTATE];
				// start the countdown by placing the ThreeSprite
			[spriteResourceHandler createSpriteOfType: THREESEQUENCESPRITE 
										   atPosition: CGPointMake(HCCountDownXPosition, HCCountDownYPosition)];
			break;
			
		default:
				// This should never happen
			NSLog(@"ERROR: unknown gamestate: %i", [gameStatus gameState]);
			break;
			
	}
}	 


- (void) playGame {
	
	if(coinsInLevel == 0 && [gameStatus gameState] != WAITFORNEXTLEVEL && [gameStatus gameState] != GAME_COMPLETE) {
		
		[soundEngine stopAllSounds];
		[soundEngine setGlobalSfxVolume: 0];
			//		[soundEngine
			// check if next level exists, if yes gameState = WATFORNEXTLEVEL
			// if not gameState = GAME_COMPLETE
		[gameStatus setLevelNumber: [gameStatus levelNumber] + 1];
		[soundEngine setMasterMusicVolume: HCDefaultMusicVolume];
		
		NSString *levelFileName = [NSString stringWithFormat:@"level%.3d",[gameStatus levelNumber]];
#if DEBUG
		NSLog(@"next levelfilename: %@.tmx",levelFileName);
#endif
			// check if level file exists - yes = load, no = last level 0 end of game.
		NSString *pathToLevel = [[NSBundle mainBundle] pathForResource: levelFileName ofType: @"tmx"];
		NSLog(@"path: %@",pathToLevel);
		if(pathToLevel){
			
			[gameStatus setGameState: WAITFORNEXTLEVEL];
			[self resetTouch];
				// TODO:
				// start music
				// show graphics (touch for new level)
			[spriteResourceHandler createSpriteOfType: LEVELCOMPLETESPRITE
														 atPosition: CGPointMake(HCLogo256X, HCLogo256Y)];
			[spriteResourceHandler createSpriteOfType: POINTINGHANDSPRITE
														 atPosition: CGPointMake(HCPointingHandX, HCPointingHandY)];
				// deactivate jumpy to make sure that no enemy can destroy it while we are waiting for
				// the next level
			[[spriteResourceHandler jumpySprite] setIsActive: false];
			[self storeLevelStatus];
			[soundEngine playMusicOfType: LEVELCOMPLETESONG timesToRepeat: HCDefaultMusicRepeatCount];
			return;
			
			
		}
		else{
#if DEBUG
			NSLog(@"last level, game ends...");
#endif
			[gameStatus setGameState: GAME_COMPLETE];
				// the level status is normally stored when the level is loaded into memory
				// in this special case we must save again to prevent the main menu from
				// showing the "continue old game" button
			[self storeLevelStatus];
			[self resetTouch];
			[spriteResourceHandler createSpriteOfType: GAMECOMPLETESPRITE
														 atPosition: CGPointMake(HCLogo256X, HCLogo256Y)];
			[spriteResourceHandler createSpriteOfType: POINTINGHANDSPRITE
														 atPosition: CGPointMake(HCPointingHandX, HCPointingHandY)];
				// deactivate jumpy to make sure that no enemy can destroy it while we are waiting for
				// the next level
			[[spriteResourceHandler jumpySprite] setIsActive: false];
			[self storeLevelStatus];
			[soundEngine playMusicOfType: GAMECOMPLETESONG timesToRepeat: HCDefaultMusicRepeatCount];
			return;
		}
				
	}
		// delete deactivated sprites, create new sprites
	[spriteResourceHandler updateSpriteArrays];
		// get user input and move player sprite
		// move enemies
		// collision control
	[spriteResourceHandler moveAndCheckSprites];
	
		// background & maze
	[self drawLevelBackground];
		// draw sprites
	[spriteResourceHandler drawSprites];
	
		// show HUD
	[self drawHud];
	
} 



- (void) drawLevelBackground{
	
		//[levelTexture drawTextureWithWidth: 480 AndHeight: 320];
	
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glColor4f(1, 1, 1, 1);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
		// Draw the background layer
	[[[levelTileMap tileMapLayers] objectForKey:@"background"] drawCompleteLayer];
		// draw the maze over the background
	[[[levelTileMap tileMapLayers] objectForKey:@"maze"] drawCompleteLayer];
	
}



- (void) drawHud{
	
		// show the healhstatus of the player sprite on top of the screen
	[[spriteResourceHandler healthStatusBar] drawHealthStatus];
		// show keys in inventory
	if([gameStatus gotBlueKey]){
		[[spriteResourceHandler keyBlueSprite] drawNextAnimationFrame];
	}
	if([gameStatus gotRedKey]){
		[[spriteResourceHandler keyRedSprite] drawNextAnimationFrame];		
	}
	if([gameStatus gotGoldKey]){
		[[spriteResourceHandler keyGoldSprite] drawNextAnimationFrame];
	}
		// show score
	[[spriteResourceHandler scoreSprite] drawCurrentScore: [gameStatus totalScore]];
	
}



	// Selector substracts aValue from coinsInLevel.
- (void) DecreaseCoinsInLevel: (int) aValue{
	coinsInLevel -= aValue;
}



	// Selector substracts aValue from coinsInLevel.
- (void) IncreaseCoinsInLevel: (int) aValue{
	coinsInLevel += aValue;
}


	// Selector adds aValue to totalScore.
- (void) IncreaseTotalScore: (int) aValue{
	[gameStatus increaseTotalScore: aValue];
}



@end
