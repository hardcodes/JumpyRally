//
//  MainUIViewController.m
//  Jumpy
//
//  Created by Sven Putze on 25.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "GameEngineUIViewController.h"
#import "MyGameAppDelegate.h"

@implementation GameEngineUIViewController

@synthesize gameEngineView;
@synthesize gameStatus;



- (id) init{
	
		// override standard init to prevent user from using this!
	[self dealloc];
	@throw [NSException exceptionWithName:@"HCBadInitCall" reason:@"You must use initWithSoundEngine: (SoundEngine*) aSoundEngine(...)" userInfo:nil];
	return nil;
}



- (id) initWithSoundEngine: (SoundEngine*) aSoundEngine
			withGameStatus: (GameStatus*) aGameStatus{
	
	self = [super init];
	if (self){
		
		soundEngine = [aSoundEngine retain];
		if(aGameStatus) gameStatus = [aGameStatus retain];
	}
	
	return self;
	
}


- (void)dealloc
{
	NSLog(@"START dealloc: GameEngineUIViewController");
	if(gameEngineView){
		[gameEngineView release];
		gameEngineView = nil;
	}
	if([self view]) {
			//[[self view] release];
		[self setView:nil];
	}
	[soundEngine release];
	if(gameStatus) [gameStatus release];
    [super dealloc];
	NSLog(@"END dealloc: GameEngineUIViewController");
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle 


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView

{
	gameEngineView = [[GameEngineView alloc] initWithFrame: [UIScreen mainScreen].applicationFrame];
	[gameEngineView setSoundEngine: soundEngine];
	if(gameStatus) [gameEngineView setGameStatus: gameStatus];

}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	gameEngineView.backgroundColor = [UIColor grayColor];
	[gameEngineView setupEAGL];
	
	[self setView:gameEngineView];
	[gameEngineView release];
    
	[super viewDidLoad];
}



- (void) unloadView{
	
	NSLog(@"START unloadView");

	[self setView:nil];
	[self viewDidUnload];
	NSLog(@"END unloadView");
}



- (void)viewDidUnload
{
		
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	gameEngineView = nil;
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		// tell the gamestateengine that an orientation change occurred
	[[gameEngineView gameStateEngine] setInterfaceOrientation: interfaceOrientation];
	[[gameEngineView gameStateEngine] setOrientationDidChange: true];
		// iOS should not autorotate our content, we must do that for ourselfs.
	
	return NO;
}



- (GameStatus*) getGameStatusFromGameStateEngine{
	
	GameStatus *returnGameStatus = [[gameEngineView gameStateEngine] gameStatus];
	return returnGameStatus;
}




@end
