//
//  AudioPlayer.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 15.08.2024.
//

import Foundation
import AVFoundation

enum Sound: String {
    case what
}

final class AudioPlayer {
    static let shared = AudioPlayer()
    
    private var player: AVAudioPlayer?
    
    func playSound(sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
