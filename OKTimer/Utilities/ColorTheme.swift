//
//  ColorTheme.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import SwiftUI

extension TimerSettings.ColorTheme {
    var progressGradientColors: [Color] {
        switch self {
        case .blue:
            return [.blue, .cyan, .orange, .red]
        case .green:
            return [.green, .mint, .yellow, .orange]
        case .orange:
            return [.orange, .yellow, .pink, .red]
        case .purple:
            return [.purple, .pink, .orange, .red]
        case .monochrome:
            return [.gray, .primary.opacity(0.7), .primary.opacity(0.5), .primary.opacity(0.3)]
        }
    }
    
    var accentColor: Color {
        switch self {
        case .blue:
            return .blue
        case .green:
            return .green
        case .orange:
            return .orange
        case .purple:
            return .purple
        case .monochrome:
            return .gray
        }
    }
}
