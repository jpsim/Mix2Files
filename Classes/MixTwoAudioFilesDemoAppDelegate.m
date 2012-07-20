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
@synthesize avAudio;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

    // Override point for customization after app launch
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
  
  NSString *resName1 = @"funk.caf";
//	NSString *resName2 = @"Drums.caf";
//  NSString *resName3 = @"tk.caf";
//  NSString *resName4 = @"Violin.caf";
  
	NSString *resPath1 = [[NSBundle mainBundle] pathForResource:resName1 ofType:nil];
//	NSString *resPath2 = [[NSBundle mainBundle] pathForResource:resName2 ofType:nil];
//  NSString *resPath3 = [[NSBundle mainBundle] pathForResource:resName3 ofType:nil];
//  NSString *resPath4 = [[NSBundle mainBundle] pathForResource:resName4 ofType:nil];
  
  //	NSString *tmpDir = NSTemporaryDirectory();
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *tmpFilename = @"Mix.caf";
	NSString *tmpPath = [docDir stringByAppendingPathComponent:tmpFilename];
  
	OSStatus status;
  
	status = [PCMMixer mixFiles:[NSArray arrayWithObjects:resPath1,resPath1, nil] atTimes:nil toMixfile:tmpPath];
  
	if (status == OSSTATUS_MIX_WOULD_CLIP) {
		[viewController.view setBackgroundColor:[UIColor redColor]];
	} else {
		[viewController.view setBackgroundColor:[UIColor greenColor]];
    
		NSURL *url = [NSURL fileURLWithPath:tmpPath];
    
		NSData *urlData = [NSData dataWithContentsOfURL:url];
    
		NSLog(@"wrote mix file of size %d : %@", [urlData length], tmpPath);
    
		AVAudioPlayer *avAudioObj = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [avAudioObj autorelease];
    self.avAudio = avAudioObj;
    
		[avAudioObj prepareToPlay];
		[avAudioObj play];
	}

}

- (void)dealloc {
    [viewController release];
    [window release];
    [avAudio release];
    [super dealloc];
}

@end
