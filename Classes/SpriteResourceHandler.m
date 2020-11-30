//
//  SpriteResourceHandler.m
//  Jumpy
//
//  Created by Sven Putze on 15.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "SpriteResourceHandler.h"
#import "GameStateEngine.h"
#import "LevelResourceHandler.h"
#import "SoundEngine.h"
#import "GameStatus.h"

	// animation sequence for JumpySprite, 1st entry = count of frame-ids
static int jumpyAnimationSequence[73]={72,0,1,2,1,0,1,2,1,0,5,6,7,6,5,0,5,6,7,6,5,0,5,6,7,6,5,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,5,6,7,6,5,0,5,6,7,6,5,4,4,0,0,0,5,6,7,6,5,0};
	// animationsequence for dying jumpy
static int jumpyDieAnimationSequence[9]={8,0,1,2,3,4,5,6,7};
	// animationsequence for dead jumpy
static int jumpyDeadAnimationSequence[5]={4,2,0,1,0};
	// animationsequence for goldcoins
static int goldCoinAnimationSequence[108]={107,0,1,2,1,0,0,0,0,0,0,0,0,3,4,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,6,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0};
	// animationsequence for fire/flame
static int fireAnimationSequence[25]={24,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7};
	// animationsequence for keys
static int keyAnimationSequence[2]={1,0};
	// animationsequence for doors
static int doorAnimationSequence[2]={1,0};
	// animationsequence for bomb
static int bombAnimationSequence[2]={1,0};
	// animationsequence for bomb
static int woodBoxAnimationSequence[2]={1,0};
	// animationsequence for rock
static int rockAnimationSequence[2]={1,0};
	// animationsequence for bat
static int batAnimationSequence[7]={6,0,1,2,3,2,1};
	// animationsequence for bee
static int beeAnimationSequence[3]={2,0,1};
	// animationsequence for bug
static int bugAnimationSequence[7]={6,0,1,2,3,2,1};
	// animationsequence for skull
static int skullAnimationSequence[7]={6,0,1,2,3,2,1};
	// animationsequence for eye
static int eyeAnimationSequence[13]={12,8,8,8,8,0,1,2,3,4,5,6,7};
	// animationsequence for 10 points
static int points10AnimationSequence[2]={1,0};
	// animationsequence for 20 points
static int points20AnimationSequence[2]={1,0};
	// animationsequence for 50 points
static int points50AnimationSequence[2]={1,0};
	// animationsequence for smoke
static int smokeAnimationSequence[9]={8,0,1,2,3,4,5,6,7};
	// animationsequence for sparkle
static int sparkleAnimationSequence[16]={15,0,1,2,3,4,5,6,7,6,5,4,3,2,1,0};
	// animationsequence for explosion
static int explosionAnimationSequence[9]={8,0,1,2,3,4,5,6,7};
	// animationsequence for bombtimer
static int bombTimerAnimationSequence[9]={8,0,1,2,3,4,5,6,7};
	// animationsequence for first aid kit
static int firstAidAnimationSequence[2]={1,0};
	// animationsequence of the special score sprite
static int scoreAnimationSequence[11]={10,0,1,2,3,4,5,6,7,8,9};
	// animationsequence for bombtimer
static int standardDieAnimationSequence[9]={8,0,1,2,3,4,5,6,7};
	// animationsequence for pointing hand
static int standardPointingHandAnimationSequence[41]={40,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,1,2,3,4,5,6,2,1,0};
	// animationsequence for countdown
static int countdownSequence[5]={4,0,1,2,3};
	// animationsdquence for big dragon
static int bigdragonSequence[9]={8,0,1,2,3,4,5,6,7};



@implementation SpriteResourceHandler


@synthesize resourceDictionary;
@synthesize jumpySprite;
@synthesize healthStatusBar;
@synthesize scoreSprite;
@synthesize keyRedSprite;
@synthesize keyBlueSprite;
@synthesize keyGoldSprite;
@synthesize spritesArray;
@synthesize createdSpritesArray;
@synthesize destroyableSpritesArray;
@synthesize jumpyStartPosition;
@synthesize soundEngine;


#pragma mark  - Init & Loading




- (id) initWithGameStateEngine: (GameStateEngine *)aGameStateEngine
	  withLevelResourceHandler: (LevelResourceHandler*) aLevelResourceHandler
			   withSoundEngine: (SoundEngine*) aSoundEngine{
	
	self = [super init];
	
	if (self) {
		
			// weak reference
		gameStateEngine = aGameStateEngine;
		levelResourceHandler = [aLevelResourceHandler retain];
		soundEngine = [aSoundEngine retain];
	}
	
	return self;
}



- (id)init{
		// override standard init to prevent user from using this!
	[self dealloc];
	@throw [NSException exceptionWithName:@"HCBadInitCall" reason:@"You must use initWithGameStateEngine: (GameStateEngine *)aGameStateEngine(...)" userInfo:nil];
	return nil;
}



- (void) dealloc {
	
#if DEBUG
	NSLog(@"START dealloc: SpriteResourceHandler");
#endif
	
	[spritesArray release];
	[createdSpritesArray release];
	[destroyableSpritesArray release];
	[keyBlueSprite release];
	[keyGoldSprite release];
	[keyRedSprite release];
	[jumpySprite release];
	[healthStatusBar release];
	[scoreSprite release];
	[levelResourceHandler release];
	[soundEngine release];
	[resourceDictionary release];
	
	[super dealloc];
	
#if DEBUG
	NSLog(@"END dealloc: SpriteResourceHandler");
#endif
}


- (void) preloader{
	
	resourceDictionary = [[NSMutableDictionary alloc] initWithCapacity:HCInitialArraySize];
	spritesArray = [[NSMutableArray alloc] initWithCapacity:HCInitialArraySize];
	createdSpritesArray = [[NSMutableArray alloc] initWithCapacity:HCInitialArraySize];
	destroyableSpritesArray = [[NSMutableArray alloc] initWithCapacity:HCInitialArraySize];
		// preload EAGL-textures
		// 1st call loads the texture in our resource array
		// this way sprites will have a faster access
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: JUMPY]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: JUMPYDIE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: COIN]];	
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: KEYBLUE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: KEYGOLD]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: KEYRED]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: FIRE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: BAT]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: BEE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: BUG]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: SKULL]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: EYE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: DOORBLUE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: HUDSCORE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: DOORRED]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: ROCK]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: BOMB]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: WOODBOX]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: TENPOINTS]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: TWENTYPOINTS]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: FIFTYPOINTS]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: JUMPYANGEL]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: EXPLOSION]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: SMOKE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: SPARKLE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: SPARKLERED]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: BOMBTIMER]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: STANDARDDIE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: ONESEQUENCESPRITE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: TWOSEQUENCESPRITE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: THREESEQUENCESPRITE]];
	[self getSpriteTextureFromDictionaryForImage: [self getNameForTypeOfSprite: GOSEQUENCESPRITE]];


	[levelResourceHandler getTextureFromDictionaryForImage: @"progressbar.png"];
	
		// init special sprite
	healthStatusBar = [[HealthStatusBar alloc] initWithImage: @"progressbar.png"
										   atCurrentPosition:CGPointMake(32.0, -1.0)
											 andHealthStatus: [[gameStateEngine gameStatus] healthStatus]
									withLevelResourceHandler: levelResourceHandler];
	

		// load the sprites for displaying the inventory in the HUD
	
	keyBlueSprite = [[KeyBlueSprite alloc] initWithImage: [self getNameForTypeOfSprite: KEYBLUE] 
											  frameCount: 1
											   frameStep: 1
										   movementDelta: CGPointMake(0,0)
										 currentPosition: CGPointMake(200,0)
								   withAnimationSequence: keyAnimationSequence
						withAnimationSequenceIndexOffset: 0
												  ofType: KEYBLUE
									 withGameStateEngine: gameStateEngine
							   withSpriteResourceHandler: self]; 
	
	keyGoldSprite = [[KeyGoldSprite alloc] initWithImage: [self getNameForTypeOfSprite: KEYGOLD] 
											  frameCount: 1
											   frameStep: 1
										   movementDelta: CGPointMake(0,0)
										 currentPosition: CGPointMake(216,0)
								   withAnimationSequence: keyAnimationSequence
						withAnimationSequenceIndexOffset: 0
												  ofType: KEYGOLD
									 withGameStateEngine: gameStateEngine
							   withSpriteResourceHandler: self]; 
	
	keyRedSprite = [[KeyRedSprite alloc] initWithImage: [self getNameForTypeOfSprite: KEYRED] 
											frameCount: 1
											 frameStep: 1
										 movementDelta: CGPointMake(0,0)
									   currentPosition: CGPointMake(232,0)
								 withAnimationSequence: keyAnimationSequence
					  withAnimationSequenceIndexOffset: 0
												ofType: KEYRED
								   withGameStateEngine: gameStateEngine
							 withSpriteResourceHandler: self]; 
	
		// load sprite for displaying the score in the HUD.
	scoreSprite = [[ScoreSprite alloc] initWithImage: [self getNameForTypeOfSprite: HUDSCORE]
										  frameCount: 16
										   frameStep: 1
									   movementDelta: CGPointMake(0,0)
									 currentPosition: CGPointMake(280,-1.0)
							   withAnimationSequence: scoreAnimationSequence
					withAnimationSequenceIndexOffset: 0
											  ofType: SCORE
								 withGameStateEngine: gameStateEngine
						   withSpriteResourceHandler: self];

	
}


#pragma mark - helper

- (NSString*) getNameForTypeOfSprite: (int) aTypeOfSprite{
	
	NSString* nameOfSprite;
	
	switch(aTypeOfSprite){
			
		case JUMPY:
			nameOfSprite = @"jumpy-sequence.png";
			break;
			
		case COIN:
			nameOfSprite = @"goldcoin-sequence.png";
			break;
			
		case KEYBLUE:
			nameOfSprite = @"key-blue.png";
			break;
			
		case KEYGOLD:
			nameOfSprite = @"key-gold.png";
			break;
			
		case KEYRED:
			nameOfSprite = @"key-red.png";
			break;
			
		case FIRE:
			nameOfSprite = @"fire-sequence.png";
			break;
			
		case BAT:
			nameOfSprite = @"bat-sequence.png";
			break;
			
		case BEE:
			nameOfSprite = @"bee-sequence.png";
			break;
			
			
		case BUG:
			nameOfSprite = @"bug-sequence.png";
			break;
			
		case SKULL:
			nameOfSprite = @"skull-sequence.png";
			break;
			
			
		case EYE:
			nameOfSprite = @"eye-sequence.png";
			break;
			
		case DOORBLUE:
			nameOfSprite = @"door-blue.png";
			break;
			
		case DOORGOLD:
			nameOfSprite = @"door-gold.png";
			break;
			
		case DOORRED:
			nameOfSprite = @"door-red.png";
			break;
			
		case ROCK:
			nameOfSprite = @"rock.png";
			break;
			
		case BOMB:
			nameOfSprite = @"bomb.png";
			break;
			
		case WOODBOX:
			nameOfSprite = @"woodbox.png";
			break;
			
		case TENPOINTS:
			nameOfSprite = @"10-points.png";
			break;
			
		case TWENTYPOINTS:
			nameOfSprite = @"20-points.png";
			break;
			
		case FIFTYPOINTS:
			nameOfSprite = @"50-points.png";
			break;
			
		case SMOKE:
			nameOfSprite = @"smoke-sequence.png";
			break;
			
		case SPARKLE:
			nameOfSprite = @"sparkle-sequence.png";
			break;
			
		case SPARKLERED:
			nameOfSprite = @"sparkle-sequence-red.png";
			break;
			
		case JUMPYDIE:
			nameOfSprite = @"jumpy-die-sequence.png";
			break;
			
		case JUMPYANGEL:
			nameOfSprite = @"jumpy-die-sequence-02.png";
			break;
			
		case EXPLOSION:
			nameOfSprite = @"explosion-sequence.png";
			break;
			
		case BOMBTIMER:
			nameOfSprite = @"timer-sequence.png";
			break;
			
		case FIRSTAID:
			nameOfSprite = @"first-aid.png";
			break;
			
		case STANDARDDIE:
			nameOfSprite = @"sprite-die-sequence.png";
			break;
			
		case GAMEOVER:
			nameOfSprite = @"GameOverLogo-256x256.png";
			break;
			
		case HUDSCORE:
			nameOfSprite = @"0-9-gold.png";
			break;
			
		case LEVELCOMPLETESPRITE:
			nameOfSprite = @"NextLevelLogo-256x256.png";
			break;
			
		case POINTINGHANDSPRITE:
			nameOfSprite = @"pointing-hand-sequence.png";
			break;
			
		case GAMECOMPLETESPRITE:
			nameOfSprite = @"GameComplete-256x256.png";
			break;
			
		case HANDLINGSPRITE:
			nameOfSprite = @"handling.png";
			break;
			
		case ONESEQUENCESPRITE:
			nameOfSprite = @"one-sequence.png";
			break;
			
		case TWOSEQUENCESPRITE:
			nameOfSprite = @"two-sequence.png";
			break;
			
		case THREESEQUENCESPRITE:
			nameOfSprite = @"three-sequence.png";
			break;
			
		case GOSEQUENCESPRITE:
			nameOfSprite = @"go-sequence.png";
			break;
			
		case BIGDRAGONSPRITE:
			nameOfSprite = @"dragon-sequence.png";
			break;
			
		default:
			nameOfSprite = @"unknown";
			NSLog(@"ERROR: unknown type of sprite: %i",  aTypeOfSprite);
			
	}
	
	return nameOfSprite;
}



- (void) createSpriteOfType: (int) aTypeOfSprite
			   atPosition: (CGPoint) aPosition {
	
		// default movement delta = still
	CGPoint deltaXY	= CGPointMake(0.0, 0.0);
	
	if (aTypeOfSprite == JUMPY) { 
		
			// png has actually 24 frames but it must be power of 2!
		if(jumpySprite) [jumpySprite release];
		jumpySprite = nil;
		jumpySprite = [[JumpySprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
											  frameCount: 32
											   frameStep: 4
										   movementDelta: deltaXY
										 currentPosition: aPosition
								   withAnimationSequence: jumpyAnimationSequence
						withAnimationSequenceIndexOffset: 0
												  ofType: aTypeOfSprite
									 withGameStateEngine: gameStateEngine
							   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: jumpySprite];
		
			//[jumpySprite release]; 
		return;
	}
	if (aTypeOfSprite == COIN) { 
		
		GoldCoinSprite *sprite = [[GoldCoinSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 8
															 frameStep: 8
														 movementDelta: deltaXY
													   currentPosition: aPosition
												 withAnimationSequence: goldCoinAnimationSequence
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
												   withGameStateEngine: gameStateEngine
											 withSpriteResourceHandler: self];
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == KEYBLUE) { 
		
		KeyBlueSprite *sprite = [[KeyBlueSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
														  frameCount: 1
														   frameStep: 1
													   movementDelta: CGPointMake(0.0, -4.0)
													 currentPosition: aPosition
											   withAnimationSequence: keyAnimationSequence
									withAnimationSequenceIndexOffset: 0
															  ofType: aTypeOfSprite
												 withGameStateEngine: gameStateEngine
										   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == KEYGOLD) { 
		
		KeyGoldSprite *sprite = [[KeyGoldSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
														  frameCount: 1
														   frameStep: 1
													   movementDelta: CGPointMake(0.0, -4.0)
													 currentPosition: aPosition
											   withAnimationSequence: keyAnimationSequence
									withAnimationSequenceIndexOffset: 0
															  ofType: aTypeOfSprite
												 withGameStateEngine: gameStateEngine
										   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == KEYRED) { 
		
		KeyRedSprite *sprite = [[KeyRedSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
														frameCount: 1
														 frameStep: 1
													 movementDelta: CGPointMake(0.0, -4.0)
												   currentPosition: aPosition
											 withAnimationSequence: keyAnimationSequence
								  withAnimationSequenceIndexOffset: 0
															ofType: aTypeOfSprite
											   withGameStateEngine: gameStateEngine
										 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == FIRE) { 
		
		FireSprite *sprite = [[FireSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
													frameCount: 8
													 frameStep: 5
												 movementDelta: deltaXY
											   currentPosition: aPosition
										 withAnimationSequence: fireAnimationSequence
							  withAnimationSequenceIndexOffset: 0
														ofType: aTypeOfSprite
										   withGameStateEngine: gameStateEngine
									 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == ENDLESSFIRE) { 
		
		FireSprite *sprite = [[FireSprite alloc] initWithImage: [self getNameForTypeOfSprite: FIRE] 
													frameCount: 8
													 frameStep: 5
												 movementDelta: deltaXY
											   currentPosition: aPosition
										 withAnimationSequence: fireAnimationSequence
							  withAnimationSequenceIndexOffset: 0
														ofType: FIRE
										   withGameStateEngine: gameStateEngine
									 withSpriteResourceHandler: self];
		[sprite setAutoDestroy: false];
		[createdSpritesArray addObject: sprite];

		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == BAT) { 
		
		BatSprite *sprite = [[BatSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
												  frameCount: 4
												   frameStep: 2
											   movementDelta: CGPointMake(3,3)
											 currentPosition: aPosition
									   withAnimationSequence: batAnimationSequence
							withAnimationSequenceIndexOffset: 0
													  ofType: aTypeOfSprite
										 withGameStateEngine: gameStateEngine
								   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == BEE) { 
		
		BeeSprite *sprite = [[BeeSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
												  frameCount: 4
												   frameStep: 1
											   movementDelta: deltaXY
											 currentPosition: aPosition
									   withAnimationSequence: beeAnimationSequence
							withAnimationSequenceIndexOffset: 0
													  ofType: aTypeOfSprite
										 withGameStateEngine: gameStateEngine
								   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == BUG) { 
		
		BugSprite *sprite = [[BugSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
												  frameCount: 4
												   frameStep: 5
											   movementDelta: deltaXY
											 currentPosition: aPosition
									   withAnimationSequence: bugAnimationSequence
							withAnimationSequenceIndexOffset: 0
													  ofType: aTypeOfSprite
										 withGameStateEngine: gameStateEngine
								   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == SKULL) { 
		
		SkullSprite *sprite = [[SkullSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
													  frameCount: 4
													   frameStep: 3
												   movementDelta: CGPointMake(0,HCSkullMove)
												 currentPosition: aPosition
										   withAnimationSequence: skullAnimationSequence
								withAnimationSequenceIndexOffset: 0
														  ofType: aTypeOfSprite
											 withGameStateEngine: gameStateEngine
									   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == EYE) { 
		
		EyeSprite *sprite = [[EyeSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
												  frameCount: 16
												   frameStep: 6
											   movementDelta: CGPointMake(HCEyeMove,0)
											 currentPosition: aPosition
									   withAnimationSequence: eyeAnimationSequence
							withAnimationSequenceIndexOffset: 0
													  ofType: aTypeOfSprite
										 withGameStateEngine: gameStateEngine
								   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == DOORBLUE) { 
		
		DoorBlueSprite *sprite = [[DoorBlueSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 1
															 frameStep: 1
														 movementDelta: deltaXY
													   currentPosition: aPosition
												 withAnimationSequence: doorAnimationSequence
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
												   withGameStateEngine: gameStateEngine
											 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == DOORGOLD) { 
		
		DoorGoldSprite *sprite = [[DoorGoldSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 1
															 frameStep: 1
														 movementDelta: deltaXY
													   currentPosition: aPosition
												 withAnimationSequence: doorAnimationSequence
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
												   withGameStateEngine: gameStateEngine
											 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == DOORRED) { 
		
		DoorRedSprite *sprite = [[DoorRedSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
														  frameCount: 1
														   frameStep: 1
													   movementDelta: deltaXY
													 currentPosition: aPosition
											   withAnimationSequence: doorAnimationSequence
									withAnimationSequenceIndexOffset: 0
															  ofType: aTypeOfSprite
												 withGameStateEngine: gameStateEngine
										   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == ROCK) { 
		
		RockSprite *sprite = [[RockSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
													frameCount: 1
													 frameStep: 1
												 movementDelta: deltaXY
											   currentPosition: aPosition
										 withAnimationSequence: rockAnimationSequence
							  withAnimationSequenceIndexOffset: 0
														ofType: aTypeOfSprite
										   withGameStateEngine: gameStateEngine
									 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == BOMB) { 
		
		BombSprite *sprite = [[BombSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
													frameCount: 1
													 frameStep: 1
												 movementDelta: deltaXY
											   currentPosition: aPosition
										 withAnimationSequence: bombAnimationSequence
							  withAnimationSequenceIndexOffset: 0
														ofType: aTypeOfSprite
										   withGameStateEngine: gameStateEngine
									 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == WOODBOX) { 
		
		WoodBoxSprite *sprite = [[WoodBoxSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
														  frameCount: 1
														   frameStep: 1
													   movementDelta: deltaXY
													 currentPosition: aPosition
											   withAnimationSequence: woodBoxAnimationSequence
									withAnimationSequenceIndexOffset: 0
															  ofType: aTypeOfSprite
												 withGameStateEngine: gameStateEngine
										   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == TENPOINTS) { 
		
		Points10Sprite *sprite = [[Points10Sprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 1
															 frameStep: 1
														 movementDelta: CGPointMake(0.0, -HCPoints10SpriteSpeed)
													   currentPosition: aPosition
												 withAnimationSequence: points10AnimationSequence
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
												   withGameStateEngine: gameStateEngine
											 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == TWENTYPOINTS) { 
		
		Points20Sprite *sprite = [[Points20Sprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 1
															 frameStep: 1
														 movementDelta: CGPointMake(0.0, -HCPoints20SpriteSpeed)
													   currentPosition: aPosition
												 withAnimationSequence: points20AnimationSequence
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
												   withGameStateEngine: gameStateEngine
											 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == FIFTYPOINTS) { 
		
		Points50Sprite *sprite = [[Points50Sprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 1
															 frameStep: 1
														 movementDelta: CGPointMake(-1.0, -HCPoints50SpriteSpeed)
													   currentPosition: aPosition
												 withAnimationSequence: points50AnimationSequence
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
												   withGameStateEngine: gameStateEngine
											 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == SMOKE) { 
		
		SmokeSprite *sprite = [[SmokeSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
													  frameCount: 8
													   frameStep: 1
												   movementDelta: deltaXY
												 currentPosition: aPosition
										   withAnimationSequence: smokeAnimationSequence
								withAnimationSequenceIndexOffset: 0
														  ofType: aTypeOfSprite
											 withGameStateEngine: gameStateEngine
									   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == SPARKLE) { 
		
		SparkleSprite *sprite = [[SparkleSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
														  frameCount: 8
														   frameStep: 3
													   movementDelta: deltaXY
													 currentPosition: aPosition
											   withAnimationSequence: sparkleAnimationSequence
									withAnimationSequenceIndexOffset: 0
															  ofType: aTypeOfSprite
												 withGameStateEngine: gameStateEngine
										   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == SPARKLERED) { 
		
		SparkleSprite *sprite = [[SparkleSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
														  frameCount: 8
														   frameStep: 1
													   movementDelta: deltaXY
													 currentPosition: aPosition
											   withAnimationSequence: sparkleAnimationSequence
									withAnimationSequenceIndexOffset: 0
															  ofType: aTypeOfSprite
												 withGameStateEngine: gameStateEngine
										   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == JUMPYDIE) { 
		
		JumpyDieSprite *sprite = [[JumpyDieSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 8
															 frameStep: 3
														 movementDelta: deltaXY
													   currentPosition: aPosition
												 withAnimationSequence: jumpyDieAnimationSequence
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
												   withGameStateEngine: gameStateEngine
											 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == JUMPYANGEL) { 
		
		JumpyAngelSprite *sprite = [[JumpyAngelSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
																frameCount: 4
																 frameStep: 1
															 movementDelta: CGPointMake(0.0, -HCJumpyAngelSpriteSpeed)
														   currentPosition: aPosition
													 withAnimationSequence: jumpyDeadAnimationSequence
										  withAnimationSequenceIndexOffset: 0
																	ofType: aTypeOfSprite
													   withGameStateEngine: gameStateEngine
												 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == EXPLOSION) { 
		
		ExplosionSprite *sprite = [[ExplosionSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															  frameCount: 8
															   frameStep: 2
														   movementDelta: deltaXY
														 currentPosition: aPosition
												   withAnimationSequence: explosionAnimationSequence
										withAnimationSequenceIndexOffset: 0
																  ofType: aTypeOfSprite
													 withGameStateEngine: gameStateEngine
											   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == BOMBTIMER) { 
		
		BombTimerSprite *sprite = [[BombTimerSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															  frameCount: 8
															   frameStep: HCBombTimerFrameStep
														   movementDelta: deltaXY
														 currentPosition: aPosition
												   withAnimationSequence: bombTimerAnimationSequence
										withAnimationSequenceIndexOffset: 0
																  ofType: aTypeOfSprite
													 withGameStateEngine: gameStateEngine
											   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == FIRSTAID) { 
		
		FirstAidSprite *sprite = [[FirstAidSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 1
															 frameStep: 1
														 movementDelta: deltaXY
													   currentPosition: aPosition
												 withAnimationSequence: firstAidAnimationSequence
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
												   withGameStateEngine: gameStateEngine
											 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == STANDARDDIE) { 
		
		StandardDieSprite *sprite = [[StandardDieSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
																  frameCount: 8
																   frameStep: 1
															   movementDelta: deltaXY
															 currentPosition: aPosition
													   withAnimationSequence: standardDieAnimationSequence
											withAnimationSequenceIndexOffset: 0
																	  ofType: aTypeOfSprite
														 withGameStateEngine: gameStateEngine
												   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == GAMEOVER) { 
		
		GameOverSprite *sprite = [[GameOverSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 1
															 frameStep: 0
														 movementDelta: deltaXY
													   currentPosition: aPosition
												 withAnimationSequence: nil
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
												   withGameStateEngine: gameStateEngine
											 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == LEVELCOMPLETESPRITE) { 
		
		LevelCompleteSprite *sprite = [[LevelCompleteSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 1
															 frameStep: 0
														 movementDelta: deltaXY
													   currentPosition: aPosition
												 withAnimationSequence: nil
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
															 withGameStateEngine: gameStateEngine
													   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == GAMECOMPLETESPRITE) { 
		
		GameCompleteSprite *sprite = [[GameCompleteSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
																	  frameCount: 1
																	   frameStep: 0
																   movementDelta: deltaXY
																 currentPosition: aPosition
														   withAnimationSequence: nil
												withAnimationSequenceIndexOffset: 0
																		  ofType: aTypeOfSprite
														   withGameStateEngine: gameStateEngine
													 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == POINTINGHANDSPRITE) { 
		
		PointingHandSprite *sprite = [[PointingHandSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
																	  frameCount: 8
																	   frameStep: 2
																   movementDelta: deltaXY
																 currentPosition: aPosition
														   withAnimationSequence: standardPointingHandAnimationSequence
												withAnimationSequenceIndexOffset: 0
																		  ofType: aTypeOfSprite
														   withGameStateEngine: gameStateEngine
													 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == HANDLINGSPRITE) { 
		
		HandlingSprite *sprite = [[HandlingSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
																	frameCount: 1
																	 frameStep: 0
																 movementDelta: deltaXY
															   currentPosition: aPosition
														 withAnimationSequence: nil
											  withAnimationSequenceIndexOffset: 0
																		ofType: aTypeOfSprite
														   withGameStateEngine: gameStateEngine
													 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == ONESEQUENCESPRITE) { 
		
		OneCountDownSprite *sprite = [[OneCountDownSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
															frameCount: 4
															 frameStep: HCCountDownFrameStep
														 movementDelta: deltaXY
													   currentPosition: aPosition
												 withAnimationSequence: countdownSequence
									  withAnimationSequenceIndexOffset: 0
																ofType: aTypeOfSprite
												   withGameStateEngine: gameStateEngine
											 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == TWOSEQUENCESPRITE) { 
		
		TwoCountDownSprite *sprite = [[TwoCountDownSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
																	frameCount: 4
																	 frameStep: HCCountDownFrameStep
																 movementDelta: deltaXY
															   currentPosition: aPosition
														 withAnimationSequence: countdownSequence
											  withAnimationSequenceIndexOffset: 0
																		ofType: aTypeOfSprite
														   withGameStateEngine: gameStateEngine
													 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == THREESEQUENCESPRITE) { 
		
		ThreeCountDownSprite *sprite = [[ThreeCountDownSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
																	frameCount: 4
																	 frameStep: HCCountDownFrameStep
																 movementDelta: deltaXY
															   currentPosition: aPosition
														 withAnimationSequence: countdownSequence
											  withAnimationSequenceIndexOffset: 0
																		ofType: aTypeOfSprite
														   withGameStateEngine: gameStateEngine
													 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == GOSEQUENCESPRITE) { 
		
		GoCountDownSprite *sprite = [[GoCountDownSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
																	frameCount: 4
																	 frameStep: HCCountDownFrameStep
																 movementDelta: deltaXY
															   currentPosition: aPosition
														 withAnimationSequence: countdownSequence
											  withAnimationSequenceIndexOffset: 0
																		ofType: aTypeOfSprite
														   withGameStateEngine: gameStateEngine
													 withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	if (aTypeOfSprite == BIGDRAGONSPRITE) { 
		
		BigDragonSprite *sprite = [[BigDragonSprite alloc] initWithImage: [self getNameForTypeOfSprite: aTypeOfSprite] 
																  frameCount: 8
																   frameStep: 0
															   movementDelta: deltaXY
															 currentPosition: aPosition
													   withAnimationSequence: bigdragonSequence
											withAnimationSequenceIndexOffset: 0
																	  ofType: aTypeOfSprite
														 withGameStateEngine: gameStateEngine
												   withSpriteResourceHandler: self]; 
		[createdSpritesArray addObject: sprite];
		[sprite release]; 
		return;
	}
	else {
		NSLog(@"ERROR: unkown type of sprite: %i", aTypeOfSprite); 
		return;
	} 
}



- (void) createSpritesFromTileMap {
	
#if DEBUG
	NSLog(@"START createSpritesFromTileMap");
#endif
		// clear arrays, new level = new sprites
	[spritesArray removeAllObjects];
	[createdSpritesArray removeAllObjects];
	[destroyableSpritesArray removeAllObjects];
	
	Layer *spriteLayer = [[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"];
	
	[gameStateEngine setCoinsInLevel: 0];
		// walk vertical
	for(int yCoordinate=0;yCoordinate < [spriteLayer layerHeight];++yCoordinate){
			// walk horizontal
		for(int xCoordinate=0;xCoordinate < [spriteLayer layerWidth];++xCoordinate){
			
			int spriteGid = [spriteLayer getTileGIdAtXCoordinate:xCoordinate AndYCoordinate:yCoordinate];
			CGPoint spritePosition = CGPointMake( xCoordinate * HCTileInnerSize, yCoordinate * HCTileInnerSize);
			
			switch (spriteGid - HCFirstSpriteGID + 1) {
					
				case 1:
						// JumpySprite = player
					[self createSpriteOfType: JUMPY atPosition: spritePosition];
						// remember start position to beam sprite back if asked by user
					jumpyStartPosition = spritePosition;
					break;
					
				case 2:
					[self createSpriteOfType: COIN atPosition: spritePosition];
					[gameStateEngine IncreaseCoinsInLevel: 1];
					break;
					
				case 3:
					[self createSpriteOfType: KEYBLUE atPosition: spritePosition];
					break;
					
				case 4:
					[self createSpriteOfType: KEYGOLD atPosition: spritePosition];
					break;
					
				case 5:
					[self createSpriteOfType: KEYRED atPosition: spritePosition];
					break;
					
				case 6:
					[self createSpriteOfType: DOORBLUE atPosition: spritePosition];
					break;
					
				case 7:
					[self createSpriteOfType: DOORGOLD atPosition: spritePosition];
					break;
					
				case 8:
					[self createSpriteOfType: DOORRED atPosition: spritePosition];
					break;
					
				case 9:
					[self createSpriteOfType: WOODBOX atPosition: spritePosition];
					break;
					
				case 10:
					[self createSpriteOfType: BOMB atPosition: spritePosition];
					break;
					
				case 11:
					[self createSpriteOfType: ROCK atPosition: spritePosition];
					break;
					
				case 12:
					[self createSpriteOfType: ENDLESSFIRE atPosition: spritePosition];
					break;
					
				case 13:
					[self createSpriteOfType: BAT atPosition: spritePosition];
					break;
					
				case 15:
					[self createSpriteOfType: BEE atPosition: spritePosition];
					break;
					
				case 16:
					[self createSpriteOfType: BUG atPosition: spritePosition];
					break;
					
				case 17:
					[self createSpriteOfType: EYE atPosition: spritePosition];
					break;
					
				case 18:
					[self createSpriteOfType: SKULL  atPosition: spritePosition];
					break;
					
				case 19:
					[self createSpriteOfType: FIRSTAID  atPosition: spritePosition];
					break;
					
				case 20:
					[self createSpriteOfType: HANDLINGSPRITE  atPosition: spritePosition];
					break;
					
				case 21:
					[self createSpriteOfType: BIGDRAGONSPRITE  atPosition: spritePosition];
					break;
					
				default:
					break;
					
			}
		}
	}
	
#if DEBUG
	NSLog(@"END createSpritesFromTileMap");
#endif
	
}




#pragma mark - resourceDictionary


- (SpriteTexture *) getSpriteTextureFromDictionaryForImage: (NSString*) aImageName {
	
		// Is the same texture already in our dictionary?
	SpriteTexture *spriteTexture = [resourceDictionary objectForKey: aImageName];
	if (!spriteTexture) {
		
			// No, so create one...
#if DEBUG
		NSLog(@"%@ is new to resourceDictionary", aImageName);
#endif
		spriteTexture = [[SpriteTexture alloc] initWithImageName: aImageName];
		
			// add the created texture to our dictionary.
		[resourceDictionary setObject: spriteTexture forKey: aImageName];
#if DEBUG
	NSLog(@"%@ is stored as texture in resourceDictionary", aImageName);
#endif
		[spriteTexture autorelease]; 
	}
	return spriteTexture;
}



- (void) checkCollisionsForSprite: (Sprite *) sprite {
	
	
#pragma mark - jumpy collision control
	
		// Objective-C does not allow to create new objects inside switch/case statements
		// So here are some if/else cascades
	if ([sprite typeOfSprite] == JUMPY) {
		
		for (Sprite *spriteToCheck in spritesArray) {
				// dir player collide with other sprite?
			if ([spriteToCheck typeOfSprite] != JUMPY && [sprite hasCollidedWithSprite: spriteToCheck]){
				
					// handle all deadly events
				if([spriteToCheck isLethal]){
					
					int tempHealthStatus = [healthStatusBar healthStatus];
					

						// bombs are more fatal
					if ([spriteToCheck typeOfSprite]==EXPLOSION) tempHealthStatus -= HCDecreaseBombHealth;
					else tempHealthStatus -= HCDecreaseHealth;
					[soundEngine playSoundOfType: JUMPYHURTSOUND at2DPosition: [spriteToCheck currentPosition]];
					
					
						// store new value for health in the statusbar
					[healthStatusBar setHealthStatus: tempHealthStatus];
						// store new value for health in the game status class
					[[gameStateEngine gameStatus] setHealthStatus: tempHealthStatus];
					if(tempHealthStatus<=0){
						
						if(HCCheat==YES){
							[healthStatusBar setHealthStatus: HCDefaultHealth];
						}
						else{
								// health is completely gone, player dies
							[self createSpriteOfType: JUMPYDIE atPosition: [jumpySprite currentPosition]];
							[[gameStateEngine gameStatus]  setGameState: PLAYER_DIED];
							[jumpySprite setIsActive: false];
							[soundEngine stopAllSounds];
							[soundEngine playSoundOfType: JUMPYDIESOUND at2DPosition: [jumpySprite currentPosition]];
#if DEBUG
							NSLog(@"no more health, player dies");
#endif
							[gameStateEngine storeLevelStatus];
							[gameStateEngine setNewTouchHasBegun: false];
						}
							
					}
					
				}
				else{
						// nondeadly sprites
					
					if ([spriteToCheck typeOfSprite]==COIN){
							// show points to the user.
						[self createSpriteOfType: TENPOINTS atPosition: [spriteToCheck currentPosition]];
						[spriteToCheck setIsActive: false];
						[spriteToCheck setCanCollide: false];
						[gameStateEngine IncreaseTotalScore: HCCoinScore];
						[gameStateEngine DecreaseCoinsInLevel: 1];
							// delete the coin from the layer so that other sprites can not collide anymore
						int xCoordinate = [spriteToCheck currentPosition].x/HCTileInnerSize;
						int yCoordinate = [spriteToCheck currentPosition].y/HCTileInnerSize;
						
						[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
						[soundEngine playSoundOfType: COINCOLLECTEDSOUND at2DPosition: [spriteToCheck currentPosition]]; 
					}
					
					if ([spriteToCheck typeOfSprite]==FIRSTAID){
							// show sparkle to the user
						[self createSpriteOfType: SPARKLERED atPosition: [spriteToCheck currentPosition]];
						[spriteToCheck setIsActive: false];
						[spriteToCheck setCanCollide: false];
						FirstAidSprite* firstAidSprite = (FirstAidSprite*)spriteToCheck;
						[healthStatusBar addHealthBonus: [firstAidSprite healthBonus]];
						[soundEngine playSoundOfType: HEALTHCOLLECTEDSOUND at2DPosition: [spriteToCheck currentPosition]];
					}
					
					if ([spriteToCheck typeOfSprite]==KEYBLUE){
						
						[spriteToCheck setCanCollide: false];
						KeyBlueSprite* tempKeySprite = (KeyBlueSprite*)spriteToCheck;
						[tempKeySprite setDoNotMove: false];
						[[gameStateEngine gameStatus]  setGotBlueKey: true];
						[soundEngine playSoundOfType: KEYCOLLECTEDSOUND at2DPosition: [spriteToCheck currentPosition]];
					}
					
					if ([spriteToCheck typeOfSprite]==KEYRED){
						
						[spriteToCheck setCanCollide: false];
						KeyRedSprite* tempKeySprite = (KeyRedSprite*)spriteToCheck;
						[tempKeySprite setDoNotMove: false];
						[[gameStateEngine gameStatus]  setGotRedKey: true];
						[soundEngine playSoundOfType: KEYCOLLECTEDSOUND at2DPosition: [spriteToCheck currentPosition]];

					}
					
					if ([spriteToCheck typeOfSprite]==KEYGOLD){
						
						[spriteToCheck setCanCollide: false];
						KeyGoldSprite* tempKeySprite = (KeyGoldSprite*)spriteToCheck;
						[tempKeySprite setDoNotMove: false];
						[[gameStateEngine gameStatus] setGotGoldKey: true];
						[soundEngine playSoundOfType: KEYCOLLECTEDSOUND at2DPosition: [spriteToCheck currentPosition]]; 
					}
					
					if ([spriteToCheck typeOfSprite]==DOORBLUE){
						
						if([[gameStateEngine gameStatus] gotBlueKey]){
								// show sparkle to the user
							[self createSpriteOfType: SPARKLE atPosition: [spriteToCheck currentPosition]];
							[spriteToCheck setIsActive: false];
							[spriteToCheck setCanCollide: false];
							[soundEngine playSoundOfType: DOOROPENSOUND at2DPosition: [spriteToCheck currentPosition]];
								// delete the door from the layer so that other sprites can not collide anymore
							int xCoordinate = [spriteToCheck currentPosition].x/HCTileInnerSize;
							int yCoordinate = [spriteToCheck currentPosition].y/HCTileInnerSize;
							[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];

							
						}
						
					}
					
					if ([spriteToCheck typeOfSprite]==DOORRED){
						
						if([[gameStateEngine gameStatus] gotRedKey]){
								// show sparkle to the user
							[self createSpriteOfType: SPARKLE  atPosition: [spriteToCheck currentPosition]];
							[spriteToCheck setIsActive: false];
							[spriteToCheck setCanCollide: false];
							[soundEngine playSoundOfType: DOOROPENSOUND at2DPosition: [spriteToCheck currentPosition]];
								// delete the door from the layer so that other sprites can not collide anymore
							int xCoordinate = [spriteToCheck currentPosition].x/HCTileInnerSize;
							int yCoordinate = [spriteToCheck currentPosition].y/HCTileInnerSize;
							[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];

						}
						
					}
					
					if ([spriteToCheck typeOfSprite]==DOORGOLD){
						
						if([[gameStateEngine gameStatus] gotGoldKey]){
								// show sparkle to the user
							[self createSpriteOfType: SPARKLE atPosition: [spriteToCheck currentPosition]];
							[spriteToCheck setIsActive: false];
							[spriteToCheck setCanCollide: false];
							[soundEngine playSoundOfType: DOOROPENSOUND at2DPosition: [spriteToCheck currentPosition]];
								// delete the door from the layer so that other sprites can not collide anymore
							int xCoordinate = [spriteToCheck currentPosition].x/HCTileInnerSize;
							int yCoordinate = [spriteToCheck currentPosition].y/HCTileInnerSize;
							[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];

						}
						
					}
					
					if([spriteToCheck typeOfSprite]==BOMB){
						[self createSpriteOfType: BOMBTIMER atPosition: [spriteToCheck currentPosition]];
						[spriteToCheck setIsActive: false];
						[spriteToCheck setCanCollide: false];
						[soundEngine playSoundOfType: BOMBCOLLECTEDSOUND at2DPosition: [spriteToCheck currentPosition]]; 
					}
					
				}
			}
		} 
	}
	
#pragma mark - explosion collision control =
	
		// did someone else hit an explosion?
	if ([sprite typeOfSprite] == EXPLOSION) {
		
		for (Sprite *spriteToCheck in spritesArray) {
			
			if ([spriteToCheck typeOfSprite] != EXPLOSION &&
				[sprite hasCollidedWithSprite: spriteToCheck] &&
				[sprite isActive]&& [spriteToCheck isActive]){
				
					// woodboxes will simply burn away
				if([spriteToCheck typeOfSprite]==WOODBOX){
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[self createSpriteOfType: FIRE atPosition: [spriteToCheck currentPosition]];
						// delete the box from the layer so that the player sprite can not collide anymore
					int xCoordinate = [spriteToCheck currentPosition].x/HCTileInnerSize;
					int yCoordinate = [spriteToCheck currentPosition].y/HCTileInnerSize;
					[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
				}
					// eye was killed by explosion
				if([spriteToCheck typeOfSprite]==EYE){
					[self createSpriteOfType: TWENTYPOINTS atPosition: [spriteToCheck currentPosition]];
					[self createSpriteOfType: STANDARDDIE atPosition: [spriteToCheck currentPosition]];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[gameStateEngine IncreaseTotalScore: HCEyeScore];
					[soundEngine playSoundOfType: ENEMYDIESOUND at2DPosition: [spriteToCheck currentPosition]];
				}
				
					// skull was killed by explosion
				if([spriteToCheck typeOfSprite]==SKULL){
					[self createSpriteOfType: TWENTYPOINTS atPosition: [spriteToCheck currentPosition]];
					[self createSpriteOfType: STANDARDDIE atPosition: [spriteToCheck currentPosition]];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[gameStateEngine IncreaseTotalScore: HCSkullScore];
					[soundEngine playSoundOfType: ENEMYDIESOUND at2DPosition: [spriteToCheck currentPosition]];
				}
				
					// bug was killed by explosion
				if([spriteToCheck typeOfSprite]==BUG){
					[self createSpriteOfType: TWENTYPOINTS atPosition: [spriteToCheck currentPosition]];
					[self createSpriteOfType: STANDARDDIE atPosition: [spriteToCheck currentPosition]];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[gameStateEngine IncreaseTotalScore: HCBugScore];
					[soundEngine playSoundOfType: ENEMYDIESOUND at2DPosition: [spriteToCheck currentPosition]];
				}
				
					// bee was killed by explosion
				if([spriteToCheck typeOfSprite]==BEE){
					[self createSpriteOfType: FIFTYPOINTS atPosition: [spriteToCheck currentPosition]];
					[self createSpriteOfType: STANDARDDIE atPosition: [spriteToCheck currentPosition]];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[gameStateEngine IncreaseTotalScore: HCBeeScore];
					[soundEngine playSoundOfType: ENEMYDIESOUND at2DPosition: [spriteToCheck currentPosition]];
				}
				
					// bat was killed by explosion
				if([spriteToCheck typeOfSprite]==BAT){
					[self createSpriteOfType: FIFTYPOINTS atPosition: [spriteToCheck currentPosition]];
					[self createSpriteOfType: STANDARDDIE atPosition: [spriteToCheck currentPosition]];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[gameStateEngine IncreaseTotalScore: HCBatScore];
					[soundEngine playSoundOfType: ENEMYDIESOUND at2DPosition: [spriteToCheck currentPosition]];
				}
				
					// another bomb was fired by the explosion
				if([spriteToCheck typeOfSprite]==BOMB){
					[self createSpriteOfType: EXPLOSION atPosition: CGPointMake([spriteToCheck currentPosition].x-HCBombTimerDistance, [spriteToCheck currentPosition].y-HCBombTimerDistance)];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
				}
				
					// another bomb was fired by the explosion
				if([spriteToCheck typeOfSprite]==BOMBTIMER){
					[self createSpriteOfType: EXPLOSION atPosition: CGPointMake([spriteToCheck currentPosition].x, [spriteToCheck currentPosition].y)];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
				}
				
					// non moving rock was hit by the explosion
				if([spriteToCheck typeOfSprite]==ROCK){
					
					RockSprite* rockSprite = (RockSprite*)spriteToCheck;
					if([rockSprite moveType] == NOMOVE){
							// delete the rock from the layer so that the player sprite or the rock itself can not collide anymore
						int xCoordinate = [spriteToCheck currentPosition].x/HCTileInnerSize;
						int yCoordinate = [spriteToCheck currentPosition].y/HCTileInnerSize;
						[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
						
							//RockSprite* rockSprite = (RockSprite*)spriteToCheck;
						[rockSprite setFlightPathRelativeToPoint: CGPointMake([sprite currentPosition].x + HCExplosionCenterDistance, [sprite currentPosition].y + HCExplosionCenterDistance)];
					}
					
					
				}
				
			}
		}
		
	}
	
#pragma mark - rock collision control 
	
	if ([sprite typeOfSprite] == ROCK && [sprite isLethal] && [sprite isActive]) {
		
		for (Sprite *spriteToCheck in spritesArray) {
			
			if (spriteToCheck != sprite && [sprite hasCollidedWithSprite: spriteToCheck]){
				
					// woodboxes will simply burn away
				if([spriteToCheck typeOfSprite]==WOODBOX){
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[self createSpriteOfType: SMOKE atPosition: [spriteToCheck currentPosition]];
						// delete the box from the layer so that the player sprite can not collide anymore
					int xCoordinate = [spriteToCheck currentPosition].x/HCTileInnerSize;
					int yCoordinate = [spriteToCheck currentPosition].y/HCTileInnerSize;
					[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
				}
					// eye was killed by rock
				if([spriteToCheck typeOfSprite]==EYE){
					[self createSpriteOfType: TWENTYPOINTS atPosition: [spriteToCheck currentPosition]];
					[self createSpriteOfType: STANDARDDIE atPosition: [spriteToCheck currentPosition]];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[gameStateEngine IncreaseTotalScore: HCEyeScore];
					[soundEngine playSoundOfType: ENEMYDIESOUND at2DPosition: [spriteToCheck currentPosition]];
				}
				
					// skull was killed by rock
				if([spriteToCheck typeOfSprite]==SKULL){
					[self createSpriteOfType: TWENTYPOINTS atPosition: [spriteToCheck currentPosition]];
					[self createSpriteOfType: STANDARDDIE atPosition: [spriteToCheck currentPosition]];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[gameStateEngine IncreaseTotalScore: HCSkullScore];
					[soundEngine playSoundOfType: ENEMYDIESOUND at2DPosition: [spriteToCheck currentPosition]];
				}
				
					// bug was killed by rock
				if([spriteToCheck typeOfSprite]==BUG){
					[self createSpriteOfType: TWENTYPOINTS atPosition: [spriteToCheck currentPosition]];
					[self createSpriteOfType: STANDARDDIE atPosition: [spriteToCheck currentPosition]];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[gameStateEngine IncreaseTotalScore: HCBugScore];
					[soundEngine playSoundOfType: ENEMYDIESOUND at2DPosition: [spriteToCheck currentPosition]];
				}
				
					// bee was killed by rock
				if([spriteToCheck typeOfSprite]==BEE){
					[self createSpriteOfType: FIFTYPOINTS atPosition: [spriteToCheck currentPosition]];
					[self createSpriteOfType: STANDARDDIE atPosition: [spriteToCheck currentPosition]];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[gameStateEngine IncreaseTotalScore: HCBeeScore];
					[soundEngine playSoundOfType: ENEMYDIESOUND at2DPosition: [spriteToCheck currentPosition]];
				}
				
					// bat was killed by rock
				if([spriteToCheck typeOfSprite]==BAT){
					[self createSpriteOfType: FIFTYPOINTS atPosition: [spriteToCheck currentPosition]];
					[self createSpriteOfType: STANDARDDIE atPosition: [spriteToCheck currentPosition]];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[gameStateEngine IncreaseTotalScore: HCBatScore];
					[soundEngine playSoundOfType: ENEMYDIESOUND at2DPosition: [spriteToCheck currentPosition]];
				}
				
					// another bomb was fired by the explosion
				if([spriteToCheck typeOfSprite]==BOMB && [spriteToCheck moveType] == NOMOVE){
					[self createSpriteOfType: EXPLOSION atPosition: CGPointMake([spriteToCheck currentPosition].x-HCBombTimerDistance, [spriteToCheck currentPosition].y-HCBombTimerDistance)];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
				}
				
					// another bomb was fired by the explosion
				if([spriteToCheck typeOfSprite]==BOMBTIMER){
					[self createSpriteOfType: EXPLOSION atPosition: CGPointMake([spriteToCheck currentPosition].x, [spriteToCheck currentPosition].y)];
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
				}
				
					// non moving rock was hit by the rock
				if([spriteToCheck typeOfSprite]==ROCK && [spriteToCheck moveType] == NOMOVE){
					
					[spriteToCheck setIsActive: false];
					[spriteToCheck setCanCollide: false];
					[self createSpriteOfType: SMOKE atPosition: [spriteToCheck currentPosition]];
					[sprite setIsActive: false];
					[sprite setCanCollide: false];
					[self createSpriteOfType: SMOKE atPosition: [sprite currentPosition]];	// delete the box from the layer so that the player sprite can not collide anymore
					int xCoordinate = [spriteToCheck currentPosition].x/HCTileInnerSize;
					int yCoordinate = [spriteToCheck currentPosition].y/HCTileInnerSize;
					[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
					
					
				}
				
			}
		}
		
	}
	
	
		// Skull has hit another sprite that may want to change its direction
	if ([sprite typeOfSprite] == SKULL) {
		
		for (Sprite *spriteToCheck in spritesArray) {
			
			if (spriteToCheck != sprite && [sprite hasCollidedWithSprite: spriteToCheck]){
				
				[spriteToCheck changeDirectionAfterCollision];
			}
		}
	}
	
		// Eye has hit another sprite that may want to change its direction
	if ([sprite typeOfSprite] == EYE) {
		
		for (Sprite *spriteToCheck in spritesArray) {
			
			if (spriteToCheck != sprite && [sprite hasCollidedWithSprite: spriteToCheck]){
				
				[spriteToCheck changeDirectionAfterCollision];
			}
		}
	}
	
		// Eye has hit another sprite that may want to change its direction
	if ([sprite typeOfSprite] == BUG) {
		
		for (Sprite *spriteToCheck in spritesArray) {
			
			if (spriteToCheck != sprite && [sprite hasCollidedWithSprite: spriteToCheck]){
				
				[spriteToCheck changeDirectionAfterCollision];
			}
		}
	}
	
	if ([sprite typeOfSprite] == BEE) {
		
		for (Sprite *spriteToCheck in spritesArray) {
			
			if (spriteToCheck != sprite && [sprite hasCollidedWithSprite: spriteToCheck]){
				
				[spriteToCheck changeDirectionAfterCollision];
			}
		}
	}
	
	if ([sprite typeOfSprite] == BAT) {
		
		for (Sprite *spriteToCheck in spritesArray) {
			
			if (spriteToCheck != sprite && [sprite hasCollidedWithSprite: spriteToCheck]){
				
				[spriteToCheck changeDirectionAfterCollision];
			}
		}
	}
	
	if ([sprite typeOfSprite] == FIRE) {
		
		for (Sprite *spriteToCheck in spritesArray) {
			
			if (spriteToCheck != sprite && [sprite hasCollidedWithSprite: spriteToCheck]){
				
				[spriteToCheck changeDirectionAfterCollision];
			}
		}
	}
}



- (void) updateSpriteArrays {
		
		//NSLog(@"updateSpriteArrays: %i destroyable: %i new: %i", [spritesArray count], [destroyableSpritesArray count], [newCreatedSpritesArray count]);
	
		// remove all sprites that are in destroyableSpritesArray
	for (Sprite *destroyableSprite in destroyableSpritesArray) { 
		for (Sprite *sprite in spritesArray) {
				// pointing to same object?
			if (destroyableSprite == sprite) {
					// yes = remove from main spritesArray
				[spritesArray removeObject: sprite];
				break;
			}
		} 
	}
	
		// add all sprites in newCreatedSpritesArray to spritesArray
	for (Sprite *newSprite in createdSpritesArray){ 
		[spritesArray addObject: newSprite]; 
	} 
	
		// all sprites removed/added - clear working arrays
	[destroyableSpritesArray removeAllObjects]; 
	[createdSpritesArray removeAllObjects];
}


	// walk through array of sprites and check for collisions
- (void) moveAndCheckSprites {
	
	for (Sprite *sprite in spritesArray) { 
		if ([sprite isActive]) { 
			[self checkCollisionsForSprite: sprite];
			if ([sprite typeOfSprite] != JUMPY) {
				if([[gameStateEngine gameStatus] gameState] != COUNTDOWNGAMESTATE){
					[sprite moveSprite];		
				}
			}
		}
		else{
				// sprites that are not active (any more) are going to be deleted in the next loop
			if ([sprite typeOfSprite] != JUMPY) {
				[destroyableSpritesArray addObject: sprite];
			}
		}
	} 
		// draw the player sprite as last one (so it will be on top)
	if([[gameStateEngine gameStatus] gameState] != COUNTDOWNGAMESTATE){
		[jumpySprite moveSprite];		
	}
 
}



- (void) drawSprites {

	for (Sprite *sprite in spritesArray) { 
		if ([sprite isActive]) { 
			if ([sprite typeOfSprite] != JUMPY) {
				[sprite drawNextAnimationFrame];
			}
		}
	}
	
	[jumpySprite drawNextAnimationFrame];

}


@end
