//
//  AudioPlayer.swift
//  Blind Shooter Audio Controller
//
//  Created by Aleksandr on 19.08.2022.
//

import AVFoundation
import Foundation

class AudioPlayer {
    
    var player: AVAudioPlayer?
    
    private let engine = AVAudioEngine()
    private let speedControl = AVAudioUnitVarispeed()
    private var pitchControl = AVAudioUnitTimePitch()
    private var audioPlayer = AVAudioPlayerNode()
    private var defaultPitch: Float!
    private var currentSoundUrl: URL!

    func playAudio(gesture: GestureType) {
        guard let url = gesture.audioUrl else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSound(url: URL) {
        guard currentSoundUrl != url, let file = try? AVAudioFile(forReading: url) else { return }
        currentSoundUrl = url
        
        let audioFormat = file.processingFormat
        let audioFrameCount = UInt32(file.length)
        guard let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount) else { return }
        try? file.read(into: audioFileBuffer)
        
        // 2: create the audio player
        audioPlayer = AVAudioPlayerNode()
        pitchControl = AVAudioUnitTimePitch()
        
        defaultPitch = pitchControl.pitch

        // 3: connect the components to our playback engine
        engine.attach(audioPlayer)
        engine.attach(pitchControl)
        engine.attach(speedControl)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(audioPlayer, to: speedControl, format: nil)
        engine.connect(speedControl, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        audioPlayer.scheduleBuffer(audioFileBuffer, at: nil, options: .loops, completionHandler: nil)

        // 6: start the engine and player
        try? engine.start()
        audioPlayer.play()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) // Vibrate
    }
    
    func stopPlaySound() {
        engine.stop()
        audioPlayer.stop()
    }
    
    func setPitch(_ value: Float) {
        guard defaultPitch != nil else { return }
        pitchControl.pitch = defaultPitch + value
    }
    
    /// -1.0 -> Left headphone
    /// 1.0 ->  Right headphone
    ///
    func setPan(_ value: Float) {
        audioPlayer.pan = value
    }
}
