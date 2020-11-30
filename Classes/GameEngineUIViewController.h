//
//  MainUIViewController.h
//  Jumpy
//
//  Created by Sven Putze on 25.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameEngineView.h"
#import "GameStatus.h"
#import "SoundEngine.h"
#import "GameStatus.h"


@interface GameEngineUIViewController : UIViewController {
    	
	GameEngineView *gameEngineView;
	SoundEngine *soundEngine;
	GameStatus *gameStatus;
	
	
}

@property (nonatomic,readonly) GameEngineView *gameEngineView;
@property (nonatomic,readonly) GameStatus *gameStatus;


	// Selector is the wanted init method
- (id) initWithSoundEngine: (SoundEngine*) aSoundEngine withGameStatus: (GameStatus*) aGameStatus;


	// Selector is called from the AppDelegate to get the game status from our "view" - GameStateEngine
- (GameStatus*) getGameStatusFromGameStateEngine;


	// Selector is called when the view should be dropped
- (void) unloadView;



@end
