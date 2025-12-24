//
//  SettingsViewModel.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var settings: TimerSettings {
        didSet {
            saveSettings()
        }
    }
    
    private let settingsKey = "OKTimerSettings"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(TimerSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = TimerSettings()
        }
    }
    
    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    func resetToDefaults() {
        settings = TimerSettings()
    }
}
