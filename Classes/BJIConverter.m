//
//  BJIConverter.m
//  audioTest
//
//  Created by Jean-Pierre Simard on 12-07-19.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#import "BJIConverter.h"

@implementation BJIConverter

#pragma mark - utility functions -

// generic error handler - if result is nonzero, prints error message and exits program.
static void CheckResult(OSStatus result, const char *operation)
{
	if (result == noErr) return;
	
	char errorString[20];
	// see if it appears to be a 4-char-code
	*(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(result);
	if (isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) {
		errorString[0] = errorString[5] = '\'';
		errorString[6] = '\0';
	} else
		// no, format it as an integer
		sprintf(errorString, "%d", (int)result);
	
	fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
	
	exit(1);
}

#pragma mark - audio converter -
void Convert(MyAudioConverterSettings *mySettings)
{	
	
	UInt32 outputBufferSize = 32 * 1024; // 32 KB is a good starting point
	UInt32 sizePerPacket = mySettings->outputFormat.mBytesPerPacket;	
	UInt32 packetsPerBuffer = outputBufferSize / sizePerPacket;
	
	// allocate destination buffer
	UInt8 *outputBuffer = (UInt8 *)malloc(sizeof(UInt8) * outputBufferSize);
	
	UInt32 outputFilePacketPosition = 0; //in bytes
	while(1)
	{
		// wrap the destination buffer in an AudioBufferList
		AudioBufferList convertedData;
		convertedData.mNumberBuffers = 1;
		convertedData.mBuffers[0].mNumberChannels = mySettings->outputFormat.mChannelsPerFrame;
		convertedData.mBuffers[0].mDataByteSize = outputBufferSize;
		convertedData.mBuffers[0].mData = outputBuffer;
		
		UInt32 frameCount = packetsPerBuffer;
		
		// read from the extaudiofile
		CheckResult(ExtAudioFileRead(mySettings->inputFile,
                                 &frameCount,
                                 &convertedData),
                "Couldn't read from input file");
		
		if (frameCount == 0) {
			printf ("done reading from file");
			return;
		}
		
		// write the converted data to the output file
		CheckResult (AudioFileWritePackets(mySettings->outputFile,
                                       FALSE,
                                       frameCount,
                                       NULL,
                                       outputFilePacketPosition / mySettings->outputFormat.mBytesPerPacket, 
                                       &frameCount,
                                       convertedData.mBuffers[0].mData),
                 "Couldn't write packets to file");
		
		// advance the output file write location
		outputFilePacketPosition += (frameCount * mySettings->outputFormat.mBytesPerPacket);
	}
	
	// AudioConverterDispose(audioConverter);
}

+ (BOOL)convertFile:(NSString*)fileIn toFile:(NSString*)fileOut {
  MyAudioConverterSettings audioConverterSettings = {0};
	// open the input with ExtAudioFile
	CFURLRef inputFileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)fileIn, kCFURLPOSIXPathStyle, false);
	CheckResult(ExtAudioFileOpenURL(inputFileURL, 
                                  &audioConverterSettings.inputFile),
              "ExtAudioFileOpenURL failed");
  CFRelease(inputFileURL);
  MyAudioFormat fmt = MyAudioFormatCAF;
  if (fmt == MyAudioFormatAIFF) {
    // define the ouput format. AudioConverter requires that one of the data formats be LPCM
    audioConverterSettings.outputFormat.mSampleRate = 44100.0;
    audioConverterSettings.outputFormat.mFormatID = kAudioFormatLinearPCM;
    audioConverterSettings.outputFormat.mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioConverterSettings.outputFormat.mBytesPerPacket = 4;
    audioConverterSettings.outputFormat.mFramesPerPacket = 1;
    audioConverterSettings.outputFormat.mBytesPerFrame = 4;
    audioConverterSettings.outputFormat.mChannelsPerFrame = 2;
    audioConverterSettings.outputFormat.mBitsPerChannel = 16;
    
    // create output file
    CFURLRef outputFileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)fileOut, kCFURLPOSIXPathStyle, false);
    CheckResult (AudioFileCreateWithURL(outputFileURL, kAudioFileAIFFType, &audioConverterSettings.outputFormat, kAudioFileFlags_EraseFile, &audioConverterSettings.outputFile),
                 "AudioFileCreateWithURL failed");
    CFRelease(outputFileURL);
  } else if (fmt == MyAudioFormatCAF) {
    // define the ouput format. AudioConverter requires that one of the data formats be LPCM
    audioConverterSettings.outputFormat.mSampleRate = 44100.0;
    audioConverterSettings.outputFormat.mFormatID = kAudioFormatLinearPCM;
    audioConverterSettings.outputFormat.mFormatFlags =  kAudioFormatFlagsCanonical;
    audioConverterSettings.outputFormat.mBytesPerPacket = 4;
    audioConverterSettings.outputFormat.mFramesPerPacket = 1;
    audioConverterSettings.outputFormat.mBytesPerFrame = 4;
    audioConverterSettings.outputFormat.mChannelsPerFrame = 2;
    audioConverterSettings.outputFormat.mBitsPerChannel = 16;
    
    // create output file
    CFURLRef outputFileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)fileOut, kCFURLPOSIXPathStyle, false);
    CheckResult (AudioFileCreateWithURL(outputFileURL, kAudioFileCAFType, &audioConverterSettings.outputFormat, kAudioFileFlags_EraseFile, &audioConverterSettings.outputFile),
                 "AudioFileCreateWithURL failed");
    CFRelease(outputFileURL);
  } else if (fmt == MyAudioFormatAAC) {
    // define the ouput format. AudioConverter requires that one of the data formats be LPCM
    audioConverterSettings.outputFormat.mSampleRate = 44100.0;
    audioConverterSettings.outputFormat.mFormatID = kAudioFormatMPEG4AAC;
    audioConverterSettings.outputFormat.mFormatFlags =  kMPEG4Object_AAC_Main;
    audioConverterSettings.outputFormat.mBytesPerPacket = 0;
    audioConverterSettings.outputFormat.mFramesPerPacket = 1024;
    audioConverterSettings.outputFormat.mBytesPerFrame = 0;
    audioConverterSettings.outputFormat.mChannelsPerFrame = 2;
    audioConverterSettings.outputFormat.mBitsPerChannel = 0;
    audioConverterSettings.outputFormat.mReserved = 0;
    // create output file
    CFURLRef outputFileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)fileOut, kCFURLPOSIXPathStyle, false);
    CheckResult (AudioFileCreateWithURL(outputFileURL, kAudioFileM4AType, &audioConverterSettings.outputFormat, kAudioFileFlags_EraseFile, &audioConverterSettings.outputFile),
                 "AudioFileCreateWithURL failed");
    CFRelease(outputFileURL);
  }
	
	// set the PCM format as the client format on the input ext audio file
	CheckResult(ExtAudioFileSetProperty(audioConverterSettings.inputFile,
                                      kExtAudioFileProperty_ClientDataFormat,
                                      sizeof (AudioStreamBasicDescription),
                                      &audioConverterSettings.outputFormat),
              "Couldn't set client data format on input ext file");
	
	fprintf(stdout, "Converting...\n");
	Convert(&audioConverterSettings);
	
cleanup:
	// AudioFileClose(audioConverterSettings.inputFile);
	ExtAudioFileDispose(audioConverterSettings.inputFile);
	AudioFileClose(audioConverterSettings.outputFile);
  return YES;
}

+ (BOOL)convertFiles:(NSArray*)filesIn toFiles:(NSArray*)filesOut {
  [filesIn enumerateObjectsUsingBlock:^(NSString *fileIn, NSUInteger idx, BOOL *stop) {
    [self convertFile:fileIn toFile:[filesOut objectAtIndex:idx]];
  }];
  return YES;
}

@end
