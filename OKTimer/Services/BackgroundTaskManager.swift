//
//  BackgroundTaskManager.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import Foundation
import UIKit
import UserNotifications

class BackgroundTaskManager: ObservableObject {
    static let shared = BackgroundTaskManager()
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    private var timerEndDate: Date?
    
    private init() {
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    func startBackgroundTask(endDate: Date) {
        self.timerEndDate = endDate
        
        // Schedule local notification
        scheduleTimerCompletionNotification(endDate: endDate)
    }
    
    @objc private func appWillEnterBackground() {
        guard let endDate = timerEndDate else { return }
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
        // Start a background timer to handle completion
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.monitorTimerInBackground(endDate: endDate)
        }
    }
    
    @objc private func appDidBecomeActive() {
        // Cancel scheduled notifications since app is active
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Check if timer should have completed while in background
        if let endDate = timerEndDate, Date() >= endDate {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .timerCompletedInBackground, object: nil)
            }
        }
        
        endBackgroundTask()
    }
    
    private func monitorTimerInBackground(endDate: Date) {
        while Date() < endDate && backgroundTaskIdentifier != .invalid {
            Thread.sleep(forTimeInterval: 0.1)
        }
        
        if Date() >= endDate {
            // Timer completed in background
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .timerCompletedInBackground, object: nil)
            }
        }
        
        endBackgroundTask()
    }
    
    private func endBackgroundTask() {
        if backgroundTaskIdentifier != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            backgroundTaskIdentifier = .invalid
        }
    }
    
    private func scheduleTimerCompletionNotification(endDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Timer Completed!"
        content.body = "Your OKTimer has finished."
        content.sound = .default
        
        let timeInterval = endDate.timeIntervalSinceNow
        if timeInterval > 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: "timerCompletion", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to schedule notification: \(error)")
                } else {
                    print("Timer completion notification scheduled for: \(endDate)")
                }
            }
        }
    }
    
    func cancelBackgroundTask() {
        timerEndDate = nil
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        endBackgroundTask()
    }
}

extension Notification.Name {
    static let timerCompletedInBackground = Notification.Name("timerCompletedInBackground")
}
