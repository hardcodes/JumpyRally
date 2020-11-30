	//
	// Sprite.m
	//
	// 20110415, Sven Putze
	//
#import "Sprite.h"
#import "GameStateEngine.h"
#import "SpriteResourceHandler.h"

@implementation Sprite

@synthesize isActive;
@synthesize typeOfSprite;
@synthesize currentPosition;
@synthesize isLethal;
@synthesize canCollide;
@synthesize autoDestroy;
@synthesize doNotMove;
@synthesize moveType;


#pragma mark - init

-(id) initWithImage: (NSString *) aImageName
		 frameCount: (int) aFrameCount
		  frameStep: (int) aFrameStep
	  movementDelta: (CGPoint) aMovementDelta
	currentPosition: (CGPoint) aCurrentPosition
withAnimationSequence: (int *) aAnimationSequence
withAnimationSequenceIndexOffset: (int) aAnimationSequenceIndexOffset
			 ofType: (int) aTypeOfSprite
withGameStateEngine: (GameStateEngine*) aGameStateEngine
withSpriteResourceHandler: (SpriteResourceHandler*) aSpriteResourceHandler{
	
	if ((self = [super init])) {
			// weak reference
		gameStateEngine = aGameStateEngine;
		spriteResourceHandler = aSpriteResourceHandler;
			// As a corollary of the fundamental rule, if you need to store a received object as a property in an
			// instance variable, you must retain or copy it.
		spriteTexture = [[spriteResourceHandler getSpriteTextureFromDictionaryForImage: aImageName] retain];
		movementDelta = aMovementDelta;
		currentPosition = aCurrentPosition;
		lastPosition = aCurrentPosition;
		internalCounter = 0;
		frameNumber = 0; 
		frameCount = aFrameCount;
		frameStep = aFrameStep;
		currentFrameStep = 0;
		frameWidth = [spriteTexture textureWidth]/frameCount;
		frameHeight = [spriteTexture textureHeight];
		rotationAngle = 0;
			//typeOfSprite = -1;
		boundingBoxSpriteOffset = 0;
		boundingBoxBackgroundOffset = 0;
		doNotAnimate = false;
		doNotMove= false;
		checkMoveType = false;
		moveType=NOMOVE;
		isActive = true;
		autoDestroy = false;
		animationSequenceIndex = 1;
		animationSequenceIndexOffset = aAnimationSequenceIndexOffset;
		animationSequence = aAnimationSequence;
		typeOfSprite = aTypeOfSprite;
			// remember tileGid for this sprite so we can put in the map/layer again
		tileGidOnLayer = [self getSpriteLayerTileGidAtPoint: currentPosition];
		noBottomFrameCount = 0;
		
		[self additionalSetup];
	}
	
	return self;
}

	
- (id)init{
	// override standard init to prevent user from using this!
	[self dealloc];
	@throw [NSException exceptionWithName:@"HCBadInitCall" reason:@"You must use initWithImage: (NSString *) aImageName(...)" userInfo:nil];
	return nil;
}


- (void) dealloc {

	NSLog(@"START dealloc: sprite of type %i",typeOfSprite);
		// dealloc might have been called from init
	if (spriteTexture) [spriteTexture release];
	[super dealloc];
	NSLog(@"END dealloc: sprite of type %i",typeOfSprite);

}

	
- (void) additionalSetup {
	// override for individual setup
}


- (void) autoDestroyAction{
	// override for individual autodestroy action
}



- (void) endOfAnimationSequenceReachedAction{
	// override for individual action at the end of a animation sequence
}


	// perform movements of sprite (override)
- (void) moveSprite{
	
	lastPosition = currentPosition;
	
	if (isActive && checkMoveType){
		
			// rock can move in different ways
		
		switch (moveType) {
				
			
			case FLY:
				
				[self fly];
				
				break;
				
				
			case FALL:
				
				[self fallDown];
				
				break;
				
				
			case NOMOVE:
					
				[self noMove];
				
				break;
				
				
			default:
					// do nothing, is handled in subclasses
				break;
		}
		
	}


#pragma mark - regular movement
		// only active sprites can move
	if (isActive && !doNotMove) {
		
		currentPosition.x+=movementDelta.x;
		currentPosition.y+=movementDelta.y;
			// safetynet - whatever happens, sprites should stay in the playfield
		if(currentPosition.x < HCminX) currentPosition.x=HCminX;
		if(currentPosition.x > HCmaxX) currentPosition.x=HCmaxX;
		if(currentPosition.y < HCminY) currentPosition.y=HCminY;
		if(currentPosition.y > HCmaxY) currentPosition.y=HCmaxY;
	}
}


#pragma mark - falling on ground

- (void) fallenSpriteHasHitBottomAction{
		// override for individial action if a sprite hits the bottom
	doNotMove = false;
	moveType = NOMOVE;
	movementDelta=CGPointMake(0,0);
	
	int xDelta = ((int)currentPosition.x) % HCTileInnerSize;
	currentPosition.x = ((int)currentPosition.x) - xDelta;
	currentPosition.y = [self getExcactYCoordinateOfBottom];
	
		// write tileGid for a rock into the map/layer
	int xCoordinate = [self getTileXCoordinateForPoint:currentPosition];
	int yCoordinate = [self getTileYCoordinateForPoint:currentPosition];
	
		// write the tile Gid that was stored while init back into the layer/map.
	[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: tileGidOnLayer atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
	
}

#pragma mark - flying

- (void) fly{
		// override for individal action
}



- (void) noMove{
	// override for individal action
	// sprite is just there - check if we must fall
	if(![self hasCollidedWithBackGroundAtPoint: CGPointMake(currentPosition.x +8, currentPosition.y +frameHeight)]){
		
		++noBottomFrameCount;
		
		if(noBottomFrameCount > HCSpriteNoBottomFrameCount){
				// sprite stood still in the air for noBottomFrameCount frames.
				// now it's time to start falling...
			doNotMove = false;
			moveType = FALL;
			movementDelta = CGPointMake(0,1);
				// delete the sprite from the layer so that the player sprite or other sprites can not collide anymore
			int xCoordinate = [self getTileXCoordinateForPoint:currentPosition];
			int yCoordinate = [self getTileYCoordinateForPoint:currentPosition];
				// delete tile in the map/layer
			[[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] setTileGId: HCTileNullValue atXCoordinate: xCoordinate AndYCoordinate: yCoordinate];

		}
		
	}
}


#pragma mark - falling

- (void) fallDown{
		// override for individal action
	if(fallenDistance % 3 == 0) movementDelta.y +=1;
	if(movementDelta.y >= HCTileInnerSize-2) movementDelta.y = HCTileInnerSize-2;
	fallenDistance += movementDelta.y;
	
	if([self hasCollidedWithBackGroundAtPoint:
		CGPointMake(currentPosition.x+8, currentPosition.y+HCTileInnerSize+movementDelta.y)]){
		
		[self fallenSpriteHasHitBottomAction];
	}
}


#pragma mark - draw & animate


- (void) drawNextAnimationFrame {
	
		//NSLog(@"drawFrame");
	if (isActive) {
		
		if (doNotAnimate && movementDelta.x == 0 && movementDelta.y == 0) {
			frameNumber = 0;
		}
		else{
			frameNumber = [self getNextAnimationFrameNumber];
			
		}
		
			// render sprite
		[spriteTexture drawFrame: frameNumber
					  frameWidth: frameWidth
		 rotatedByAngleInDegrees: rotationAngle
					  atPosition: CGPointMake(currentPosition.x, currentPosition.y)];
	}
}



- (void) nextAnimationSequenceFrameSelected{
	
}


	// return number of frame that should be displayed
- (int) getNextAnimationFrameNumber{ 
		// the frame is stored in the array
	int nextAnimationFrameNumber = animationSequence[animationSequenceIndex] + animationSequenceIndexOffset;
		// frame should not change every gameloop - that's way too fast
	if(currentFrameStep == frameStep){
		
		currentFrameStep = 0;

		
		if(animationSequenceIndex < animationSequence[0]){
			++animationSequenceIndex;
			[self nextAnimationSequenceFrameSelected];
		}
		else{
			
			animationSequenceIndex = 1;
			
			if(autoDestroy){
					// sprites with bool autoDestroy=true are deactivated after one
					// complete animationsequence was shown.
				isActive = false;
				[self autoDestroyAction];
			}
			else [self endOfAnimationSequenceReachedAction];
		}
	}
	else ++currentFrameStep;
	
	return nextAnimationFrameNumber;

} 


- (void) spriteWasHit {
		// Override for individual collision handling
}



- (void) changeDirectionAfterCollision{

	[self changeDirection];
	
}



- (void) changeDirection{
		// Override for individal change of the sprite direction
}


#pragma mark - collision control


- (bool) hasCollidedWithBackGroundAtPoint: (CGPoint) aPoint{
	
	int xCoordinate = [self getTileXCoordinateForPoint:aPoint];
	int yCoordinate = [self getTileYCoordinateForPoint:aPoint];
	
	int tileGid = [[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"maze"] getTileGIdAtXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
		// Collision with the background
	if(tileGid != 0) return true;
	
	tileGid = [[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] getTileGIdAtXCoordinate: xCoordinate AndYCoordinate: yCoordinate] - HCFirstSpriteGID + 1;
		// Collision with a door (6,7,8)
		// if we don't have a key a door is like background
	if(tileGid >= 2 && tileGid <= 11) return true;
	
		//Default: no collision
	return false;
}



- (bool) boundingBoxHasCollidedWithBackground{
	
	bool returnValue=false;
	
		// check top side
	returnValue = [self boundingBoxHasCollidedWithBackgroundOnDirection: TOP];
	
		// check right side (if no collision so far)
	if(!returnValue){
		returnValue = [self boundingBoxHasCollidedWithBackgroundOnDirection: RIGHT];	
	}
	
		// check bottom side (if no collision so far)
	if(!returnValue){
		returnValue = [self boundingBoxHasCollidedWithBackgroundOnDirection: BOTTOM];
	}
		
		// check left side (if no collision so far)
	if(!returnValue){
		returnValue = [self boundingBoxHasCollidedWithBackgroundOnDirection: LEFT];
	}
	
	return returnValue;

}



- (bool) boundingBoxHasCollidedWithBackgroundOnDirection: (int) aDirection{
	
	bool returnValue=false;
	int i = boundingBoxBackgroundOffset;
	int j = frameWidth -1 -boundingBoxBackgroundOffset;
	
	switch (aDirection) {
			
		case TOP:
				// check top side
			while (i <=j ) {
				if([self hasCollidedWithBackGroundAtPoint: CGPointMake(currentPosition.x + i, currentPosition.y + boundingBoxBackgroundOffset)]){
					returnValue = true;
					break;
				}
				++i;
			}
			break;
			
		case RIGHT:
				// check right side
			i = boundingBoxBackgroundOffset;
			while (i <=j ) {
				if([self hasCollidedWithBackGroundAtPoint: CGPointMake(currentPosition.x + frameWidth -1 -boundingBoxBackgroundOffset, currentPosition.y + i)]){
					returnValue = true;
					break;
				}
				++i;
			}
			break;
			
		case BOTTOM:
			i = boundingBoxBackgroundOffset;
			while (i <=j ) {
				if([self hasCollidedWithBackGroundAtPoint: CGPointMake(currentPosition.x + i, currentPosition.y + frameHeight -1 -boundingBoxBackgroundOffset)]){
					returnValue = true;
					break;
				}
				++i;
			}
			break;
			
		case LEFT:
			i = boundingBoxBackgroundOffset;
			while (i <=j ) {
				if([self hasCollidedWithBackGroundAtPoint: CGPointMake(currentPosition.x +boundingBoxBackgroundOffset, currentPosition.y + i)]){
					returnValue = true;
					break;
				}
				++i;
			}
			break;
			
		default:
				// should never happen
			break;
	}
	
	return returnValue;
}

	

- (bool) checkCollisonWithPoint: (CGPoint) aPoint {
	CGRect rect = [self getRectangle];
	if (aPoint.x > rect.origin.x 
		&&aPoint.x < (rect.origin.x+rect.size.width) 
		&&aPoint.y > rect.origin.y 
		&&aPoint.y < (rect.origin.y+rect.size.height)) {
		return true;
	}
	return false;										
}

	
- (bool) checkCollisionWithBoundingBox: (CGRect) aRect {
	
	CGRect rect1 = [self getRectangle];
	CGRect rect2 = aRect;
	
		// Rectangle No. 1
	int x1=rect1.origin.x +boundingBoxSpriteOffset;
	int y1=rect1.origin.y +boundingBoxSpriteOffset; 
	int w1=rect1.size.width -boundingBoxSpriteOffset -boundingBoxSpriteOffset; 
	int h1=rect1.size.height -boundingBoxSpriteOffset -boundingBoxSpriteOffset; 
	
		// Rectangle No. 2
	int x3=rect2.origin.x;
	int y3=rect2.origin.y; 
	int w2=rect2.size.width; 
	int h2=rect2.size.height;
	
	int x2=x1+w1, y2=y1+h1;
	int x4=x3+w2, y4=y3+h2;
	
	if ( x2 >= x3 && x4 >= x1 && y2 >= y3 && y4 >= y1) return true;
	
	return false;
}


- (bool) hasCollidedWithSprite: (Sprite *) theOtherSprite {
		// we can only collide if we are (still) active.
	if(isActive && canCollide){
		
		if([theOtherSprite canCollide])	return [self checkCollisionWithBoundingBox: [theOtherSprite getRectangle]];
	}
	
	return false;
}


#pragma mark - helper methods


- (int) getExcactYCoordinateOfBottom{
	
	int yDelta;
	
		// check directly under the sprite
	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+2, lastPosition.y+HCTileInnerSize)]){
		yDelta = ((int)lastPosition.y) % HCTileInnerSize;
		return ((int)lastPosition.y) - yDelta;
	}
	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+14, lastPosition.y+HCTileInnerSize)]){
		yDelta = ((int)lastPosition.y) % HCTileInnerSize;
		return ((int)lastPosition.y) - yDelta;
	}
	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+8, lastPosition.y+HCTileInnerSize)]){
		yDelta = ((int)lastPosition.y) % HCTileInnerSize;
		return ((int)lastPosition.y) - yDelta;
	}
		// check one tile deeper
	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+2, lastPosition.y+HCTileInnerSize+HCTileInnerSize)]){
		yDelta = ((int)lastPosition.y) % HCTileInnerSize;
		return ((int)lastPosition.y) - yDelta + HCTileInnerSize;
	}
	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+14, lastPosition.y+HCTileInnerSize+HCTileInnerSize)]){
		yDelta = ((int)lastPosition.y) % HCTileInnerSize;
		return ((int)lastPosition.y) - yDelta + HCTileInnerSize;
	}
	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+8, lastPosition.y+HCTileInnerSize+HCTileInnerSize)]){
		yDelta = ((int)lastPosition.y) % HCTileInnerSize;
		return ((int)lastPosition.y) - yDelta + HCTileInnerSize;
	}
	
	
	return (int)lastPosition.y;
}


- (int) getExcactYCoordinateOfTop{
	
	int yDelta;
	
		// check directly above the sprite
	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+2, lastPosition.y-HCTileInnerSize)]){
		yDelta = ((int)lastPosition.y) % HCTileInnerSize;
		return ((int)lastPosition.y) - yDelta;
	}
	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+14, lastPosition.y-HCTileInnerSize)]){
		yDelta = ((int)lastPosition.y) % HCTileInnerSize;
		return ((int)lastPosition.y) - yDelta;
	}
	if([self hasCollidedWithBackGroundAtPoint: CGPointMake(lastPosition.x+8, lastPosition.y-HCTileInnerSize)]){
		yDelta = ((int)lastPosition.y) % HCTileInnerSize;
		return ((int)lastPosition.y) - yDelta;
	}
	
	return (int)lastPosition.y;
}



- (CGRect) getRectangle {
	return CGRectMake(currentPosition.x, currentPosition.y, frameWidth, frameHeight);
}



- (int) getTileXCoordinateForPoint: (CGPoint) aPoint{
	
	int xCoordinate = ((int)aPoint.x)/HCTileInnerSize;
	return xCoordinate;
}



- (int) getTileYCoordinateForPoint: (CGPoint) aPoint {
	
	int yCoordinate = ((int)aPoint.y)/HCTileInnerSize;
	return yCoordinate;
}



- (int) getSpriteLayerTileGidAtPoint: (CGPoint) aPoint{
	
	int xCoordinate = [self getTileXCoordinateForPoint:aPoint];
	int yCoordinate = [self getTileYCoordinateForPoint:aPoint];
	return [[[[gameStateEngine levelTileMap] tileMapLayers] objectForKey:@"sprites"] getTileGIdAtXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
	
}



- (float) getRadForAngle: (float) aAngle{
	
	float rad = (M_PI / 180) * aAngle;
	return rad;
}

@end
