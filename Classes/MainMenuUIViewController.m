//
//  MainMenuUIViewController.m
//  Jumpy
//
//  Created by Sven Putze on 04.07.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "MainMenuUIViewController.h"
#import "MyGameAppDelegate.h"
#import "PersistanceHandler.h"


@implementation MainMenuUIViewController
@synthesize labelStatus;
@synthesize buttonContinueGame;
@synthesize viewHighScore;
@synthesize labelHighScore;
@synthesize labelHighScoreDate;
@synthesize gameStatus;
@synthesize viewIsLoadedInmemory;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[labelStatus setText: @""];
		viewIsLoadedInmemory = false;
    }
    return self;
}



- (void)dealloc
{
	if (gameStatus) [gameStatus release];
	[labelStatus release];
	[buttonContinueGame release];
    [viewHighScore release];
    [labelHighScore release];
    [labelHighScoreDate release];
    [super dealloc];
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	NSLog(@"MainMenuUIViewController.viewDidLoad");
	
	[self setContinueButtonStatus];
	[self showHighScore];
	viewIsLoadedInmemory = true;
	
    [super viewDidLoad];
}




- (void)viewDidUnload
{
	NSLog(@"MainMenuUIViewController.viewDidUnload");
	
	viewIsLoadedInmemory = false;
	[self setLabelStatus:nil];
	[self setButtonContinueGame:nil];
    [self setViewHighScore:nil];
    [self setLabelHighScore:nil];
    [self setLabelHighScoreDate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


#pragma mark - input control / IBAction


- (IBAction)buttonNewGamePressed:(id)sender {
		// load the view for the game and thus start the game
	[labelStatus setText: @"starting..."];
	[labelStatus setNeedsDisplay];

	MyGameAppDelegate *myGameAppDelegate = (MyGameAppDelegate *)[[UIApplication sharedApplication] delegate];
	[myGameAppDelegate startNewGame];
	
	
}

- (IBAction)buttonContinueGamePressed:(id)sender {
	
	[labelStatus setText: @"resuming..."];
	[labelStatus setNeedsDisplay];
	
	MyGameAppDelegate *myGameAppDelegate = (MyGameAppDelegate *)[[UIApplication sharedApplication] delegate];
	[myGameAppDelegate continueOldGame];
}


#pragma mark - gui control


- (void) setContinueButtonStatus{
	
	NSLog(@"setContinueButtonStatus");
	
	if(gameStatus){
			// faster, needed more then one time
		int tempGameState = [gameStatus gameState];
		
		NSLog(@"tempGameState: %i",tempGameState);
		
		if(
		   tempGameState!=GAME_OVER &&
		   tempGameState!=GAME_COMPLETE &&
		   tempGameState!=RETURNGAMEOVER&&
		   tempGameState!=PLAYER_DIED &&
		   tempGameState!=RETURNGAMECOMPLETE&&
		   [gameStatus levelNumber] >1
		   ){
			NSLog(@"show continue button");
			[buttonContinueGame setEnabled: TRUE];
			[buttonContinueGame setHidden: FALSE];
		}
		else{
			NSLog(@"no continue button");
			[buttonContinueGame setEnabled: FALSE];
			[buttonContinueGame setHidden: TRUE];
			
		}
		
	}
	else{
			// this should never happen
		NSLog(@"no gameStatus, hiding continue button");
		[buttonContinueGame setEnabled: FALSE];
		[buttonContinueGame setHidden: TRUE];
		
	}
		// mark button for redraw
	[buttonContinueGame setNeedsDisplay];
	
}


- (void) showHighScore{
	
	NSLog(@"showHighScore");
	
	if(gameStatus){
		
			// check if we have a new highscore
		if([gameStatus totalScore] > [gameStatus highScore]){
			
			[gameStatus setHighScore: [gameStatus totalScore]];
			[gameStatus setHighScoreDate: [NSDate date]];
			NSLog(@"new highscore: %i", [gameStatus highScore]);
				// save gameStatus to disk, so we have time/date for the new highscore persistant
			[PersistanceHandler archiveObject: gameStatus toNSDocumentDirectoryWithFileName: HCGameStatusFileName];
			MyGameAppDelegate *myGameAppDelegate = (MyGameAppDelegate *)[[UIApplication sharedApplication] delegate];
			[[myGameAppDelegate soundEngine] setGlobalSfxVolume: HCDefaultSoundVolume];
			[[myGameAppDelegate soundEngine] playSoundOfType: HIGHSCORESOUND at2DPosition: CGPointMake(HCmidScreenUIInterfaceOrientationLandscape, HCmaxY)];
		}
			// draw the highscore on the screen
		NSString *highScoreStr = [NSString stringWithFormat: @"highscore: %i", [gameStatus highScore]];
		[labelHighScore setText: highScoreStr];
		[labelHighScore setNeedsDisplay];
		
			//	[labelHighScore setText: highScoreStr];
		[labelHighScoreDate setText: [NSString stringWithFormat: @"%@", [NSDateFormatter localizedStringFromDate: [gameStatus highScoreDate]
																									   dateStyle: kCFDateFormatterMediumStyle
																									   timeStyle: kCFDateFormatterShortStyle]]];
		[labelHighScoreDate setNeedsDisplay];
			// label will not be set back to blank - why?
		[labelStatus setText: @""];
		[labelStatus setNeedsDisplay];
		[self.view layoutSubviews];

	}
	
}

@end
