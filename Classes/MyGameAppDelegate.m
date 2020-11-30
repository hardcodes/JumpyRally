
#import "MyGameAppDelegate.h"
#import "Globals.h"
#import "PersistanceHandler.h"



@implementation MyGameAppDelegate

@synthesize gameIsRunning;
@synthesize soundEngine;


#pragma mark - init

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
#if TARGET_IPHONE_SIMULATOR
	NSLog(@"iPhone simulator");
#else
	NSLog(@"real device");
#endif
	
#if DEBUG
	NSLog(@"debugmode");
#else
	NSLog(@"production code");
#endif
	
		// mark the initial game start for applicationDidBecomeActive
	applicationDidBecomeActiveForTheFirstTime = true;
		// Start getting device orientation notifications
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
	
	gameIsPaused = false;
	gameIsRunning = false;
	
		// make some noise (so we can play a melody direct after start - maybe even before the start screen is shown
	soundEngine = [[SoundEngine alloc] init];
	if (!soundEngine){
		@throw [NSException exceptionWithName:@"HCNoSoundEngine" reason:@"Could not init SoundEngine - game halted!" userInfo:nil];
	}
	[soundEngine preloadMusic];
	[soundEngine loadSoundOfType: HIGHSCORESOUND];
	[soundEngine loadSoundOfType: HEALTHCOLLECTEDSOUND];
		// try to load an old gamestatus
	gameStatus = [[PersistanceHandler decodeObjectFromNSDocumentDirectoryWithFileName: HCGameStatusFileName] retain];
		// if loading was no success create a new empty gamestate
	if (!gameStatus) gameStatus = [[GameStatus alloc] init];
	
		// add a viewcontroller, so that we can receive rotation events
	mainMenuUIViewController = [[MainMenuUIViewController alloc] initWithNibName: @"MainMenuView" bundle: [NSBundle mainBundle]];
		// gameStatus must be set before the view is shown!
	[mainMenuUIViewController setGameStatus: gameStatus];
	
	[window addSubview: [mainMenuUIViewController view]];
	[window makeKeyAndVisible];
	
}


- (void) dealloc {
	[self stopGameLoopTimer];
	[gameLoopTimer release];
	[gameEngineViewController release];
	[mainMenuUIViewController release];
	if(gameStatus) [gameStatus release];
	[window release];
	[soundEngine release];
	[super dealloc];
}


	// application is active (=user can see it) so start the timer/gameloop
- (void) applicationDidBecomeActive: (UIApplication *) application {
#if DEBUG
	NSLog(@"START applicationDidBecomeActive");
#endif

	if(gameIsRunning){
			// allow drawing of content again
		gameIsPaused = false;
		
		[soundEngine setMasterMusicVolume: HCDefaultMusicVolume];
		[soundEngine setGlobalSfxVolume: HCDefaultSoundVolume];
		if(! applicationDidBecomeActiveForTheFirstTime){
			
			switch ([gameStatus lastGameState]){
				PLAY_GAME:
					[gameStatus setGameState: PREPARECOUNTDOWNGAMESTATE];
					break;

				default:
					[gameStatus setGameState: [gameStatus lastGameState]];
					break;
			}
		}
		
	}
	else{
		[soundEngine setMasterMusicVolume: 0];
		[soundEngine playMusicOfType: MENUSONG timesToRepeat: HCDefaultMusicRepeatCount];
		[soundEngine fadeMusicVolumeFrom: 0 toVolume: HCDefaultMusicVolume duration: HCDefaultFadeDuration stopAfterFade: NO];	
	}
	applicationDidBecomeActiveForTheFirstTime = false;
	
#if DEBUG
	NSLog(@"END applicationDidBecomeActive");
#endif
	
}


	// application will become inactive (=user can't see it anymore) so stop the timer/gameloop
- (void) applicationWillResignActive: (UIApplication *) application {
#if DEBUG
	NSLog(@"START applicationWillResignActive");
#endif

	
	if(gameIsRunning){
			// prevent Open GL drawing (that would kill the applicaton)
			// the time will still be fired but nothing will be drawn
		gameIsPaused = true;
		
			// switch back to the main menu
		[window addSubview: [mainMenuUIViewController view]];
		[window makeKeyAndVisible];
		
			// at this moment we should have a reference to gameStatus
		if(gameStatus)[gameStatus setGameState: GAMEISPAUSED];
		
		[window addSubview: [gameEngineViewController view]];
		[window makeKeyAndVisible];
	}
		// make it quiet
	[soundEngine setMasterMusicVolume: 0];
	[soundEngine setGlobalSfxVolume: 0];
	[soundEngine stopAllSounds];
	[soundEngine stopMusic];
	
#if DEBUG
	NSLog(@"END applicationWillResignActive");
#endif
}


#pragma mark - timer

	// create the timer (NSTimer or CADisplayLink) and start fireing timer events
- (void) startGameLoopTimer {
	NSString *deviceOS = [[UIDevice currentDevice] systemVersion];
	bool forceTimerVariant = FALSE;
	
		// CADisplayLink does not exist on iOS 3.0 and lower
	if (forceTimerVariant || [deviceOS compare: @"3.1" options: NSNumericSearch] == NSOrderedAscending) {
		gameLoopTimer = [NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)((1.0 / 60.0) * HCFrameInterval)
														 target: self
													   selector: @selector( drawFrameContentLoop )
													   userInfo: nil
														repeats: YES];
#if DEBUG
		NSLog(@"NSTimer");
#endif
		
	} else {
		gameLoopTimer = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget: self selector: @selector( drawFrameContentLoop )];
		[gameLoopTimer setFrameInterval: HCFrameInterval];
		[gameLoopTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
#if DEBUG
		NSLog(@"@CADisplayLink");
#endif
	}
	
	gameIsRunning = true;
#if DEBUG
	NSLog(@"Game Loop timer instance: %@", gameLoopTimer); 
#endif
}

	// stop the active timer and the gameloop
- (void) stopGameLoopTimer {
	[gameLoopTimer invalidate];
	gameLoopTimer = nil;
}


#pragma mark - gameloop

	// delegate for the timer event, calls the real drawing routine in the GameStateEngine
- (void) drawFrameContentLoop {
	
		// a paused game should not draw any content
	if(gameIsPaused) return;
	
	if(gameIsRunning){
			// call "drawRect", which will then call the real drawing routine in our gameStateEngine
			// this way we behave like a "normal" view (protocoll)
		[[gameEngineViewController gameEngineView] drawRect:[UIScreen mainScreen].applicationFrame];
	}
	else{
#if DEBUG
		NSLog(@"drawFrameContentLoop - ending game!");
#endif
		[self returnFromGame];
	}
	
}



- (void) returnFromGame{
	
#if DEBUG
	NSLog(@"START returnFromGame");
#endif
		// stop the gameloop, so the frames are not redrawn
	[self stopGameLoopTimer];
	
	if ([mainMenuUIViewController viewIsLoadedInmemory]){
			// update the button and highscore status only when view is loaded
			// into memory.
			// Otherwise the view will be loaded by accessing it and then
			// both states will be updated by viewDidLoad
		[mainMenuUIViewController setContinueButtonStatus];
		[mainMenuUIViewController showHighScore];
	}
		// switch back to the main menu
	[window addSubview: [mainMenuUIViewController view]];
	[window makeKeyAndVisible];
	
		// at this moment we should have a reference to gameStatus
		// if not - for whatever reason - we load it from disk.
	if(! gameStatus) gameStatus = [[PersistanceHandler decodeObjectFromNSDocumentDirectoryWithFileName: HCGameStatusFileName] retain];
	
		// tell UIViewController to drop the view
	[gameEngineViewController unloadView];
	
	[soundEngine setMasterMusicVolume: 0];
	[soundEngine playMusicOfType: MENUSONG timesToRepeat: HCDefaultMusicRepeatCount];
	[soundEngine fadeMusicVolumeFrom: 0 toVolume: HCDefaultMusicVolume duration: HCDefaultFadeDuration stopAfterFade: NO];	
	
	gameIsRunning = false;
#if DEBUG
	NSLog(@"END returnFromGame");
#endif
}



- (void) startNewGame{
	
	[soundEngine playSoundOfType: HEALTHCOLLECTEDSOUND at2DPosition: CGPointMake(HCmidScreenUIInterfaceOrientationLandscape, HCmaxY)];
	if(gameStatus) [gameStatus resetGameStatus];
		// store new fixed gameStatus to disk
	[PersistanceHandler archiveObject: gameStatus toNSDocumentDirectoryWithFileName: HCGameStatusFileName];
	if (!gameEngineViewController) gameEngineViewController = [[GameEngineUIViewController alloc] initWithSoundEngine: soundEngine
																									   withGameStatus: gameStatus];
	[window addSubview: [gameEngineViewController view]];
	[window makeKeyAndVisible];
	[self startGameLoopTimer];
}



- (void) continueOldGame{
	
	[soundEngine playSoundOfType: HEALTHCOLLECTEDSOUND at2DPosition: CGPointMake(HCmidScreenUIInterfaceOrientationLandscape, HCmaxY)];
	[gameStatus setGameState : LOAD_LEVEL];
	[gameStatus setHealthStatus: [gameStatus levelStartHealth]];
	if (!gameEngineViewController) gameEngineViewController = [[GameEngineUIViewController alloc] initWithSoundEngine: soundEngine
																									   withGameStatus: gameStatus];
	[window addSubview: [gameEngineViewController view]];
	[window makeKeyAndVisible];
		//[[mainMenuUIViewController labelStatus] setText: @""];
	[self startGameLoopTimer];
}



@end
