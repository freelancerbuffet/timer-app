//
//  SoundService.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import Foundation
import AVFoundation

#if os(iOS)
import AudioToolbox
#else
import AppKit
#endif

class SoundService: ObservableObject {
    static let shared = SoundService()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        configureAudioSession()
    }
    
    // MARK: - Public Methods
    
    func playCompletionSound() {
        // Use system sound for now - a pleasant completion sound
        // System Sound ID 1057 is a nice chime sound
        playSystemSound(soundID: 1057)
    }
    
    func playTickSound() {
        // Light tick sound for UI interactions
        // System Sound ID 1104 is a subtle tick
        playSystemSound(soundID: 1104)
    }
    
    // MARK: - Private Methods
    
    private func configureAudioSession() {
        #if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
        #endif
    }
    
    private func playSystemSound(soundID: UInt32) {
        #if os(iOS)
        AudioServicesPlaySystemSound(soundID)
        #else
        // On macOS, use NSSound for system sounds
        if let sound = NSSound(named: NSSound.Name("Hero")) {
            sound.play()
        }
        #endif
    }
    
    // Future method for custom sound files
    func playCustomSound(named soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("Sound file not found: \(soundName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
    }
}
