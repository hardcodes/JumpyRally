	//
	//  Layer.m
	//  Jumpy
	//
	//  Created by Sven Putze on 15.04.11.
	//  Copyright 2011 hardcodes.de. All rights reserved.
	//

#import "Layer.h"
#import "NSDataAdditions.h"


@implementation Layer

@synthesize layerName;
@synthesize layerWidth;
@synthesize layerHeight;


#pragma mark - init 

- (id)initWithLayerName: (NSString*) aLayerName
				  Width: (int) aLayerWidth
				 Height: (int) aLayerHeight
	  Base64EncodedData: (NSString*) aBase64EncodedDataString
		   LayerTileSet: (TileSetAtlasImageSource*) aTileSet{
	
	self = [super init];
	if(self!= nil){
		
		layerName = aLayerName;
		layerWidth = aLayerWidth;
		layerHeight = aLayerHeight;
		base64EncodedData = aBase64EncodedDataString;
		tileSetAtlasImageSource = [aTileSet retain];
		textureID = [[tileSetAtlasImageSource tileSetTexture] textureID];
#if DEBUG
		NSLog(@"created layer: %@, width=%i, height=%i", layerName, layerWidth, layerHeight);
#endif
		
		[self decodeBase64Data:base64EncodedData];
		
	}
	
	return self;
}



- (id)init{
		// override standard init to prevent user from using this!
	[self dealloc];
	@throw [NSException exceptionWithName:@"HCBadInitCall" reason:@"You must use initWithLayerName: (NSString *) aLayerName(...)" userInfo:nil];
	return nil;
}



- (void) dealloc{
	
#if DEBUG
	NSLog(@"START dealloc: Layer");
#endif
		// dealloc might have been called from init
	if (tileSetAtlasImageSource) [tileSetAtlasImageSource release];
	[super dealloc];
#if DEBUG
	NSLog(@"END dealloc: Layer");
#endif
}


#pragma mark - helper methods 

- (void)decodeBase64Data:(NSString*) aBase64EncodedDataString{
	
#if DEBUG
	NSLog(@"base64: %@",aBase64EncodedDataString);
#endif
	
		// decode the base64 data using NSDataAdditions.h
	NSData * deflatedData = [NSData dataWithBase64EncodedString: aBase64EncodedDataString];
		// unzip the decoded data
	deflatedData = [deflatedData gzipInflate];
		// store data in array of int
	long arraySize = sizeof(int) * (layerWidth * layerHeight);
	if(arraySize != sizeof(layerData)){
		NSLog(@"sizeof bytesArray (%ld) does not match sizeof layerData(%ld)", arraySize, sizeof(layerData));
		return;
	}
		// the delivered data has the right size, read it in our array of integer.
	[deflatedData getBytes: layerData length: arraySize];
	
}



- (void)drawCompleteLayer{
	
		// bind the texture for the layer once
		// We use just one texture atlas for every layer of the
		// background - could be optimized but is still the most sane place
	glBindTexture(GL_TEXTURE_2D, textureID);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
		// walk vertical
	for(int yCoordinate=0;yCoordinate<layerHeight;++yCoordinate){
			// walk horizontal
		for(int xCoordinate=0;xCoordinate<layerWidth;++xCoordinate){
			
			[self drawTileAtXCoordinate: xCoordinate AndYCoordinate: yCoordinate];
		}
	}
}



- (void)drawTileAtXCoordinate: (int) aXCoordinate AndYCoordinate: (int) aYCoordinate{
	
	int tileGId = [self getTileGIdAtXCoordinate: aXCoordinate AndYCoordinate: aYCoordinate];
	
	[tileSetAtlasImageSource drawTileWithGId:tileGId atXCoordinate:aXCoordinate andYCoordinate:aYCoordinate];
	
}



- (int)getTileGIdAtXCoordinate: (int) aXCoordinate AndYCoordinate: (int) aYCoordinate{
	
		// get the right integer value out of the array of integer that has stored the level data.
	int tileGId = layerData[aYCoordinate * layerWidth + aXCoordinate];
	return tileGId;
	
}



- (void)setTileGId: (int) aGid atXCoordinate: (int) aXCoordinate AndYCoordinate: (int) aYCoordinate{
	
		// set the integer value aGid in the array of integer that has stored the level data.
	layerData[aYCoordinate * layerWidth + aXCoordinate] = aGid;
}


@end
