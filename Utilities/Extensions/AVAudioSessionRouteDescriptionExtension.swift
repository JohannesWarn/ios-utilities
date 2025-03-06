//
//  AVAudioSessionRouteDescriptionExtension.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2023-10-30.
//

import Foundation
import AVFoundation

extension AVAudioSessionRouteDescription {
    
    var isHeadphones: Bool {
        if outputs.first?.portType != .builtInSpeaker && inputs.first?.portType != .builtInMic {
            return true
        } else {
            return false
        }
    }
    
    var isBluetoothSpeaker: Bool {
        if outputs.first?.portType != .builtInSpeaker && outputs.first?.portType != .builtInReceiver && inputs.first?.portType == .builtInMic {
            return true
        } else {
            return false
        }
    }
    
}
