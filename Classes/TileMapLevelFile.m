	//
	//  TileMapManager.m
	//  Jumpy
	//
	//  20100415, Sven Putze
	//

#import "TileMapLevelFile.h"
#import "TBXML.h"
#import "Globals.h"


@implementation TileMapLevelFile

@synthesize tileMapWidth;
@synthesize tileMapHeight;
@synthesize tileWidth;
@synthesize tileHeight;
@synthesize tileMapLayers;


#pragma mark - init 

- (id)initWithFileName: (NSString*) aFileName
		 withExtension: (NSString*) aFileExtension
withLevelResourceHandler: (LevelResourceHandler*) aLevelResourceHandler{
	
	self = [super init];
    if (self != nil) {
		
		levelResourceHandler = [aLevelResourceHandler retain];
		
		tileMapLayers = [[NSMutableDictionary alloc] init];
#if DEBUG
		NSLog(@"loading tilemap XML file %@", aFileName);
#endif
		TBXML *tbXML = [[TBXML alloc] initWithXMLFile:aFileName fileExtension:aFileExtension];
#if DEBUG
		NSLog(@"tmxml: %@",tbXML);
#endif
		
			// parse the TilEd file 
#if DEBUG
		NSLog(@"parsing tilemap XML file");
#endif
		[self parseTilEdMapFileTMXXML:tbXML];
		[tbXML release];
	}
	
	return self;
	
}



- (id)init{
		// override standard init to prevent user from using this!
	[self dealloc];
	@throw [NSException exceptionWithName:@"HCBadInitCall" reason:@"You must use initWithFileName: (NSString *) aFileName(...)" userInfo:nil];
	return nil;
}



- (void)dealloc{
#if DEBUG
	NSLog(@"START dealloc: TileMap");
#endif
	if (levelResourceHandler) [levelResourceHandler release];
	[firstTileSet release];
	[tileMapLayers release];
	

	[super dealloc];
#if DEBUG
	NSLog(@"END dealloc: TileMap");
#endif
}


#pragma mark - helper methods 

- (void)parseTilEdMapFileTMXXML: (TBXML*) aTBXMLObject{

	TBXMLElement * xmlRootElement = aTBXMLObject.rootXMLElement;
    
    if (xmlRootElement) {
        
        tileMapWidth = [[TBXML valueOfAttributeNamed:@"width" forElement:xmlRootElement] intValue];
        tileMapHeight = [[TBXML valueOfAttributeNamed:@"height" forElement:xmlRootElement] intValue];
        tileWidth = [[TBXML valueOfAttributeNamed:@"tilewidth" forElement:xmlRootElement] intValue];
        tileHeight = [[TBXML valueOfAttributeNamed:@"tileheight" forElement:xmlRootElement] intValue];
        
#if DEBUG
        NSLog(@"tilemap dimensions are %ix%i, tilesize %ix%i", tileMapWidth, tileMapHeight, tileWidth, tileHeight);
#endif
		
		TBXMLElement * tileSetElement = [TBXML childElementNamed:@"tileset" parentElement:xmlRootElement];
		TBXMLElement * imageSourceElement = [TBXML childElementNamed:@"image" parentElement:tileSetElement];
        if (tileSetElement) {
			
			firstTileSet = [[TileSetAtlasImageSource alloc] initWithTileSetName: [TBXML valueOfAttributeNamed:@"name" forElement:tileSetElement]
													andFirstGID: [[TBXML valueOfAttributeNamed:@"firstgid" forElement:tileSetElement] intValue]
													  tileWidth: [[TBXML valueOfAttributeNamed:@"tileheight" forElement:tileSetElement] intValue]
													 tileHeight: [[TBXML valueOfAttributeNamed:@"tileheight" forElement:tileSetElement] intValue]
													imageSource: [TBXML valueOfAttributeNamed:@"source" forElement:imageSourceElement]
													 imageWidth: [[TBXML valueOfAttributeNamed:@"width" forElement:imageSourceElement] intValue]
													imageHeight: [[TBXML valueOfAttributeNamed:@"height" forElement:imageSourceElement] intValue]
											   withTileMapWidth: tileMapWidth
											   andTileMapHeight: tileHeight
									   withLevelResourceHandler: levelResourceHandler
							
							];
				// we support only one tileset, let's get out of here...
            
		}
		
		TBXMLElement * layerElement = [TBXML childElementNamed:@"layer" parentElement:xmlRootElement];
        while (layerElement) {
			
				// data encoding="base64" compression="zlib" is quietly assumed.
			TBXMLElement * dataElement = [TBXML childElementNamed:@"data" parentElement:layerElement];
			
			Layer * aLayer = [[Layer alloc] initWithLayerName: [TBXML valueOfAttributeNamed:@"name" forElement:layerElement]
														Width: [[TBXML valueOfAttributeNamed:@"width" forElement:layerElement] intValue] 
													   Height: [[TBXML valueOfAttributeNamed:@"height" forElement:layerElement] intValue] 
											Base64EncodedData: [TBXML textForElement:dataElement]
												 LayerTileSet: firstTileSet
							  ];
			
			[tileMapLayers setObject:aLayer forKey:[TBXML valueOfAttributeNamed:@"name" forElement:layerElement]];
			[aLayer release];
		
			layerElement = [TBXML nextSiblingNamed:@"layer" searchFromElement:layerElement];
		}
		
	}
	else {
		NSLog(@"ERROR: can not find root element");
	}
}


@end
