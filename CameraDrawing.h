//
//  CameraDrawing.h
//  PhotoBooth
//
//  Created by Andrew Kuchling on 5/16/08.
//  Copyright 2008 Green Dragonfly LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PhotoBoothModel.h"

@interface CameraDrawing : NSImageView {
  PhotoBoothModel *model;
}

- (void)setModel:(PhotoBoothModel*)newModel;

@end
