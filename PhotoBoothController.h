//
//  PhotoBoothController.h
//  PhotoBooth
//
//  Created by Andrew Kuchling on 5/9/08.
//  Copyright 2008 Green Dragonfly LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaSequenceGrabber/CocoaSequenceGrabber.h>
#import "PhotoBoothModel.h"
#import "StripDrawing.h"
#import "CameraDrawing.h"
#import "PrintView.h"

// Interval in seconds between snapshots
#define PHOTO_DELAY 5
//#define ENABLE_PRINTING 1

@interface PhotoBoothController : NSObject {
	PhotoBoothModel *model;
	int currentStrip;
	int countdown;
	CSGCamera *camera;
	NSImage *frame;
	NSTimer *timer;

	IBOutlet StripDrawing *imageView;
	IBOutlet CameraDrawing *cameraView;
	IBOutlet PrintView *printView;
	IBOutlet NSButton *countdownButton;
	IBOutlet NSButton *takeButton;
	IBOutlet NSButton *printButton;
	IBOutlet NSButton *clearButton;
	
}

// Methods for jumping between displayed strips
- (void)previousStrip;
- (void)nextStrip;
- (void)firstStrip;
- (void)lastStrip;

- init;
- (void) startCamera;
- (void) stopCamera;
- (IBAction) takePictures:(id)sender;
- (IBAction) clear:(id)sender;
- (IBAction) print:(id)sender;

- (NSImage*)mirrorImage:(NSImage*)image;
- (void)timerHandler:(NSTimer*)theTimer;
- (void)snapshot;
- (void)saveStripToFilePDF;
- (void)saveStripToFilePNG;
- (NSString*) getNextPNGSaveFilename;
- (NSString*) getNextPDFSaveFilename;

@end
