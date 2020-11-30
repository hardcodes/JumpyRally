//
//  PersistanceHandler.m
//  Jumpy
//
//  Created by Sven Putze on 29.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "PersistanceHandler.h"


@implementation PersistanceHandler




+ (BOOL) archiveObject: (id) aObject toNSDocumentDirectoryWithFileName: (NSString*) aFileName{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *archivePath = [documentsDirectory stringByAppendingPathComponent: aFileName];
	NSLog(@"archiving/saving object %@ to %@", aObject, archivePath);
	
	return [NSKeyedArchiver archiveRootObject: aObject toFile: archivePath];
}



+ (id) decodeObjectFromNSDocumentDirectoryWithFileName: (NSString*) aFileName{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *archivePath = [documentsDirectory stringByAppendingPathComponent: aFileName];
	NSLog(@"loading object from %@", archivePath);
	
	return [NSKeyedUnarchiver unarchiveObjectWithFile: archivePath];
	
}


@end
