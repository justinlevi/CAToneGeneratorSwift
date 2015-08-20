//
//  AppDelegate.swift
//  CAHZFileGeneratorSwift
//
//  Created by Justin Winter on 6/17/15.
//  Copyright (c) 2015 wintercreative. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let SAMPLE_RATE:Float64 = 44100                                       // 1
    let DURATION = 2.0                                                    // 2
    let HZ:Double = 440 // Middle A or Concert A - Number of cycles per second
    let FILE_NAME = "\(HZ)-sine.aif"                                      // 3
    
    let fileManager = NSFileManager.defaultManager()
    let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    if let documentDirectory: NSURL = urls.first {
      let fileURL = documentDirectory.URLByAppendingPathComponent(FILE_NAME)
      print(fileURL)
      
      
      // Prepare the format
      var audioFormat = AudioStreamBasicDescription()                     // 6
      audioFormat.mSampleRate       = SAMPLE_RATE; //44,100               // 8
      audioFormat.mFormatID         = UInt32(kAudioFormatLinearPCM)
      audioFormat.mBitsPerChannel   = UInt32(16) //16-bit sample
      audioFormat.mChannelsPerFrame = 1 // Mono
      audioFormat.mFramesPerPacket  = 1 // LPCM Doesn't use packets
      audioFormat.mBytesPerFrame    = UInt32(audioFormat.mChannelsPerFrame * 2) // each frame has 2 bytes
      audioFormat.mBytesPerPacket   = audioFormat.mFramesPerPacket * audioFormat.mBytesPerFrame
      audioFormat.mFormatFlags      = UInt32(kLinearPCMFormatFlagIsBigEndian) |
                                      UInt32(kLinearPCMFormatFlagIsSignedInteger) |
                                      UInt32(kLinearPCMFormatFlagIsPacked)
      //NOTE: mFormatFlags varies based on the format you're using
      
      var audioFile:AudioFileID = nil
      var theErr = OSStatus(noErr)
                                                                          // 9
      theErr = AudioFileCreateWithURL(fileURL, UInt32(kAudioFileAIFFType), &audioFormat, .EraseFile, &audioFile)
      
      if let err = AudioError(err: theErr) { print(err) }
      
      let maxSampleCount = CLong(SAMPLE_RATE * DURATION)                  // 10
      var sampleCount = 0
      var bytesToWrite:UInt32 = 2
      
      //44,100 Hz / 440 Hz = 100.22
      let wavelengthInSamples = SAMPLE_RATE / HZ                          // 11
      
      while sampleCount < maxSampleCount {
        for i in 0..<Int(wavelengthInSamples){
          
          // Square Wave
          //var sample = Int16(i < Int(wavelengthInSamples) / 2 ? Int16.max : Int16.min).bigEndian //12 & 13
          
          // Saw Tooth
          // var sample = Int16(((Double(i) / wavelengthInSamples) * Double(Int16.max) * 2) - Double(Int16.max)).bigEndian
          
          // Sine Sample
          var sample = Int16(Double(Int16.max) * sin(2 * M_PI * (Double(i) / wavelengthInSamples))).bigEndian
          
          theErr = AudioFileWriteBytes(audioFile, false, Int64(sampleCount * 2), &bytesToWrite, &sample)
          if let err = AudioError.errorFromOSStatus(theErr) { print(err) }
          
          sampleCount++
                                                                          // 15
        }
      }
      theErr = AudioFileClose(audioFile)                                  // 16
      if let err = AudioError.errorFromOSStatus(theErr) { print(err) }
    }
    
    return true
  }

}

