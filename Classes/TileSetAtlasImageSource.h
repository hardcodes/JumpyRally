//
//  TileSet.h
//  Jumpy
//
//  Created by Sven Putze on 15.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TileSetTextureAtlas.h"

@class LevelResourceHandler;

	// This class contains the information of a tileset. That is a part of a TilEd TMX/XML-file describing a game level.
@interface TileSetAtlasImageSource : NSObject {
	
	int firstGID;
	NSString *tileSetName;
	int tileWidth;
	int tileHeight;
	NSString *imageSource;
	int imageWidth;
	int imageHeight;
	TileSetTextureAtlas *tileSetTexture;
	int tileMapWidth;
	int tileMapHeight;
	int tilesPerRow;
	LevelResourceHandler *levelResourceHandler;
	
}

@property(nonatomic, readonly) int firstGID;
@property(nonatomic, readonly) NSString *tileSetName;
@property(nonatomic, readonly) int tileWidth;
@property(nonatomic, readonly) int tileHeight;
@property(nonatomic, readonly) NSString *imageSource;
@property(nonatomic, readonly) int imageWidth;
@property(nonatomic, readonly) int imageHeight;
@property(nonatomic, readonly) TileSetTextureAtlas *tileSetTexture;



	// Selector initialiazes this class with all the values that have been read out of a TMX/XML-TilEd-file.
- (id)initWithTileSetName: (NSString*) aTileSetName
			  andFirstGID: (int) aGID
				tileWidth: (int) aTileWidth
			   tileHeight: (int) aTileHeight
			  imageSource: (NSString*) aImageSource
			   imageWidth: (int) aImageWidth
			  imageHeight: (int) aImageHeight
		 withTileMapWidth:(int) aTileMapWidth
		 andTileMapHeight:(int) aTileMapheight
withLevelResourceHandler: (LevelResourceHandler*) aLevelResourceHandler;



	// Selector draws the tile identified by the GID aTileGId at the given coordinates on the playfield.
	// The coordinates are tile-coordinates, e.g. 0,0 is the upper left corner. 5,1 is the 5th tile in the second row.
	// Drawing always is in Landscape-Left mode. So we will the same result independent from the user and his
	// way of holding the device.
- (void)drawTileWithGId: (int) aTileGId atXCoordinate: (int) aXCoordinate andYCoordinate: (int) aYCoordinate;


@end
