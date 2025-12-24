//
//  TimerViewModel.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var timeRemaining: TimeInterval = 300 // 5 minutes default
    @Published var totalTime: TimeInterval = 300
    @Published var timerState: TimerState = .idle
    
    private var timer: AnyCancellable?
    private var endDate: Date?
    
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
    }
    
    func resetTimer() {
        timer?.cancel()
        timer = nil
        timeRemaining = totalTime
        timerState = .idle
        endDate = nil
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
        } else {
            timeRemaining = remaining
        }
    }
}
