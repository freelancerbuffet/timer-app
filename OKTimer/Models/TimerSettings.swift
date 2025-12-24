//
//  TimerSettings.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import Foundation

struct TimerSettings: Codable {
    var soundEnabled: Bool = true
    var hapticsEnabled: Bool = true
    var theme: ColorTheme = .blue
    
    enum ColorTheme: String, Codable, CaseIterable {
        case blue = "Blue"
        case green = "Green"
        case orange = "Orange"
        case purple = "Purple"
        case monochrome = "Monochrome"
        
        var id: String { rawValue }
    }
}
