//
//  StripDrawing.m
//  PhotoBooth
//
//  Created by Andrew Kuchling on 5/15/08.
//  Copyright 2008 Green Dragonfly LLC. All rights reserved.
//

#import "StripDrawing.h"
#import "PhotoBoothModel.h"

@implementation StripDrawing

- (void)setModel:(PhotoBoothModel*)newModel {
   model = newModel;
}

- (void)drawRect:(NSRect)rect {
  NSRect origin = {0,0,0,0};
  NSImage *strip;

  //printf("strip drawing %f %f %f %f\n",
  //	 rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
  strip = [model getCurrentStrip];
  origin.origin.x = 0;
  origin.origin.y = 0;
  origin.size.width = 640;
  origin.size.height = 426;
  [self lockFocus];
  [strip drawInRect: origin 
	 fromRect: NSZeroRect
	 operation: NSCompositeSourceOver
	 fraction: 1.0];
  [self unlockFocus];
}

@end
