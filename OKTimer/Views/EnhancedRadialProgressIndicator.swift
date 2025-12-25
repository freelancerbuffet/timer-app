//
//  EnhancedRadialProgressIndicator.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import SwiftUI

struct EnhancedRadialProgressIndicator: View {
    let progress: Double // 0.0 to 1.0
    let timeRemaining: TimeInterval
    let totalTime: TimeInterval
    let lineWidth: CGFloat = 12
    let glowIntensity: CGFloat = 2.0
    
    @State private var animationProgress: Double = 0
    @State private var pulseScale: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Enhanced background with blur and darker overlay
                Color.black.opacity(0.92)
                    .ignoresSafeArea()
                    .overlay {
                        // Subtle gradient overlay
                        RadialGradient(
                            colors: [
                                Color.clear,
                                progressGlowColor.opacity(0.1),
                                Color.black.opacity(0.3)
                            ],
                            center: .center,
                            startRadius: 100,
                            endRadius: 400
                        )
                        .ignoresSafeArea()
                    }
                
                VStack(spacing: 40) {
                    // Main progress ring
                    ZStack {
                        // Background ring
                        Circle()
                            .stroke(
                                Color.white.opacity(0.15),
                                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                            )
                            .scaleEffect(0.85)
                        
                        // Progress ring with enhanced glow
                        Circle()
                            .trim(from: 0, to: animationProgress)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: enhancedProgressColors),
                                    center: .center,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360 * animationProgress)
                                ),
                                style: StrokeStyle(
                                    lineWidth: lineWidth,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(-90))
                            .scaleEffect(0.85)
                            .scaleEffect(pulseScale)
                            .shadow(color: progressGlowColor, radius: glowIntensity * 8)
                            .shadow(color: progressGlowColor, radius: glowIntensity * 16)
                            .shadow(color: progressGlowColor, radius: glowIntensity * 24)
                        
                        // Center time display
                        VStack(spacing: 12) {
                            Text(timeText)
                                .font(.system(size: 64, weight: .ultraLight, design: .rounded))
                                .foregroundColor(.white)
                                .monospacedDigit()
                                .shadow(color: .white.opacity(0.3), radius: 8)
                            
                            Text("\(Int(animationProgress * 100))%")
                                .font(.system(size: 20, weight: .light, design: .rounded))
                                .foregroundColor(progressGlowColor)
                                .opacity(0.8)
                        }
                    }
                    .frame(width: min(geometry.size.width * 0.7, 300))
                    
                    // Status indicator
                    VStack(spacing: 12) {
                        HStack {
                            Circle()
                                .fill(progressGlowColor)
                                .frame(width: 8, height: 8)
                                .scaleEffect(pulseScale)
                            
                            Text("TIMER RUNNING")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                                .tracking(2)
                        }
                        
                        Text("Switch back to see full interface")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
        }
        .onAppear {
            // Animate progress from 0 to current value
            withAnimation(.easeOut(duration: 0.8)) {
                animationProgress = progress
            }
            
            // Start pulsing animation
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.05
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(.easeInOut(duration: 0.5)) {
                animationProgress = newProgress
            }
        }
    }
    
    private var enhancedProgressColors: [Color] {
        if progress < 0.33 {
            return [.cyan, .blue, .cyan, .blue]
        } else if progress < 0.66 {
            return [.orange, .yellow, .orange, .red]
        } else {
            return [.red, .pink, .red, .orange]
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
}

#Preview {
    ZStack {
        EnhancedRadialProgressIndicator(progress: 0.65, timeRemaining: 125, totalTime: 500)
    }
}
