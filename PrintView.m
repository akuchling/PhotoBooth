//
//  PrintView.m
//  PhotoBooth
//
//  Created by Andrew Kuchling on 5/21/08.
//  Copyright 2008 Green Dragonfly LLC. All rights reserved.
//

#import "PrintView.h"
#import "PhotoBoothModel.h"

@implementation PrintView

- (void)setModel:(PhotoBoothModel*)newModel {
   model = newModel;
}

- (void)drawRect:(NSRect)rect {
  NSImage *strip;
  NSPrintInfo *print_info;
  NSRect bounds;

  print_info = [NSPrintInfo sharedPrintInfo];
  bounds = [print_info imageablePageBounds];
  strip = [model getCurrentStrip];

  printf("passed-in rect %f %f %f %f\n",
  	 rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
  printf("bounds of drawing %f %f %f %f\n",
  	 bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);

  float avail_width = (bounds.size.width);
  float avail_height= (bounds.size.height);
  printf("available paper = %f %f\n", avail_width, avail_height);

  [self lockFocus];
  [strip drawInRect: bounds
	 fromRect: NSZeroRect
	 operation: NSCompositeSourceOver
	 fraction: 1.0];
  [self unlockFocus];
}


@end
