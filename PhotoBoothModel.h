//file://localhost/Users/amk/Desktop/ObjC.pdf
//  PhotoBoothModel.h
//  PhotoBooth
//
//  Created by Andrew Kuchling on 5/9/08.
//  Copyright 2008 Green Dragonfly LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define ISIGHT_WIDTH 640
#define ISIGHT_HEIGHT 426

@interface PhotoBoothModel : NSObject {
  NSMutableArray *strips;
	
  int numStrips;        // number of strips total (0 .. totalStrips-1).
  int numPhotos;
  
  // True if this is a new, unsaved strip.
  BOOL unsavedStrip;
    
  // Strip currently being assembled
  NSImage *currentStrip;	
}

- init;

// Accessors
- (BOOL)isUnsavedStrip;  // true if this strip is unsaved and can be cleared.
- (int)numStrips;
- (int)numPhotos;

// Retrieval methods
- (NSImage*)getCurrentStrip;
- (NSImage*)getStrip:(int)num;
	
// Actions
- (void)startStrip;
- (void)saveStrip;
- (void)addPhoto:(NSImage*)photo;

@end
