//
//  Texture.m
//  Jumpy
//
//  Created by Sven Putze on 18.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Texture.h"
#import "EAGL.h"


@implementation Texture

@synthesize textureID;
@synthesize textureWidth;
@synthesize textureHeight;


- (id) initWithImageName: (NSString *) aImageName {
	
	self = [super init];
	if(self!= nil){
		UIImage *sourceImage = [UIImage imageNamed: aImageName];
		if (sourceImage) {
				// remember width and height from sourceimage = later render dimensions
			textureWidth = sourceImage.size.width;
			textureHeight = sourceImage.size.height;

				// OpenGL/GPU can only work with textures with dimensions that are power of 2.
			if ((textureWidth & (textureWidth-1)) != 0 || (textureHeight & (textureHeight-1)) != 0
				|| textureWidth > 2048 || textureHeight > 2048) {
				NSLog(@"ERROR: %@ width %i or height %i is no power of two or > 2048!", aImageName, textureWidth, textureHeight); 
			}
			else{
				
				[EAGL createTextureIdForImage: aImageName forTextureId: &textureID];
			}
			sourceImage = nil;
			
				// These values are needed for every texture part thjat is drawn.
			texturePixelWidth = 1.0 / textureWidth;
			texturePixelHeight = 1.0 / textureHeight;
			
			textureWidthHalf = textureWidth / 2;
			textureHeightHalf = textureHeight / 2;
			
				//
		} else {
			NSLog(@"ERROR: %@ can not find picture (typo?), no texture created!", aImageName);
		}
	}
	
	return self;
}



	// override standard init to prevent user from using this!
- (id)init{
	
	[self dealloc];
	@throw [NSException exceptionWithName:@"HCBadInitCall" reason:@"You must use initWithImageName: (NSString *) aImageName" userInfo:nil];
	return nil;
}


- (void) dealloc {
#if DEBUG
	NSLog(@"START dealloc texture, ID: %i", textureID);
#endif
	glDeleteTextures(1, &textureID);
	[super dealloc];
#if DEBUG
	NSLog(@"END dealloc texture, ID: %i", textureID);
#endif
}


@end
