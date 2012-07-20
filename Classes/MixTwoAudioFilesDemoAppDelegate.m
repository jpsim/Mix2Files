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
  
  NSArray *files = [self getFiles];
  NSArray *times = [self getTimes];
  NSString *mixURL = [self getMixURL];
  
	OSStatus status = [PCMMixer mixFiles:files atTimes:times toMixfile:mixURL];
  
  [self playMix:mixURL withStatus:status];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [avAudio release];
    [super dealloc];
}

- (NSArray*)getFiles {
  NSString *inFile = [[NSBundle mainBundle] pathForResource:@"toms.caf" ofType:nil];
  return [NSArray arrayWithObjects:inFile,inFile,inFile,inFile, nil];
}

- (NSArray *)getTimes {
  //  First item must be at time 0. All other sounds must be relative to this first sound.
  return [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3], nil];
}

- (NSString*)getMixURL {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Mix.caf"];
}

- (void)playMix:(NSString*)mixURL withStatus:(OSStatus)status {
  if (status == OSSTATUS_MIX_WOULD_CLIP) {
		[viewController.view setBackgroundColor:[UIColor redColor]];
	} else {
		[viewController.view setBackgroundColor:[UIColor greenColor]];
    
		NSURL *url = [NSURL fileURLWithPath:mixURL];
    
		NSData *urlData = [NSData dataWithContentsOfURL:url];
    
		NSLog(@"wrote mix file of size %d : %@", [urlData length], mixURL);
    
		AVAudioPlayer *avAudioObj = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [avAudioObj autorelease];
    self.avAudio = avAudioObj;
    
		[avAudioObj prepareToPlay];
		[avAudioObj play];
	}
}

@end
