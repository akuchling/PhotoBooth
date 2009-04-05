//
//  StripDrawing.h
//  PhotoBooth
//
//  Created by Andrew Kuchling on 5/15/08.
//  Copyright 2008 Green Dragonfly LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PhotoBoothModel.h"

@interface StripDrawing : NSView {
  PhotoBoothModel *model;
}

- (void)drawRect:(NSRect)rect;
- (void)setModel:(PhotoBoothModel*)newModel;

@end
