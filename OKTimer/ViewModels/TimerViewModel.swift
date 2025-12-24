//
//  TimerViewModel.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import Foundation
import Combine

@MainActor
class TimerViewModel: ObservableObject {
    @Published var timeRemaining: TimeInterval = 300 // 5 minutes default
    @Published var totalTime: TimeInterval = 300
    @Published var timerState: TimerState = .idle
    @Published var showCompletionAnimation = false
    @Published var showFullscreenAlert = false
    
    private var timer: AnyCancellable?
    private var endDate: Date?
    private let soundService = SoundService.shared
    private let hapticService = HapticService.shared
    private let alertWindowManager = AlertWindowManager()
    
    // Settings
    var settingsViewModel: SettingsViewModel?
    
    deinit {
        // Ensure proper cleanup
        timer?.cancel()
        timer = nil
        Task { @MainActor in
            alertWindowManager.dismissAlert()
        }
    }
    
    // MARK: - Computed Properties
    
    var minutes: Int {
        Int(timeRemaining) / 60
    }
    
    var seconds: Int {
        Int(timeRemaining) % 60
    }
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return (totalTime - timeRemaining) / totalTime
    }
    
    var formattedTime: String {
        let mins = minutes
        let secs = seconds
        return String(format: "%02d:%02d", mins, secs)
    }
    
    // MARK: - Timer Control Methods
    
    func startTimer() {
        guard timerState != .running else { return }
        
        if timerState == .idle {
            totalTime = timeRemaining
        }
        
        timerState = .running
        endDate = Date().addingTimeInterval(timeRemaining)
        
        // Play haptic feedback if enabled
        if settingsViewModel?.settings.hapticsEnabled ?? true {
            hapticService.timerStarted()
        }
        
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimer()
            }
    }
    
    func pauseTimer() {
        guard timerState == .running else { return }
        timerState = .paused
        timer?.cancel()
        timer = nil
        
        // Play haptic feedback if enabled
        if settingsViewModel?.settings.hapticsEnabled ?? true {
            hapticService.timerPaused()
        }
    }
    
    func resetTimer() {
        timer?.cancel()
        timer = nil
        timeRemaining = totalTime
        timerState = .idle
        endDate = nil
        showCompletionAnimation = false
        showFullscreenAlert = false
        
        // Dismiss any alert window
        alertWindowManager.dismissAlert()
        
        // Play haptic feedback if enabled
        if settingsViewModel?.settings.hapticsEnabled ?? true {
            hapticService.timerReset()
        }
    }
    
    func snoozeTimer() {
        // Dismiss alert first
        showCompletionAnimation = false
        showFullscreenAlert = false
        alertWindowManager.dismissAlert()
        
        // Snooze for 5 minutes
        timeRemaining = 300 // 5 minutes
        totalTime = 300
        timerState = .idle
        
        // Auto-start after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.startTimer()
        }
    }
    
    func setTime(minutes: Int, seconds: Int) {
        guard timerState == .idle else { return }
        let newTime = TimeInterval(minutes * 60 + seconds)
        timeRemaining = newTime
        totalTime = newTime
    }
    
    func setPresetTime(seconds: TimeInterval) {
        guard timerState == .idle else { return }
        timeRemaining = seconds
        totalTime = seconds
        
        // Play haptic feedback for preset selection if enabled
        if settingsViewModel?.settings.hapticsEnabled ?? true {
            hapticService.buttonTapped()
        }
    }
    
    // MARK: - Private Methods
    
    private func updateTimer() {
        guard let endDate = endDate else { return }
        
        let remaining = endDate.timeIntervalSinceNow
        
        if remaining <= 0 {
            timeRemaining = 0
            timerState = .completed
            timer?.cancel()
            timer = nil
            
            // Play completion sound and haptic if enabled
            if settingsViewModel?.settings.soundEnabled ?? true {
                soundService.playCompletionSound()
            }
            if settingsViewModel?.settings.hapticsEnabled ?? true {
                hapticService.timerCompleted()
            }
            
            // Show fullscreen alert on macOS
            #if os(macOS)
            showFullscreenAlert = true
            alertWindowManager.showFullscreenAlert(
                onDismiss: { [weak self] in
                    self?.dismissCompletionAnimation()
                },
                onSnooze: { [weak self] in
                    self?.snoozeTimer()
                }
            )
            #else
            // Show in-app completion animation on iOS
            showCompletionAnimation = true
            #endif
        } else {
            timeRemaining = remaining
        }
    }
    
    func dismissCompletionAnimation() {
        showCompletionAnimation = false
        showFullscreenAlert = false
        alertWindowManager.dismissAlert()
        // Reset timer state to idle when dismissed
        timerState = .idle
    }
}
