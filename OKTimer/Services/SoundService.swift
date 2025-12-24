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
    
    // System sound IDs for iOS
    private static let completionSoundID: UInt32 = 1057  // Pleasant chime
    private static let tickSoundID: UInt32 = 1104        // Subtle tick
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        configureAudioSession()
    }
    
    deinit {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    // MARK: - Public Methods
    
    func playCompletionSound() {
        playSystemSound(soundID: Self.completionSoundID)
    }
    
    func playTickSound() {
        playSystemSound(soundID: Self.tickSoundID)
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
        DispatchQueue.main.async {
            if let sound = NSSound(named: NSSound.Name("Hero")) {
                sound.play()
            }
        }
        #endif
    }
    
    // Play custom sound files from bundle
    func playCustomSound(named soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("Sound file not found: \(soundName)")
            return
        }
        
        do {
            // Stop any existing player
            audioPlayer?.stop()
            
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error)")
            audioPlayer = nil
        }
    }
}
