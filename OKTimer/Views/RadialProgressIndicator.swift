//
//  RadialProgressIndicator.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import SwiftUI

struct RadialProgressIndicator: View {
    let progress: Double // 0.0 to 1.0
    let timeRemaining: TimeInterval
    let totalTime: TimeInterval
    let lineWidth: CGFloat = 12
    let glowIntensity: CGFloat = 2.0
    let isSystemOverlay: Bool
    
    init(progress: Double, timeRemaining: TimeInterval, totalTime: TimeInterval, isSystemOverlay: Bool = false) {
        self.progress = progress
        self.timeRemaining = timeRemaining
        self.totalTime = totalTime
        self.isSystemOverlay = isSystemOverlay
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background dim (only for full overlays, not system overlay)
                if !isSystemOverlay {
                    Color.black.opacity(0.85)
                        .ignoresSafeArea()
                }
                
                // Radial progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: progressColors),
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360 * progress)
                        ),
                        style: StrokeStyle(
                            lineWidth: isSystemOverlay ? lineWidth * 0.6 : lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90)) // Start at 12 o'clock
                    .padding((isSystemOverlay ? lineWidth * 0.6 : lineWidth) / 2)
                    .shadow(color: progressGlowColor, radius: glowIntensity * 8)
                    .shadow(color: progressGlowColor, radius: glowIntensity * 16)
                    .shadow(color: progressGlowColor, radius: glowIntensity * 24)
                    .scaleEffect(isSystemOverlay ? 1.0 : 0.9)
                    .animation(.easeInOut(duration: 0.3), value: progress)
                
                // Center content (only for full overlay)
                if !isSystemOverlay {
                    VStack(spacing: 12) {
                        Text(timeText)
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .monospacedDigit()
                            .shadow(color: .white.opacity(0.5), radius: 10)
                        
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                    }
                } else {
                    // Minimal display for system overlay
                    Text(timeTextShort)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .monospacedDigit()
                        .shadow(color: progressGlowColor, radius: 4)
                }
            }
        }
    }
    
    private var progressColors: [Color] {
        if progress < 0.33 {
            return [.blue, .cyan]
        } else if progress < 0.66 {
            return [.cyan, .orange]
        } else {
            return [.orange, .red]
        }
    }
    
    private var progressGlowColor: Color {
        if progress < 0.33 {
            return .cyan
        } else if progress < 0.66 {
            return .orange
        } else {
            return .red
        }
    }
    
    private var timeText: String {
        let remaining = Int(timeRemaining)
        let minutes = remaining / 60
        let seconds = remaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var timeTextShort: String {
        let remaining = Int(timeRemaining)
        let minutes = remaining / 60
        let seconds = remaining % 60
        if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(seconds)s"
        }
    }
}

#Preview {
    ZStack {
        RadialProgressIndicator(progress: 0.75, timeRemaining: 125, totalTime: 500)
    }
}
