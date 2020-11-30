//
//  TileSetTexture.h
//  Jumpy
//
//  Created by Sven Putze on 18.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Texture.h"


@interface TileSetTextureAtlas : Texture {
	
	
}



	// Selector draws the tile identified by the GID aTileGId at the given coordinates on the playfield.
	// The coordinates are tile-coordinates, e.g. 0,0 is the upper left corner. 5,1 is the 5th tile in the second row.
	// Drawing always is in Landscape-Left mode. So we will the same result independent from the user and his
	// way of holding the device.
- (void)drawTileAtXCoordinate: (GLuint) aDrawingXCoordinate
				andYCordinate: (GLuint) aDrawingYCoordinate
				withTileWidth: (GLuint) aTileWidth
				andTileHeight: (GLuint) aTileHeight
		  withTileXCoordinate: (GLuint) aAtlasXCoordinate
		   andTileYCoordinate: (GLuint) aAtlasYCoordinate;

@end
