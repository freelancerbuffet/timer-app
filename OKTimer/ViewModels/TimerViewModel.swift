//
//  TimerViewModel.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import Foundation
import Combine
#if os(iOS)
import UIKit
import UserNotifications
#endif

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
    private let alertWindowManager = AlertWindowManager.shared
    
    #if os(iOS)
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    #endif
    
    // Settings
    var settingsViewModel: SettingsViewModel?
    
    init() {
        #if os(iOS)
        setupNotificationHandling()
        #endif
    }
    
    #if os(iOS)
    private func setupNotificationHandling() {
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Notification permission granted: \(granted)")
        }
        
        // Listen for app becoming active to check timer completion
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        // Listen for app going to background
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc private func appDidBecomeActive() {
        Task { @MainActor in
            // Check if timer should have completed while in background
            if let endDate = endDate, timerState == .running, Date() >= endDate {
                print("🔥 iOS: Timer completed in background, showing completion now!")
                handleTimerCompletion()
            }
        }
    }
    
    @objc private func appDidEnterBackground() {
        print("📱 iOS: App entered background with timer state: \(timerState)")
        if timerState == .running {
            print("📱 iOS: Timer is running, will continue in background")
        }
    }
    #endif
    
    deinit {
        // Ensure proper cleanup
        timer?.cancel()
        timer = nil
        #if os(iOS)
        if backgroundTaskID != .invalid {
            Task { @MainActor in
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
            }
            backgroundTaskID = .invalid
        }
        NotificationCenter.default.removeObserver(self)
        #endif
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
        
        #if os(iOS)
        // Schedule local notification for when timer completes
        scheduleTimerCompletionNotification()
        
        // Start background task to allow timer to complete in background
        backgroundTaskID = UIApplication.shared.beginBackgroundTask { [weak self] in
            print("📱 iOS: Background task is about to expire, cleaning up")
            self?.endBackgroundTask()
        }
        print("📱 iOS: Started background task ID: \(backgroundTaskID.rawValue)")
        #endif
        
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
        
        #if os(iOS)
        // Cancel background task and notifications
        endBackgroundTask()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        #endif
        
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
        
        #if os(iOS)
        // Cancel background task and notifications
        endBackgroundTask()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        #endif
        
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
            timer?.cancel()
            timer = nil
            
            handleTimerCompletion()
        } else {
            timeRemaining = remaining
        }
    }
    
    private func handleTimerCompletion() {
        // Prevent duplicate completion handling if already completed
        guard timerState == .running else {
            print("⚠️ Timer completion already handled or timer not running, skipping duplicate call")
            return
        }
        
        print("🔥 TIMER COMPLETED - Starting completion flow")
        
        // Set timer state to completed first
        timerState = .completed
        timeRemaining = 0
        
        #if os(iOS)
        // End background task and cancel notifications since timer completed
        endBackgroundTask()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        #endif
        
        // Play completion sound and haptic if enabled
        if settingsViewModel?.settings.soundEnabled ?? true {
            soundService.playCompletionSound()
        }
        if settingsViewModel?.settings.hapticsEnabled ?? true {
            hapticService.timerCompleted()
        }
        
        // Show completion animation and fullscreen alert
        #if os(macOS)
        print("🔥 macOS: Setting showCompletionAnimation = true AND showFullscreenAlert = true")
        showCompletionAnimation = true
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
        print("🔥 iOS: Setting showCompletionAnimation = true for confetti!")
        // Show in-app completion animation with confetti on iOS
        showCompletionAnimation = true
        
        // Also send a local notification as backup
        let content = UNMutableNotificationContent()
        content.title = "🎉 Timer Completed!"
        content.body = "Your OKTimer has finished!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "immediateCompletion", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to show immediate notification: \(error)")
            }
        }
        #endif
    }
    
    #if os(iOS)
    private func scheduleTimerCompletionNotification() {
        guard let endDate = endDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🎉 Timer Completed!"
        content.body = "Your OKTimer has finished!"
        content.sound = .default
        content.badge = 1
        
        let timeInterval = endDate.timeIntervalSinceNow
        if timeInterval > 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: "timerCompletion", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("📱 Failed to schedule notification: \(error)")
                } else {
                    print("📱 Timer completion notification scheduled for: \(endDate)")
                }
            }
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTaskID != .invalid {
            print("📱 iOS: Ending background task ID: \(backgroundTaskID.rawValue)")
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }
    #endif
    
    func dismissCompletionAnimation() {
        showCompletionAnimation = false
        showFullscreenAlert = false
        alertWindowManager.dismissAlert()
        // Reset timer state to idle when dismissed
        timerState = .idle
    }
    
    func completeTimer() {
        print("⏰ DEBUG: Timer completion started")
        pauseTimer()
        
        // Show completion animation for macOS
        #if os(macOS)
        print("🖥️ DEBUG: Setting showCompletionAnimation = true for macOS")
        showCompletionAnimation = true
        showFullscreenAlert = true
        #endif
        
        // Play completion sound only (haptic feedback handled by handleTimerCompletion)
        soundService.playCompletionSound()
        
        // Statistics would be updated here if we had access to session/settings objects
        
        // Schedule notification to hide after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("🔄 DEBUG: Hiding completion animation after 3 second delay")
            self.hideCompletionAnimation()
        }
        
        print("✅ DEBUG: Timer completion finished - showCompletionAnimation: \(showCompletionAnimation)")
    }
    
    func hideCompletionAnimation() {
        print("❌ DEBUG: hideCompletionAnimation called - setting showCompletionAnimation = false")
        showCompletionAnimation = false
        showFullscreenAlert = false
    }
}
