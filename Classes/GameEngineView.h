
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import "GameStateEngine.h"
#import "SoundEngine.h"
#import "GameStatus.h"

@interface GameEngineView : UIView {
		// reference to the GameStateEngine
	GameStateEngine *gameStateEngine; 
		// we will draw to this context
	EAGLContext *eaglContext;
		// buffer where the drawing commands are rendered
	GLuint renderbuffer;
		// for 3D versions it stores the z-axis
	GLuint depthbuffer;
		// result of the rendering pipeline -> that is handled by 
	GLuint framebuffer;
		// TODO: check if this names are cool -> may collide woth inherited values
	GLint viewportWidth;
	GLint viewportHeight;
		// reference to our soundmachine
	SoundEngine *soundEngine;
		// status of the game
	GameStatus *gameStatus;
}

@property (nonatomic, readonly) GameStateEngine *gameStateEngine;
@property (nonatomic, retain, readwrite) SoundEngine *soundEngine;
@property (nonatomic, retain, readwrite) GameStatus *gameStatus;


- (void) setupEAGL;

@end