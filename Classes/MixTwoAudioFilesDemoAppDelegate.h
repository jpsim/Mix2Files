//
//  MixTwoAudioFilesDemoAppDelegate.h
//  MixTwoAudioFilesDemo
//
//  Created by Moses DeJong on 3/25/09.
//

#import <UIKit/UIKit.h>

@class MixTwoAudioFilesDemoViewController;

@interface MixTwoAudioFilesDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MixTwoAudioFilesDemoViewController *viewController;

@end
