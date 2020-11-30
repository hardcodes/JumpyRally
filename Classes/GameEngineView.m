
#import "GameEngineView.h"

@implementation GameEngineView

@synthesize gameStateEngine;
@synthesize soundEngine;
@synthesize gameStatus;


#pragma mark - init 

	// overridden
	// tells anyone interested that we are in fact an OpenGL view
+ (Class) layerClass {
	
	return [CAEAGLLayer class];
	
}

	// setup buffers etc.
- (void) setupEAGL {
	
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *) self.layer;
		// For optimal performance, mark the layer as opaque by setting the opaque property provided
		// by the CALayer class to YES.
	eaglLayer.opaque = YES;
	
		// create a new EAGL context for OpenGLES 1.1
		// An EAGL Context is the iOS Implementation of an OpenGL ES Rendering Context
		// The Current Context Acts as the Target for OpenGL ES Function Calls Made on a Thread
	eaglContext = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
	if (!eaglContext || ![EAGLContext setCurrentContext: eaglContext]) {
		[self release];
	} else {
			//Renderbuffer 
		glGenRenderbuffersOES(1, &renderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderbuffer);
		
			//Framebuffer 
		glGenFramebuffersOES(1, &framebuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, renderbuffer);
		
			//Graphic context
		[eaglContext renderbufferStorage: GL_RENDERBUFFER_OES fromDrawable: eaglLayer];
		glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &viewportWidth);
		glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &viewportHeight);
		
		GLenum status = glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES);
		if (status != GL_FRAMEBUFFER_COMPLETE_OES) {
			NSLog(@"failed to make complete framebuffer object %x", status);
		}
		else{
			if (!gameStateEngine) {
					// get singleton instance of the game engine
				gameStateEngine = [[GameStateEngine alloc] initWithSoundEngine: soundEngine withGameStatus: gameStatus];
			}
		}
	} 
}


-(void) dealloc {
	
	NSLog(@"START dealloc: GameEngineView");
	[gameStateEngine release];
	
	if (eaglContext) {
		glDeleteRenderbuffersOES(1, &depthbuffer);
		glDeleteFramebuffersOES(1, &framebuffer); 
		glDeleteRenderbuffersOES(1, &renderbuffer);
		[eaglContext release];
	}
	
	[super dealloc];
	NSLog(@"END dealloc: GameEngineView");
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	NSLog(@"interface: %@", interfaceOrientation);
	return YES;
}

#pragma mark - draw 

	// overridden
- (void) drawRect: (CGRect) rect {
	
	
	
		// viewportWidth and viewpoerHeight are set when the eagl context is married with
		// the graphics context
		// we get the real resolution of the device independend of app type
		// iphone apps on a ipad return 1024x768 here.
	glViewport(0, 0, viewportWidth, viewportHeight);
		// at the start of every frame, erase all renderbuffers whose contents from a previous frames are not needed
		// to draw the next frame. Call the glClear function, passing in a bit mask with all of the buffers to clear.
		// DEACTIVATED
		// not clearing the complete renderbuffer (clearing = fil the complete framebuffer with one color) causes visible
		// threads around the sprites
		// glClearColor(GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
		// draw the real content
	[gameStateEngine drawGameStateInsideFrame: rect onRenderBuffer: renderbuffer];
		// at this step, the color renderbuffer holds the completed frame, so all you need to do is present it to the user.
		// We bind the renderbuffer to the context and present it.
		// This causes the completed frame to be handed to Core Animation.
	[EAGLContext setCurrentContext: eaglContext];
		// Most applications that draw using OpenGL ES want to display the contents of the framebuffer to the user. On iOS,
		// all images displayed on the screen are handled by Core Animation. Every view is backed by a corresponding Core Animation
		// layer. OpenGL ES connects to Core Animation through a special Core Animation layer, a CAEAGLLayer. A CAEAGLLayer allows
		// the contents of an OpenGL ES renderbuffer to also act as the contents of a Core Animation layer. This allows the
		// renderbuffer contents to be transformed and composited with other layer content, including content rendered using UIKit
		// or Quartz. Once Core Animation composites the final image, it is displayed on the device’s main screen or an attached
		// external display.
	[eaglContext presentRenderbuffer: GL_RENDERBUFFER_OES];


	
}


#pragma mark - touch handling 

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {	
	CGPoint pointOfTouch = [[touches anyObject] locationInView: self]; 
	[gameStateEngine touchBegan: pointOfTouch];
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event { 
	CGPoint pointOfTouch = [[touches anyObject] locationInView: self];
	[gameStateEngine touchMoved: pointOfTouch];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
	CGPoint pointOfTouch = [[touches anyObject] locationInView: self];
	[gameStateEngine touchEnded: pointOfTouch]; 
}

- (void) touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event {
	CGPoint pointOfTouch = [[touches anyObject] locationInView: self];
	[gameStateEngine touchEnded: pointOfTouch];
}



@end
