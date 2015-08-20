//
//  AudioError.swift
//  CAToneFileGeneratorSwift
//
//  Created by Justin Winter on 7/2/15.
//  Copyright © 2015 wintercreative. All rights reserved.
//

import Foundation
import AudioToolbox

enum AudioError: String, ErrorType {
  case NodeNotFound             	= "NodeNotFound"
  case OutputNodeErr            	= "OutputNodeErr"
  case InvalidConnection        	= "InvalidConnection"
  case CannotDoInCurrentContext 	= "CannotDoInCurrentContext"
  case InvalidAudioUnit         	= "InvalidAudioUnit"
  case InvalidSequenceType      	= "InvalidSequenceType"
  case TrackIndexError          	= "TrackIndexError"
  case TrackNotFound            	= "TrackNotFound"
  case EndOfTrack               	= "EndOfTrack"
  case StartOfTrack             	= "StartOfTrack"
  case IllegalTrackDestination  	= "IllegalTrackDestination"
  case NoSequence               	= "NoSequence"
  case InvalidEventType         	= "InvalidEventType"
  case InvalidPlayerState       	= "InvalidPlayerState"
  case InvalidProperty          	= "InvalidProperty"
  case InvalidParameter         	= "InvalidParameter"
  case InvalidElement           	= "InvalidElement"
  case NoConnection             	= "NoConnection"
  case FailedInitialization     	= "FailedInitialization"
  case TooManyFramesToProcess   	= "TooManyFramesToProcess"
  case InvalidFile              	= "InvalidFile"
  case FormatNotSupported       	= "FormatNotSupported"
  case Uninitialized            	= "Uninitialized"
  case InvalidScope             	= "InvalidScope"
  case PropertyNotWritable      	= "PropertyNotWritable"
  case InvalidPropertyValue     	= "InvalidPropertyValue"
  case PropertyNotInUse         	= "PropertyNotInUse"
  case Initialized              	= "Initialized"
  case InvalidOfflineRender     	= "InvalidOfflineRender"
  case Unauthorized             	= "Unauthorized"
  case Unknown                  	= "Unknown"
  
  
  init?(err: OSStatus){
    if let ae = AudioError.errorFromOSStatus(err) {
      self = ae
    }else{
      return nil
    }
  }
  
  
  /// Returns the appropriate error for the sattus, or nil if successful
  /// or unknown for a code that doesn't match
  static func errorFromOSStatus(rawStatus:OSStatus) -> AudioError? {
    switch rawStatus {
    case 0 : return nil
    case kAUGraphErr_NodeNotFound : return .NodeNotFound
    case kAUGraphErr_NodeNotFound : return .NodeNotFound
    case kAUGraphErr_OutputNodeErr : return .OutputNodeErr
    case kAUGraphErr_InvalidConnection : return .InvalidConnection
    case kAUGraphErr_CannotDoInCurrentContext : return .CannotDoInCurrentContext
    case kAUGraphErr_InvalidAudioUnit : return .InvalidAudioUnit
    case kAudioToolboxErr_InvalidSequenceType : return .InvalidSequenceType
    case kAudioToolboxErr_TrackIndexError : return .TrackIndexError
    case kAudioToolboxErr_TrackNotFound : return .TrackNotFound
    case kAudioToolboxErr_EndOfTrack : return .EndOfTrack
    case kAudioToolboxErr_StartOfTrack : return .StartOfTrack
    case kAudioToolboxErr_IllegalTrackDestination	: return .IllegalTrackDestination
    case kAudioToolboxErr_NoSequence : return .NoSequence
    case kAudioToolboxErr_InvalidEventType : return .InvalidEventType
    case kAudioToolboxErr_InvalidPlayerState : return .InvalidPlayerState
    case kAudioUnitErr_InvalidProperty : return .InvalidProperty
    case kAudioUnitErr_InvalidParameter	: return .InvalidParameter
    case kAudioUnitErr_InvalidElement	: return .InvalidElement
    case kAudioUnitErr_NoConnection	: return .NoConnection
    case kAudioUnitErr_FailedInitialization	: return .FailedInitialization
    case kAudioUnitErr_TooManyFramesToProcess	: return .TooManyFramesToProcess
    case kAudioUnitErr_InvalidFile : return .InvalidFile
    case kAudioUnitErr_FormatNotSupported	: return .FormatNotSupported
    case kAudioUnitErr_Uninitialized : return .Uninitialized
    case kAudioUnitErr_InvalidScope	: return .InvalidScope
    case kAudioUnitErr_PropertyNotWritable	: return .PropertyNotWritable
    case kAudioUnitErr_InvalidPropertyValue	: return .InvalidPropertyValue
    case kAudioUnitErr_PropertyNotInUse	: return .PropertyNotInUse
    case kAudioUnitErr_Initialized : return .Initialized
    case kAudioUnitErr_InvalidOfflineRender	: return .InvalidOfflineRender
    case kAudioUnitErr_Unauthorized	: return .Unauthorized
    default: return .Unknown
    }
  }
}
