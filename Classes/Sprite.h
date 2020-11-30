//
// Sprite.h
//
// 20110415, Sven Putze
//  Copyright 2011 hardcodes.de. All rights reserved.

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import "SpriteTexture.h"


@class GameStateEngine;
@class SpriteResourceHandler;

	// different types of sprites
enum typesOfSprites {
	JUMPY,
	COIN,
	KEYBLUE,
	KEYGOLD,
	KEYRED,
	FIRE,
	ENDLESSFIRE,
	BAT,
	BEE,
	BUG,
	SKULL,
	EYE,
	DOORBLUE,
	DOORGOLD,
	DOORRED,
	ROCK,
	WOODBOX,
	BOMB,
	TENPOINTS,
	TWENTYPOINTS,
	FIFTYPOINTS,
	EXPLOSION,
	JUMPYANGEL,
	SMOKE,
	SPARKLE,
	SPARKLERED,
	JUMPYDIE,
	BOMBTIMER,
	FIRSTAID,
	SCORE,
	STANDARDDIE,
	GAMEOVER,
	HUDSCORE,
	LEVELCOMPLETESPRITE,
	POINTINGHANDSPRITE,
	GAMECOMPLETESPRITE,
	HANDLINGSPRITE,
	ONESEQUENCESPRITE,
	TWOSEQUENCESPRITE,
	THREESEQUENCESPRITE,
	GOSEQUENCESPRITE,
	BIGDRAGONSPRITE
};

enum moveTypes{
	FLY,
	FALL,
	MOVE,
	NOMOVE
};

enum collisionCheckDirections{
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
};

	// This class is the superclass for all sprites used in the game.
	// A new sprite can be initialized with a texture and an animation sequence. An animationsequence
	// is an c-style-array of integers. The first value contains the count of integer values in the array.
	// Every following int is a framenumber. This will be used to build more complex animations
	// where frames can repeat in a more complex order without the need to store the same kind of
	// frame in the spritesheet.
	// spritemovement, collisioncontrol is done in this class under control of GameStateEngine.
@interface Sprite : NSObject {
	SpriteTexture *spriteTexture;			// texture with PixelDataFromImage
	CGPoint movementDelta;					// delta in pxels that gets added for movement
	CGPoint currentPosition;				// current position of sprite
	CGPoint lastPosition;					// stores the last position before movement
	int internalCounter;					// TODO
	int frameNumber;						// points to current animation frame
	int frameCount;							// number of frames in texture
	int frameStep;							// number of gameloops per animation step
	int currentFrameStep;					// current gameloop for animation delay
	int frameWidth;							// width of one frame
	int frameHeight;						// height of one frame
	int rotationAngle;						// angle for rotation
	int typeOfSprite;						// type of sprite (enum)
	int boundingBoxSpriteOffset;			// offset that will be added to the framesize for sprite collision control
	int boundingBoxBackgroundOffset;		// offset that will be added to the framesize for background collision control
											//	int animationCycleCount;				// number of animation cycles
	int *animationSequence;					// holds the framenumbers for animation, so we can animate mor sophisticated
	int animationSequenceIndex;				// index of animationSequence
	int animationSequenceIndexOffset;		// offset that will be added to animationSequenceIndex to reach
											// different regions in one texture
	bool doNotAnimate;						// true = sprite will not be animated
	bool doNotMove;							// true = sprite will not be moved
	bool isActive;							// true = sprite is controlled by GameStateEngine, false = sprite will be removed
	bool autoDestroy;						// true = sprite will be deleted after animationsequence is completed
	bool isLethal;							// true = collision with this sprite is deadly
	bool canCollide;						// true = sprite can cause a collision, false = you can walk right through this sprite
	bool checkMoveType;						// true = sprite can fall down and must therefore be checked, false = no check
	bool setBackOnTile;						// true = if sprite collides with background, it is set on a tile, false = not
	int tileGidOnLayer;						// stores the tile Gid of this sprite on the layer when falling starts
	int moveType;							// one of enum moveTypes
	int fallenDistance;						// number of pixels the rock has fallen
	int noBottomFrameCount;					// counts frames before a sprite starts falling
	GameStateEngine *gameStateEngine;		// reference to the GameStateEngine
	SpriteResourceHandler * spriteResourceHandler;	// referece to the SpriteResourceHandler
}

@property (nonatomic, readwrite) bool isActive;
@property (nonatomic, readonly) int typeOfSprite;
@property (nonatomic, readonly) CGPoint currentPosition;
@property (nonatomic, readwrite) bool isLethal;
@property (nonatomic, readwrite) bool canCollide;
@property (nonatomic, readwrite) bool autoDestroy;
@property (nonatomic, readwrite) bool doNotMove;
@property (nonatomic, readonly) int moveType;

	// Selector links the sprite object to a texture by searching the NSMutableDictionary* resourceDictionary
	// and sets the values needed to create an animation.
-(id) initWithImage: (NSString *) aImageName 
		 frameCount: (int) aFrameCount
		  frameStep: (int) aFrameStep
	  movementDelta: (CGPoint) aMovementDelta
	currentPosition: (CGPoint) aCurrentPosition
withAnimationSequence: (int *) aAnimationSequence
withAnimationSequenceIndexOffset: (int) aAnimationSequenceIndexOffset
			 ofType: (int) aTypeOfSprite
withGameStateEngine: (GameStateEngine*) aGameStateEngine
withSpriteResourceHandler: (SpriteResourceHandler*) aSpriteResourceHandler;


	// Selector is a stub for inherited classes. Override this to build any kind of additional setup.
- (void) additionalSetup;


	// Selector performs movement of sprite (override) and is called every frame from GameStateEngine.
- (void) moveSprite;


	// Selector is a stub for subclasses
- (void) fly;


	// Selector is a stub for subclasses
- (void) fallDown;



	// Selector is a stub for subclasses
- (void) noMove;


	// Selector is called after a sprite has collided. Immidiate reaction is handled here or ignored - 
	// changeDirection Is called afterwards
- (void) changeDirectionAfterCollision;


	// Selector can be overridden to change the direction of the sprite (e.g., after a collision has occured).
- (void) changeDirection;


	// Selector is called if autoDestroy = true and the animationsequence is completed, override for any use
- (void) autoDestroyAction;


	// Selector can be overridden if the end of the animationsequence is reached. (opposite of autoDestroyAction)
- (void) endOfAnimationSequenceReachedAction;


	// Selector can be overridden, it is called when a sprite is falling down and has hit the bottom
- (void) fallenSpriteHasHitBottomAction;


	// Selector renders the sprite using the next animation frame.
- (void) drawNextAnimationFrame;


	// Selector can be overridden for custom actions
- (void) nextAnimationSequenceFrameSelected;


	// Selector returns the next int value of an amiation frame. Value is stored in an c-style-array.
- (int) getNextAnimationFrameNumber;


	// Selctor checks if the given point collides with a tile from the background (layer named "maze").
	// true = point collides
	// false = no collision
- (bool) hasCollidedWithBackGroundAtPoint: (CGPoint) aPoint;



	// Selector returns the tileGid in the sprite layer for the given point
- (int) getSpriteLayerTileGidAtPoint: (CGPoint) aPoint;


	// Selector checks if one of the rectanglesides (left upper corner, frameWidth, frameHeight AKA
	// TOP, RIGHT, BOTTOM, LEFT) has collided with the background
	// true = sprite has collided with one of the four sides
	// false = sprite has not collided with one of the four sides
- (bool) boundingBoxHasCollidedWithBackground;


	// Selector checks if one of the rectanglesides (left upper corner, frameWidth, frameHeight AKA
	// TOP, RIGHT, BOTTOM, LEFT) has collided with the background
	// true = sprite has collided with the given side
	// false = sprite has not collided with the given side
- (bool) boundingBoxHasCollidedWithBackgroundOnDirection: (int) aDirection;


	// Selector checks if this sprite collides with aPoint. TRUE = collision, FALSE = no collision.
- (bool) checkCollisonWithPoint: (CGPoint) aPoint;


	// Selector checks if the given CGRect collides with the rectangle taken by this sprite under consideration of boundingBoxOffset. TRUE = the rectangles collide, FALSE = no collision.
- (bool) checkCollisionWithBoundingBox: (CGRect) aRect;


	// Selector returns true if this sprite collides with the rectangle of theOtherSprite. TRUE = collision, FALSE = no collision.
- (bool) hasCollidedWithSprite: (Sprite *) theOtherSprite;


	// Selector is a stub for inherited classes. Override for individual collision handling.
- (void) spriteWasHit;


	// Selector returns the rectangle of the sprite (for collision control). It uses the current postion, framewidth and frameheight.
- (CGRect) getRectangle;


	//Selector returns the X-Coordinate of the tile
- (int) getTileXCoordinateForPoint: (CGPoint) aPoint;


	//Selector returns the X-Coordinate of the tile
- (int) getTileYCoordinateForPoint: (CGPoint) aPoint;


	// Selector is called after the sprite has hit the bottom. Because the sprite can fall too far in one frame
	// the exact position of the next bottom is calculated here
- (int) getExcactYCoordinateOfBottom;


	// Selector is called after the sprite has hit the top. Because the sprite can jump/fly/whatever too far in one frame
	// the exact position of the next top is calculated here
- (int) getExcactYCoordinateOfTop;


	// Selector returns the given angle (0-360°) in rad (radian measure)
	// 360° = 2 * PI rad
- (float) getRadForAngle: (float) aAngle;


@end
