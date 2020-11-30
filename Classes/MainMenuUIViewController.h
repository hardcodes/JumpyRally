//
//  MainMenuUIViewController.h
//  Jumpy
//
//  Created by Sven Putze on 04.07.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameStatus.h"


@interface MainMenuUIViewController : UIViewController {
    
	UILabel *labelStatus;
	UIButton *buttonContinueGame;
	UIView *viewHighScore;
	UILabel *labelHighScore;
	UILabel *labelHighScoreDate;
		// status of the game
	GameStatus *gameStatus;
		// stores information if the viewController has loaded a view into memory
	bool viewIsLoadedInmemory;
	
}
@property (nonatomic, retain) IBOutlet UILabel *labelStatus;
@property (nonatomic, retain) IBOutlet UIButton *buttonContinueGame;
@property (nonatomic, retain) IBOutlet UIView *viewHighScore;
@property (nonatomic, retain) IBOutlet UILabel *labelHighScore;
@property (nonatomic, retain) IBOutlet UILabel *labelHighScoreDate;
@property (nonatomic, retain, readwrite) GameStatus *gameStatus;
@property (nonatomic, readonly) bool viewIsLoadedInmemory;


- (IBAction)buttonNewGamePressed:(id)sender;
- (IBAction)buttonContinueGamePressed:(id)sender;



#pragma mark - gui control


	// Selector checks if the gameStatus is GAME_OVER or GAME_COMPLETE.
	// YES: the "continue old game" button is deactivated and hidden.
	// NO: the button is activated and shown.
- (void) setContinueButtonStatus;


	// Selector shows the highscore on the screen
- (void) showHighScore;

@end
