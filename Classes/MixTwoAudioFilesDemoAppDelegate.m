//
//  MixTwoAudioFilesDemoAppDelegate.m
//  MixTwoAudioFilesDemo
//
//  Created by Moses DeJong on 3/25/09.
//

#import "MixTwoAudioFilesDemoAppDelegate.h"
#import "MixTwoAudioFilesDemoViewController.h"
#import "PCMMixer.h"

#import <AVFoundation/AVAudioPlayer.h>

@implementation MixTwoAudioFilesDemoAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

    // Override point for customization after app launch
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
  
	NSString *resPath1 = [[NSBundle mainBundle] pathForResource:@"Drums.caf" ofType:nil];
	NSString *resPath2 = [[NSBundle mainBundle] pathForResource:@"Violin.caf" ofType:nil]; // @"ViolinTooLoud.caf"

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *tmpFilename = @"Mix.caf";
	NSString *tmpPath = [docDir stringByAppendingPathComponent:tmpFilename];
  
	OSStatus status;
  
	status = [PCMMixer mix:resPath1 file2:resPath2 mixfile:tmpPath];
  NSLog(@"status: %ld",status);
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
