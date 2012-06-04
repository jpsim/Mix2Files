//
//  PCMMixer.h
//
//  Created by Moses DeJong on 3/25/09.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>

// Returned as the value of the OSStatus argument to mix when the sound samples
// values would clip when mixed together. If a mix would clip then the output
// file is not generated.

#define OSSTATUS_MIX_WOULD_CLIP 8888


@interface PCMMixer : NSObject {

}

+ (OSStatus) mix:(NSString*)file1 file2:(NSString*)file2 mixfile:(NSString*)mixfile;

@end
