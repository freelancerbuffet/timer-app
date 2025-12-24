//
//  ProgressRingView.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI

struct ProgressRingView: View {
    let progress: Double
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
        let colors: [Color]
        
        if progress < 0.33 {
            // Start phase: Blue to Cyan
            colors = [.blue, .cyan]
        } else if progress < 0.66 {
            // Middle phase: Cyan to Orange
            colors = [.cyan, .orange]
        } else {
            // Final phase: Orange to Red
            colors = [.orange, .red]
        }
        
        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    VStack(spacing: 40) {
        ProgressRingView(progress: 0.25)
            .frame(width: 250, height: 250)
        
        ProgressRingView(progress: 0.5)
            .frame(width: 250, height: 250)
        
        ProgressRingView(progress: 0.75)
            .frame(width: 250, height: 250)
    }
    .padding()
}
