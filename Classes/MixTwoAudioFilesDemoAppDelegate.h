//
//  MixTwoAudioFilesDemoAppDelegate.h
//  MixTwoAudioFilesDemo
//
//  Created by Moses DeJong on 3/25/09.
//

#import <UIKit/UIKit.h>

@class MixTwoAudioFilesDemoViewController;
@class AVAudioPlayer;

@interface MixTwoAudioFilesDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MixTwoAudioFilesDemoViewController *viewController;
    AVAudioPlayer* avAudio;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MixTwoAudioFilesDemoViewController *viewController;
@property (nonatomic, retain) AVAudioPlayer *avAudio;

@end

