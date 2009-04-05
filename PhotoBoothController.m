//
//  PhotoBoothController.m
//  PhotoBooth
//
//  Created by Andrew Kuchling on 5/9/08.
//  Copyright 2008 Green Dragonfly LLC. All rights reserved.
//

#import <stdio.h>
#import "PhotoBoothController.h"
#import "PrintView.h"

@implementation PhotoBoothController

- init {
	model = [[PhotoBoothModel alloc] init];
	camera = nil;
	currentStrip = 0;
	[self startCamera];
	return self;
}

- (void)previousStrip {
	if (currentStrip > 0)
		currentStrip--;
}

- (void)nextStrip {
	if (currentStrip < [model numStrips]-1)
		currentStrip++;
}

- (void)firstStrip {
	currentStrip = 0;
}

- (void)lastStrip {
	int totalStrips = [model numStrips];
	if (totalStrips > 0) {
		currentStrip = totalStrips-1;		
	} else {
		currentStrip = 0;
	}
}

- (IBAction) takePictures:(id)sender {
  SEL selector = @selector(timerHandler:);
  timer = [NSTimer scheduledTimerWithTimeInterval:
		     (double)1.0 
		     target:self selector:selector userInfo:nil
		     repeats:YES];
  printf("timer set\n");
  [takeButton setEnabled :NO];
  countdown = PHOTO_DELAY;
}

- (void) timerHandler:(NSTimer *)theTimer {
  NSString *buttonTitle;
  NSFont *font = [NSFont systemFontOfSize :56];

  countdown--;
  printf("countdown %d\n", countdown);
  buttonTitle = [NSString stringWithFormat:@"%d", countdown];
  [countdownButton setFont :font];
  [countdownButton setTitle :buttonTitle ];

  if (countdown == 0) {
    NSSound *sound = [NSSound soundNamed :@"Tink"];
    [sound play];
    countdown = PHOTO_DELAY;
    
    [self snapshot];
    if ([model numPhotos] == 4) {
      [model saveStrip];
      [self saveStripToFilePDF];
      [self saveStripToFilePNG];
      if ([theTimer isValid]) {
	[theTimer invalidate];
	[takeButton setEnabled :YES];
      }
    }
  }
}

- (NSImage*) mirrorImage:(NSImage*)image {
  NSImage *new = [[NSImage alloc] initWithSize :[image size]];
  [new lockFocus];
  NSAffineTransform *transform = [NSAffineTransform transform];
  NSSize size = [image size];
  [transform translateXBy:size.width yBy:0.0];
  [transform scaleXBy:-1.0 yBy: 1.0];
  [transform concat];

  [image drawAtPoint: NSMakePoint(0, 0)
	 fromRect: NSZeroRect
	 operation: NSCompositeSourceOver
	 fraction: 1.0];
  [new unlockFocus];
  return new;
}

- (void) snapshot {
	NSRect origin = {0,0,0,0};
	NSSize strip_size;
	NSImage *strip;
	NSImage *photo;
	
	printf("snapshot called\n");
	if ([model numPhotos] == 4) {
	    [model startStrip];
	}

	photo = [frame copy];

	//NSString *filename = @"/tmp/amk-headshot-192x192.jpg";
	//[[NSImage alloc] initWithContentsOfFile:filename];

	// XXX need to clip, not rescale
	[photo setSize :NSMakeSize(640, 426)];
	[imageView setModel :model];
	[cameraView setModel :model];

	strip = [model getCurrentStrip];
	if (strip == nil) {
	  [model startStrip];
	  strip = [model getCurrentStrip];
	}
	
	if (photo != nil) {
	  [model addPhoto :photo];
	}
	strip_size = [strip size];
	origin.size.width = strip_size.width;
	origin.size.height = strip_size.height;
	[imageView display];
}

- (void) startCamera {
	if (camera == nil) {
	  camera = [[CSGCamera alloc] init];
	  [camera setDelegate :self];
	  [camera startWithSize :NSMakeSize(640, 480)];
	}
}

- (void) stopCamera {
  if (camera != nil) {
    [camera stop];
    camera = nil;
  }
}

- (void) camera:(CSGCamera *)aCamera didReceiveFrame:(CSGImage *)newFrame {
  //printf("frame received\n");
  //frame = newFrame;
  frame = [self mirrorImage :newFrame];
  [cameraView setImage :frame];
  [frame release];
}

- (IBAction) clear:(id)sender {
  [model startStrip];
  [imageView display];
}

- (IBAction) print:(id)sender {
#ifdef ENABLE_PRINTING
  NSPrintInfo *print_info;
  NSPrintOperation *print_op;
#endif

  [self stopCamera];
#ifdef ENABLE_PRINTING
  printf("printing\n");
  print_info = [NSPrintInfo sharedPrintInfo];
  [print_info setVerticalPagination :NSFitPagination];
  [print_info setHorizontalPagination :NSFitPagination];
  [printView setModel :model];
  print_op = [NSPrintOperation printOperationWithView :printView
			       printInfo:print_info];
  //[print_op setShowPanels :NO];
  [print_op runOperation];
#endif
  [self startCamera];
}

- (void)saveStripToFilePNG {
  NSData *pngData;
  NSString *filename;
  NSBitmapImageRep *bitmapRep;

  [imageView lockFocus];
  bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:[imageView bounds]];
  [imageView unlockFocus];

  printf("saving to PNG\n");
  filename = [self getNextPNGSaveFilename];
  pngData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
  [bitmapRep release];
  [pngData writeToFile :filename atomically:YES];
}

- (void)saveStripToFilePDF {
  NSImage *strip = [model getCurrentStrip];
  NSSize strip_size;
  NSData *pdfData;
  NSString *filename;

  filename = [self getNextPDFSaveFilename];
  printf("saving to PDF\n");
  strip_size = [strip size];
  pdfData = [imageView dataWithPDFInsideRect:
			 [imageView bounds]];
  [pdfData writeToFile :filename atomically:YES];
}

- (NSString*) getNextPNGSaveFilename {
  NSString *filename;
  NSFileManager *mgr = [NSFileManager defaultManager];
  int count = 1;

  while (true) {
    filename = [NSString stringWithFormat:@"/Users/podcast/photo-strips/%d.png",
			 count];
    if (![mgr fileExistsAtPath:filename]) {
      return filename;
    }
    count++;
  }
}

- (NSString*) getNextPDFSaveFilename {
  NSString *filename;
  NSFileManager *mgr = [NSFileManager defaultManager];
  int count = 1;

  while (true) {
    filename = [NSString stringWithFormat:@"/Users/podcast/photo-strips/%d.pdf",
			 count];
    if (![mgr fileExistsAtPath:filename]) {
      return filename;
    }
    count++;
  }
}

@end

