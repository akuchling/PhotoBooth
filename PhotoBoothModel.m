//
//  PhotoBoothModel.m
//  PhotoBooth
//
//  Created by Andrew Kuchling on 5/9/08.
//  Copyright 2008 Green Dragonfly LLC. All rights reserved.
//

#import <stdlib.h>
#import "PhotoBoothModel.h"


@implementation PhotoBoothModel

- init {
	strips = [[NSMutableArray alloc] init];
	currentStrip = nil;
	unsavedStrip = false;
	return self;
}

- (BOOL)isUnsavedStrip {
	return unsavedStrip;
}

- (int)numStrips {
	return numStrips;
}

- (int)numPhotos {
	return numPhotos;
}

- (NSImage*)getCurrentStrip {
	return currentStrip;
}

- (NSImage*)getStrip:(int)num {
	return [strips objectAtIndex: num];
}

- (void)startStrip {
  [self saveStrip];
  currentStrip = [[NSImage alloc] init];
  [currentStrip setSize:NSMakeSize(ISIGHT_WIDTH*2, ISIGHT_HEIGHT*2)];
  numPhotos = 0;
}

- (void)addPhoto :(NSImage *)photo {
	NSRect rect;
	NSSize photo_size, strip_size;
	if (numPhotos >= 4) {
	  printf("Can't add more than 4 photos to a strip\n");
	  return;
	}
	assert (currentStrip != nil);
	
	// Get sizes
	photo_size = [photo size];
	strip_size = [currentStrip size];
	
	// Calculate location where the photo should be drawn
	if ((numPhotos % 2) == 0) {
	  /* Even number, so we're adding it to the left-hand side. */
	  rect.origin.x = 0;
	  rect.origin.y = ISIGHT_HEIGHT * (numPhotos/2);
	} else {
	  /* Odd number, so we're adding it to the right-hand side */
	  rect.origin.x = ISIGHT_WIDTH;
	  rect.origin.y = ISIGHT_HEIGHT * (numPhotos/2);
	}

	rect.size.width = photo_size.width;
	rect.size.height = photo_size.height;

#if 0	
	// Resize strip for the new photo
	strip_size.width = MAX(strip_size.width, 
			       rect.origin.x + rect.size.width);
	strip_size.height = MAX(strip_size.height, 
			        rect.origin.y + rect.size.height);
	[currentStrip setSize:strip_size];
#endif
	numPhotos++;
	if (numPhotos == 4) {
	  unsavedStrip = true;
	}

	// Add photo to strip
	[currentStrip lockFocus];
	[photo drawInRect: rect
		  fromRect: NSZeroRect
		 operation: NSCompositeSourceOver
		  fraction: 1.0];
	[currentStrip unlockFocus];
}

- (void)saveStrip {
  if (currentStrip != nil && unsavedStrip) {
    [strips addObject: currentStrip];
    unsavedStrip = false;
  }
}

@end
