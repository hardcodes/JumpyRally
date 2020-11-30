//
//  Layer.h
//  Jumpy
//
//  Created by Sven Putze on 15.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"
#import "TileSetAtlasImageSource.h"


	// This class provides storage and methods for a layer (part of a TilEd TMX/XML-file).
@interface Layer : NSObject {
	
	NSString *layerName;
	int layerWidth;
	int layerHeight;
	NSString *base64EncodedData;
	int layerData [HCMaxLayerWidth * HCMAXLayerHeight];
	TileSetAtlasImageSource *tileSetAtlasImageSource;
	GLuint textureID;
	
}

@property(nonatomic, readonly) NSString *layerName;
@property(nonatomic, readonly) int layerWidth;
@property(nonatomic, readonly) int layerHeight;


	// Selector stores the data for a layer in this class. Afterwards the data is decoded and stored in an array of int.
- (id)initWithLayerName: (NSString*) aLayerName
				  Width: (int) aLayerWidth
				 Height: (int) aLayerHeight
	  Base64EncodedData: (NSString*) aBase64EncodedDataString
		   LayerTileSet: (TileSetAtlasImageSource*) aTileSet;



	// Selector decodes the base64 encoded data of this layer and stores the raw data in an array of int.
- (void)decodeBase64Data:(NSString*) aBase64EncodedDataString;



	// Selector draws every tile of this layer on the screen.
- (void)drawCompleteLayer;



	// Selector draws a tile of the level on the playfield. The coordinates are used to get the GID of the tile (using
	// drawTileAtXCoordinate:aXCoordinate AndYCoordinate:)
	// Having that the tileset is told to draw the tile with that GID.
	// The coordinates are tile-coordinates, e.g. 0,0 is the upper left corner. 5,1 is the 5th tile in the second row.
- (void)drawTileAtXCoordinate: (int) aXCoordinate AndYCoordinate: (int) aYCoordinate;
	


	// Selector returns the integer value that is stored in layerData for the given X/Y-coordinates.
	// The integer value represents the GID which is an id for the tile in the tileset.
	// Remark: we support only one tileset so no need to calculate the GID for more than one tileset.
- (int)getTileGIdAtXCoordinate: (int) aXCoordinate AndYCoordinate: (int) aYCoordinate;



	// Selector changes a tile value in a layer, e.g. for deleting a woodbox after is has burned.
- (void)setTileGId: (int) aGid atXCoordinate: (int) aXCoordinate AndYCoordinate: (int) aYCoordinate;


@end
