//
//  LevelResourceHandler.h
//  Jumpy
//
//  Created by Sven Putze on 18.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "Texture.h"
#import "TileSetTextureAtlas.h"


@interface LevelResourceHandler : NSObject {
    
		// resource dictionary that references the images/textures of background tiles
	NSMutableDictionary* resourceDictionary;
	
}



	// Selector creates the hashtable (NSMutableDictionary* resourceDictionary) where references to resources are stored.
- (NSMutableDictionary *) getResourceDictionary;



	// Selector removes a resource from NSMutableDictionary* resourceDictionary. The resource is identified by its filename.
- (void) removeFromDictionary: (NSString*) name;



	// Selector returns a class of type Texture that was stored in the NSDictionary resourceDictionary by the Selector preloader.
- (Texture *) getTextureFromDictionaryForImage: (NSString*) aImageName;



	// Selector returns a class of type TileSetTexture that was stored n the NSDictionary resourceDictionary by the Selector preloader.
- (TileSetTextureAtlas *) getTileSetTextureFromDictionaryForImage: (NSString*) aImageName;


@end
