//
//  RadialProgressIndicator.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import SwiftUI

struct RadialProgressIndicator: View {
    let progress: Double // 0.0 to 1.0
    let lineWidth: CGFloat = 8
    let glowIntensity: CGFloat = 1.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background dim
                Color.black.opacity(0.85)
                    .ignoresSafeArea()
                
                // Radial progress ring around the edge of the screen
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
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90)) // Start at 12 o'clock
                    .padding(lineWidth / 2)
                    .shadow(color: progressGlowColor, radius: glowIntensity * 10)
                    .shadow(color: progressGlowColor, radius: glowIntensity * 20)
                    .shadow(color: progressGlowColor, radius: glowIntensity * 30)
                
                // Center time display
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
        // This is a placeholder - will be replaced with actual timer time
        let remainingProgress = 1.0 - progress
        let totalSeconds = 300 // 5 minutes as example
        let remaining = Int(Double(totalSeconds) * remainingProgress)
        let minutes = remaining / 60
        let seconds = remaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ZStack {
        RadialProgressIndicator(progress: 0.75)
    }
}
