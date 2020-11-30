//
//  TileMapManager.h
//  Jumpy
//
//  Created by Sven Putze on 15.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "TileSetAtlasImageSource.h"
#import "Layer.h"

@class LevelResourceHandler;

	// This class provides methods for handling tilemaps. Tilemaps are the xml-files containing the level data.
	// In this game we use tilemaps created with the tool TilEd. As a result we get a xml-file with a .tmx extension.
	// Tiledata of a level is zipped and base64 coded.
@interface TileMapLevelFile : NSObject {
    
	int tileMapWidth;
	int tileMapHeight;
	int tileWidth;
	int tileHeight;
	TileSetAtlasImageSource *firstTileSet;
		// stores all layers in the TMX/XML-file
	NSMutableDictionary *tileMapLayers;
		// reference
	LevelResourceHandler *levelResourceHandler;
	
}

@property(nonatomic, readonly) int tileMapWidth;
@property(nonatomic, readonly) int tileMapHeight;
@property(nonatomic, readonly) int tileWidth;
@property(nonatomic, readonly) int tileHeight;
@property(nonatomic, readonly) NSMutableDictionary *tileMapLayers;



	// Selector opens the given TilEd file and reads its XML content.
- (id)initWithFileName: (NSString*) aFileName
		 withExtension: (NSString*) aFileExtension
withLevelResourceHandler: (LevelResourceHandler*) aLevelResourceHandler;



	// Selector reads the content of a level file and stores data contained in it.
- (void)parseTilEdMapFileTMXXML: (TBXML*) aTBXMLObject;
@end
