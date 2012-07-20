//
//  BJIConverter.h
//  audioTest
//
//  Created by Jean-Pierre Simard on 12-07-19.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#include <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

@interface BJIConverter : NSObject
typedef enum MyAudioFormat {
  MyAudioFormatMP3,
  MyAudioFormatAAC,
  MyAudioFormatCAF,
  MyAudioFormatAIFF
} MyAudioFormat;

typedef struct MyAudioConverterSettings
{
  AudioStreamBasicDescription outputFormat; // output file's data stream description
  
  ExtAudioFileRef					inputFile; // reference to your input file
  AudioFileID					outputFile; // reference to your output file
  
} MyAudioConverterSettings;

void Convert(MyAudioConverterSettings *mySettings);
+ (BOOL)convertFile:(NSString*)fileIn toFile:(NSString*)fileOut;
+ (BOOL)convertFiles:(NSArray*)filesIn toFiles:(NSArray*)filesOut;

@end
