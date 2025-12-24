//
//  HapticService.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import Foundation
#if os(iOS)
import UIKit
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
    
    // MARK: - Public Methods
    
    func timerCompleted() {
        #if os(iOS)
        notificationGenerator.notificationOccurred(.success)
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
    
    func buttonTapped() {
        #if os(iOS)
        selectionGenerator.selectionChanged()
        #endif
    }
}
