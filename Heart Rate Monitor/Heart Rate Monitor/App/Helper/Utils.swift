//
//  Utils.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 22/05/2021.
//

import Foundation
import AVFoundation

class Utils {
    static func playLocalAudio(named: String, withExtension: String) {
        guard let startURL = Bundle.main.url(forResource: named, withExtension: withExtension) else { return }
        let player = try? AVAudioPlayer(contentsOf: startURL)
        player?.prepareToPlay()
        player?.play()
    }
}
