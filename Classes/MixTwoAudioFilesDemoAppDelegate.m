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
	
	NSTimer *doAudioTimer = [NSTimer timerWithTimeInterval: 1.0
													target: self
												  selector: @selector(doAudioCallback:)
												  userInfo: NULL
												   repeats: FALSE];

    [[NSRunLoop currentRunLoop] addTimer: doAudioTimer forMode: NSDefaultRunLoopMode];	
}

- (void) doAudioCallback: (NSTimer *)timer {
	NSString *resName1 = @"Drums.caf";

// This softer violin track will mix properly

	NSString *resName2 = @"Violin.caf";

// This loud violin track will not mix properly because the audio would clip

//	NSString *resName2 = @"ViolinTooLoud.caf";

	NSString *resPath1 = [[NSBundle mainBundle] pathForResource:resName1 ofType:nil];
	NSString *resPath2 = [[NSBundle mainBundle] pathForResource:resName2 ofType:nil];

	NSString *tmpDir = NSTemporaryDirectory();
	NSString *tmpFilename = @"Lesson_Mix.caf";
	NSString *tmpPath = [tmpDir stringByAppendingPathComponent:tmpFilename];

	OSStatus status;

	status = [PCMMixer mix:resPath1 file2:resPath2 mixfile:tmpPath];

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
