//
//  TileSet.m
//  Jumpy
//
//  Created by Sven Putze on 15.04.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "TileSetAtlasImageSource.h"
#import "GameStateEngine.h"
#import "LevelResourceHandler.h"


@implementation TileSetAtlasImageSource

@synthesize firstGID;
@synthesize tileSetName;
@synthesize tileWidth;
@synthesize tileHeight;
@synthesize imageSource;
@synthesize imageWidth;
@synthesize imageHeight;
@synthesize tileSetTexture;


#pragma mark - init 

- (id)initWithTileSetName: (NSString*) aTileSetName
				 andFirstGID: (int) aGID
				tileWidth: (int) aTileWidth
			   tileHeight: (int) aTileHeight
			  imageSource: (NSString*) aImageSource
			   imageWidth: (int) aImageWidth
			  imageHeight: (int) aImageHeight
		 withTileMapWidth: (int) aTileMapWidth
		 andTileMapHeight: (int) aTileMapheight
 withLevelResourceHandler: (LevelResourceHandler*) aLevelResourceHandler{
	
	self = [super init];
    if (self != nil) {
		
		levelResourceHandler = [aLevelResourceHandler retain];
		tileSetName = aTileSetName;
		firstGID = aGID;
		tileWidth = aTileWidth;
		tileHeight = aTileHeight;
		imageSource = aImageSource;
		imageWidth = aImageWidth;
		imageHeight = aImageHeight;
		tileMapWidth = aTileMapWidth;
		tileMapHeight = aTileMapheight;
		tilesPerRow = imageWidth / tileWidth;
	
		tileSetTexture = [[levelResourceHandler getTileSetTextureFromDictionaryForImage: aImageSource] retain];
		
#if DEBUG
		NSLog(@"created TileSet %@",tileSetName);
#endif
		
	}
	
	return self;
}



- (id)init{
		// override standard init to prevent user from using this!
	[self dealloc];
	@throw [NSException exceptionWithName:@"HCBadInitCall" reason:@"You must use initWithTileSetName: (NSString *) aTileSetName(...)" userInfo:nil];
	return nil;
}



- (void) dealloc {
		
#if DEBUG
	NSLog(@"START dealloc: TileSet");
#endif
			// dealloc might have been called from init
	if (levelResourceHandler) [levelResourceHandler release]; 
	if (tileSetTexture) [tileSetTexture release];
	[super dealloc];
	
#if DEBUG
	NSLog(@"END dealloc: TileSet");
#endif
}


#pragma mark - drawing 

- (void)drawTileWithGId: (int) aTileGId atXCoordinate: (int) aXCoordinate andYCoordinate: (int) aYCoordinate{
	
		// GID = 0 = no content = nothing to do
	if(aTileGId==0) return;

		// get X,Y coordinates in the texture for this tile
	int tileYCoordinate = (aTileGId - firstGID) / tilesPerRow;
	int tileXCoordinate = (aTileGId - firstGID) % tilesPerRow;
	
	[tileSetTexture drawTileAtXCoordinate: (aXCoordinate * 16)
							andYCordinate: (aYCoordinate * 16)
							withTileWidth: tileWidth
							andTileHeight: tileHeight
					  withTileXCoordinate: tileXCoordinate
					   andTileYCoordinate: tileYCoordinate ];
	
}


@end
