//
//  HapticService.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import Foundation
#if os(iOS)
import UIKit
import AVFoundation
#endif

class HapticService {
    static let shared = HapticService()
    
    #if os(iOS)
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    #endif
    
    private init() {
        #if os(iOS)
        impactGenerator.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
        #endif
    }
    
    // MARK: - Private Methods
    
    #if os(iOS)
    private func isDeviceInSilentMode() -> Bool {
        // Check if the device is in silent mode
        return AVAudioSession.sharedInstance().outputVolume == 0 || 
               AVAudioSession.sharedInstance().category == .ambient
    }
    #endif
    
    // MARK: - Public Methods
    
    func timerCompleted() {
        #if os(iOS)
        // Provide a strong, noticeable haptic feedback for timer completion
        // This is especially important when the phone is muted
        notificationGenerator.notificationOccurred(.success)
        
        // Check if device might be in silent mode for enhanced feedback
        let enhancedFeedback = isDeviceInSilentMode()
        
        // Add additional strong impact feedback to make it more noticeable
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1.0)
        }
        
        // Add a second pulse for extra emphasis
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1.0)
        }
        
        // Add a final pulse to create a distinctive pattern
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let intensity: CGFloat = enhancedFeedback ? 1.0 : 0.8
            let style: UIImpactFeedbackGenerator.FeedbackStyle = enhancedFeedback ? .heavy : .medium
            UIImpactFeedbackGenerator(style: style).impactOccurred(intensity: intensity)
        }
        
        // If device seems to be in silent mode, add even more pulses
        if enhancedFeedback {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1.0)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred(intensity: 0.9)
            }
        }
        #endif
    }
    
    func timerStarted() {
        #if os(iOS)
        impactGenerator.impactOccurred()
        #endif
    }
    
    func timerPaused() {
        #if os(iOS)
        impactGenerator.impactOccurred(intensity: 0.7)
        #endif
    }
    
    func timerReset() {
        #if os(iOS)
        selectionGenerator.selectionChanged()
        #endif
    }
    
    func timerCompletedIntense() {
        #if os(iOS)
        // Provide the most intense haptic feedback possible
        // For when the user absolutely needs to notice the timer completion
        
        // Initial success notification
        notificationGenerator.notificationOccurred(.success)
        
        // Create a distinctive long pattern of heavy impacts
        let delays: [Double] = [0.1, 0.25, 0.4, 0.6, 0.8, 1.0, 1.2]
        let intensities: [CGFloat] = [1.0, 1.0, 0.9, 1.0, 0.8, 1.0, 0.7]
        
        for (index, delay) in delays.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let intensity = intensities[index]
                let style: UIImpactFeedbackGenerator.FeedbackStyle = intensity > 0.8 ? .heavy : .medium
                UIImpactFeedbackGenerator(style: style).impactOccurred(intensity: intensity)
            }
        }
        #endif
    }

    func buttonTapped() {
        #if os(iOS)
        selectionGenerator.selectionChanged()
        #endif
    }
}
