	//
	//  HealthStatusBar.m
	//  Jumpy
	//
	//  Created by Sven Putze on 03.05.11.
	//  Copyright 2011 hardcodes.de. All rights reserved.
	//

#import "HealthStatusBar.h"
#import "LevelResourceHandler.h"
#import "EAGL.h"


@implementation HealthStatusBar

@synthesize currentPosition;
@synthesize healthStatus;
@synthesize rotationAngle;


#pragma mark - init 

-(id) initWithImage: (NSString *) aImageName 
  atCurrentPosition: (CGPoint) aCurrentPosition
	andHealthStatus: (int) aHealthStatus
withLevelResourceHandler: (LevelResourceHandler*) aLevelResourceHandler{
	
	if ((self = [super init])) {
		
			// As a corollary of the fundamental rule, if you need to store a received object as a property in an
			// instance variable, you must retain or copy it.
		levelResourceHandler = [aLevelResourceHandler retain];
		texture = [[levelResourceHandler getTextureFromDictionaryForImage: aImageName] retain];
		currentPosition = aCurrentPosition;
		rotationAngle = 0;
		healthStatus = aHealthStatus;

	}
	
	return self;
}


	// override standard init to prevent user from using this!
- (id)init{
	
	[self dealloc];
	@throw [NSException exceptionWithName:@"HCBadInitCall" reason:@"You must use initWithImage: (NSString *) aImageName(...)" userInfo:nil];
	return nil;
}


- (void) dealloc {

	NSLog(@"START dealloc: sprite HealthStatusBar");
			// dealloc might have been called from init
	if (levelResourceHandler) [levelResourceHandler release];
	if (texture) [texture release];
	[super dealloc];
	NSLog(@"END dealloc: sprite HealthStatusBar");
	
}


#pragma mark - drawing


- (void) drawHealthStatus{
	
	if(healthStatus > 0){
		GLuint textureID = [texture textureID];
		[EAGL drawTextureWithId: &textureID
			   withDrawingWidth: healthStatus
		rotatedByAngleInDegrees: rotationAngle
					 atPosition: currentPosition
			   withTextureWidth: [texture textureWidth]
			   andTextureHeight: [texture textureHeight]];
	}
}


#pragma mark - change health status 


- (void) addHealthBonus: (int) aBonus{
	
	healthStatus += aBonus;
	if(healthStatus > HCDefaultHealth) healthStatus = HCDefaultHealth;
}

@end
