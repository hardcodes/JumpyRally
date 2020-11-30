
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameEngineUIViewController.h"
#import "MainMenuUIViewController.h"
#import "GameStatus.h"
#import "SoundEngine.h"


@interface MyGameAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	
	
	GameEngineUIViewController *gameEngineViewController;
	MainMenuUIViewController *mainMenuUIViewController;
	
		// OS < 3.1 instanceOf NSTimer else instanceOf CADisplayLink
		// type is defined on runtime
		// no check at compile time, but it will work ;-)
	id gameLoopTimer;
		// status from the game when it returns
	GameStatus *gameStatus;
		// tells timer if game is still running and the next frame must be drawn
	bool gameIsRunning;
		// is set to true if applicationWillResignActive is received
	bool gameIsPaused;
		// indicates if this is the initial start of the game
	bool applicationDidBecomeActiveForTheFirstTime;
		// reference to our soundmachine
	SoundEngine *soundEngine;
}

@property (readwrite) bool gameIsRunning;
@property (readonly) SoundEngine *soundEngine;


	// create the timer (NSTimer or CADisplayLink) and start fireing timer events
- (void) startGameLoopTimer;


	// stop the active timer and the gameloop
- (void) stopGameLoopTimer;


	// delegate for the timer event, calls the real drawing routine in the GameStateEngine
	// The GameStateEngine acts as a view
- (void) drawFrameContentLoop;


	// Selector is called from the game engine to signal that the game has somehow ended and
	// the timer should be stopped
- (void) returnFromGame;


	// Selector is called from the ManinMenuUIViewController if the game should be started
- (void) startNewGame;


	// Selector is called from the ManinMenuUIViewController if the game should be continued (from a saved gameStatus)
- (void) continueOldGame;





@end