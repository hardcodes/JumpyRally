//
//  LevelResourceHandler.m
//  Jumpy
//
//  Created by Sven Putze on 18.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "LevelResourceHandler.h"


@implementation LevelResourceHandler


#pragma mark - init

- (void) dealloc {
	
#if DEBUG
	NSLog(@"START dealloc: LevelResourceHandler");
#endif

	[resourceDictionary release];
	[super dealloc];
#if DEBUG
	NSLog(@"END dealloc: LevelResourceHandler");
#endif
}


#pragma mark - resourceDictionary

- (NSMutableDictionary *) getResourceDictionary {
	if (!resourceDictionary) {
			// hashtable
		resourceDictionary = [[NSMutableDictionary alloc] init]; 
	}
	
	return resourceDictionary;
}



- (void) removeFromDictionary: (NSString*) name {
	[[self getResourceDictionary] removeObjectForKey: name];
}



- (Texture *) getTextureFromDictionaryForImage: (NSString*) aImageName{
	
		// Is the same texture already in our dictionary?
	Texture *texture = [[self getResourceDictionary] objectForKey: aImageName];
	if (!texture) {
		
			// No, so create one...
#if DEBUG
		NSLog(@"%@ is new to resourceDictionary", aImageName);
#endif
		texture = [[Texture alloc] initWithImageName: aImageName];
		
			// add the created texture to our dictionary.
		[[self getResourceDictionary] setObject: texture forKey: aImageName];
#if DEBUG
		NSLog(@"%@ is stored as texture in resourceDictionary", aImageName);
#endif
		[texture autorelease]; 
	}
	return texture;
}



- (TileSetTextureAtlas *) getTileSetTextureFromDictionaryForImage: (NSString*) aImageName {
	
		// Is the same texture already in our dictionary?
	TileSetTextureAtlas *tileSetTexture = [[self getResourceDictionary] objectForKey: aImageName];
	if (!tileSetTexture) {
		
			// No, so create one...
#if DEBUG
		NSLog(@"%@ is new to resourceDictionary", aImageName);
#endif
		tileSetTexture = [[TileSetTextureAtlas alloc] initWithImageName: aImageName];
		
			// add the created texture to our dictionary.
		[[self getResourceDictionary] setObject: tileSetTexture forKey: aImageName];
#if DEBUG
		NSLog(@"%@ is stored as texture in resourceDictionary", aImageName);
#endif
		[tileSetTexture release]; 
	}
	return tileSetTexture;
}


@end
