//
//  ProgressRingView.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI

struct ProgressRingView: View {
    let progress: Double
    let theme: TimerSettings.ColorTheme
    let lineWidth: CGFloat = 12
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(
                    Color.primary.opacity(0.08),
                    lineWidth: lineWidth
                )
            
            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    gradientForProgress,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
    
    private var gradientForProgress: LinearGradient {
        let colors = theme.progressGradientColors
        let colorCount = colors.count
        
        // Determine which colors to use based on progress
        let index = Int(progress * Double(colorCount - 1))
        let startIndex = min(index, colorCount - 2)
        let endIndex = startIndex + 1
        
        return LinearGradient(
            colors: [colors[startIndex], colors[endIndex]],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    VStack(spacing: 40) {
        ProgressRingView(progress: 0.25, theme: .blue)
            .frame(width: 250, height: 250)
        
        ProgressRingView(progress: 0.5, theme: .green)
            .frame(width: 250, height: 250)
        
        ProgressRingView(progress: 0.75, theme: .orange)
            .frame(width: 250, height: 250)
    }
    .padding()
}
