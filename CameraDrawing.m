//
//  CameraDrawing.m
//  PhotoBooth
//
//  Created by Andrew Kuchling on 5/16/08.
//  Copyright 2008 Green Dragonfly LLC. All rights reserved.
//

#import <CocoaSequenceGrabber/CocoaSequenceGrabber.h>
#import "CameraDrawing.h"

@implementation CameraDrawing

- (id)init {
  return self;
}

- (void)setModel:(PhotoBoothModel*)newModel {
   model = newModel;
}

#if 0
- (void)drawRect:(NSRect)rect {
  return;
  NSSize size = [frame size];
  NSRect origin = NSMakeRect(0,0, size.width, size.height );

  [self lockFocus];
  [frame drawInRect: origin
	 fromRect: NSZeroRect
	 operation: NSCompositeSourceOver
	 fraction: 1.0];
  [self unlockFocus];
}
#endif
@end
