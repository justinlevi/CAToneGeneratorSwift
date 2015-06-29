//
//  AppDelegate.swift
//  CAHZFileGeneratorSwift
//
//  Created by Justin Winter on 6/17/15.
//  Copyright (c) 2015 wintercreative. All rights reserved.
//

import UIKit
import AudioToolbox
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func CheckError(error:OSStatus) -> String? {
    if error == 0 { return nil}
  
    switch(error) {
    case kAUGraphErr_NodeNotFound : return("Error:kAUGraphErr_NodeNotFound \n");
    case kAUGraphErr_OutputNodeErr : return( "Error:kAUGraphErr_OutputNodeErr \n");
    case kAUGraphErr_InvalidConnection : return("Error:kAUGraphErr_InvalidConnection \n");
    case kAUGraphErr_CannotDoInCurrentContext : return( "Error:kAUGraphErr_CannotDoInCurrentContext \n");
    case kAUGraphErr_InvalidAudioUnit : return( "Error:kAUGraphErr_InvalidAudioUnit \n");
    case kAudioToolboxErr_InvalidSequenceType : return( " kAudioToolboxErr_InvalidSequenceType ");
    case kAudioToolboxErr_TrackIndexError : return( " kAudioToolboxErr_TrackIndexError ");
    case kAudioToolboxErr_TrackNotFound : return( " kAudioToolboxErr_TrackNotFound ");
    case kAudioToolboxErr_EndOfTrack : return( " kAudioToolboxErr_EndOfTrack ");
    case kAudioToolboxErr_StartOfTrack : return( " kAudioToolboxErr_StartOfTrack ");
    case kAudioToolboxErr_IllegalTrackDestination	: return( " kAudioToolboxErr_IllegalTrackDestination");
    case kAudioToolboxErr_NoSequence : return( " kAudioToolboxErr_NoSequence ");
    case kAudioToolboxErr_InvalidEventType : return( " kAudioToolboxErr_InvalidEventType");
    case kAudioToolboxErr_InvalidPlayerState : return( " kAudioToolboxErr_InvalidPlayerState");
    case kAudioUnitErr_InvalidProperty : return( " kAudioUnitErr_InvalidProperty");
    case kAudioUnitErr_InvalidParameter	: return( " kAudioUnitErr_InvalidParameter");
    case kAudioUnitErr_InvalidElement	: return( " kAudioUnitErr_InvalidElement");
    case kAudioUnitErr_NoConnection	: return( " kAudioUnitErr_NoConnection");
    case kAudioUnitErr_FailedInitialization	: return( " kAudioUnitErr_FailedInitialization");
    case kAudioUnitErr_TooManyFramesToProcess	: return( " kAudioUnitErr_TooManyFramesToProcess");
    case kAudioUnitErr_InvalidFile : return( " kAudioUnitErr_InvalidFile");
    case kAudioUnitErr_FormatNotSupported	: return( " kAudioUnitErr_FormatNotSupported");
    case kAudioUnitErr_Uninitialized : return( " kAudioUnitErr_Uninitialized");
    case kAudioUnitErr_InvalidScope	: return( " kAudioUnitErr_InvalidScope");
    case kAudioUnitErr_PropertyNotWritable	: return( " kAudioUnitErr_PropertyNotWritable");
    case kAudioUnitErr_InvalidPropertyValue	: return( " kAudioUnitErr_InvalidPropertyValue");
    case kAudioUnitErr_PropertyNotInUse	: return( " kAudioUnitErr_PropertyNotInUse");
    case kAudioUnitErr_Initialized : return( " kAudioUnitErr_Initialized");
    case kAudioUnitErr_InvalidOfflineRender	: return( " kAudioUnitErr_InvalidOfflineRender");
    case kAudioUnitErr_Unauthorized	: return( " kAudioUnitErr_Unauthorized");
    default: return("huh?")
    }
  }


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let SAMPLE_RATE:Float64 = 44100                                       // 1
    let DURATION = 2.0                                                    // 2
    let HZ:Double = 440
    let FILE_NAME = "\(HZ)-saw.aif"                                      // 3
    
    let fileManager = NSFileManager.defaultManager()
    let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    if let documentDirectory: NSURL = urls.first {
      let fileURL = documentDirectory.URLByAppendingPathComponent(FILE_NAME)
      print(fileURL)
      
      
      // Prepare the format
      var audioFormat = AudioStreamBasicDescription()                     // 6
      audioFormat.mSampleRate       = SAMPLE_RATE;                        // 8
      audioFormat.mFormatID         = UInt32(kAudioFormatLinearPCM)
      audioFormat.mFormatFlags      = UInt32(kLinearPCMFormatFlagIsBigEndian) |
                                      UInt32(kLinearPCMFormatFlagIsSignedInteger) |
                                      UInt32(kLinearPCMFormatFlagIsPacked)
      audioFormat.mBitsPerChannel   = UInt32(16)
      audioFormat.mChannelsPerFrame = 1 // Mono
      audioFormat.mBytesPerFrame    = UInt32(audioFormat.mChannelsPerFrame * 2)
      audioFormat.mFramesPerPacket  = 1
      audioFormat.mBytesPerPacket   = audioFormat.mFramesPerPacket * audioFormat.mBytesPerFrame
      
      var audioFile:AudioFileID = nil
      var theErr = OSStatus(noErr)
                                                                          // 9
      theErr = AudioFileCreateWithURL(fileURL, UInt32(kAudioFileAIFFType), &audioFormat, .EraseFile, &audioFile)
      if theErr != 0 { print(CheckError(theErr)) }
      
      let maxSampleCount = CLong(SAMPLE_RATE * DURATION)                  // 10
      var sampleCount = 0
      var bytesToWrite:UInt32 = 2
      let wavelengthInSamples = SAMPLE_RATE / HZ                          // 11
      
      while sampleCount < maxSampleCount {
        for i in 0..<Int(wavelengthInSamples){
          
          // Square Wave
          //var sample = Int16(i < Int(wavelengthInSamples) / 2 ? Int16.max : Int16.min).bigEndian //12 & 13
          
          // Saw Tooth : Kind of...
          var sample = Int16(((Double(i) / wavelengthInSamples) * Double(Int16.max) * 2) - Double(Int16.max)).bigEndian
          
          // Sine Sample
          //var sample = Int16(Double(Int16.max) * sin(2 * M_PI * (Double(i) / wavelengthInSamples))).bigEndian
          
          theErr = AudioFileWriteBytes(audioFile, 0, Int64(sampleCount * 2), &bytesToWrite, &sample)
          if theErr != 0 { print(CheckError(theErr)) }
          
          sampleCount++
                                                                          // 15
        }
      }
      theErr = AudioFileClose(audioFile)                                  // 16
      if theErr != 0 { print(CheckError(theErr)) }
    }
    
    return true
  }

}

