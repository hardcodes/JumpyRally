//
//  PersistanceHandler.h
//  Jumpy
//
//  Created by Sven Putze on 29.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PersistanceHandler : NSObject {
    
}

	// Here are some convinience methods to save and load data.

	// Selector archives the given object and stores it permanently to the NSDocumentDirectory
	// which is <Application_Home>/Documents
+ (BOOL) archiveObject: (id) aObject toNSDocumentDirectoryWithFileName: (NSString*) aFileName;


	// Selector loads and decodes (unarchives) the given file which must be located in
	// the NSDocumentDirectory = <Application_Home>/Documents
+ (id) decodeObjectFromNSDocumentDirectoryWithFileName: (NSString*) aFileName;


@end
