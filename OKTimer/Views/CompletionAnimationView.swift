//
//  CompletionAnimationView.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import SwiftUI

struct CompletionAnimationView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0
    @State private var showConfetti = false
    @State private var starScale: CGFloat = 0.5
    
    let onDismiss: () -> Void
    let onSnooze: (() -> Void)?
    
    init(onDismiss: @escaping () -> Void, onSnooze: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
        self.onSnooze = onSnooze
        print("🎉 CompletionAnimationView: INITIALIZED")
    }
    
    var body: some View {
        print("🎊 DEBUG: CompletionAnimationView body is being rendered")
        return ZStack {
            // Semi-transparent background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Confetti layer
            if showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 32) {
                // Checkmark icon with enhanced glow
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.green.opacity(0.6), Color.mint.opacity(0.3), Color.clear],
                                center: .center,
                                startRadius: 40,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .scaleEffect(starScale)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.green, .mint, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: .green.opacity(0.5), radius: 20)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.5), radius: 10)
                }
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                
                // Completion message with enhanced styling
                VStack(spacing: 12) {
                    Text("🎉 Time's Up!")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .green.opacity(0.5), radius: 10)
                        .shadow(color: .mint.opacity(0.3), radius: 20)
                    
                    Text("Well done!")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                }
                .opacity(opacity)
                
                // Enhanced action buttons
                VStack(spacing: 14) {
                    Button(action: onDismiss) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))
                            Text("OK")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(width: 220, height: 52)
                        .background {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .cyan],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .cyan.opacity(0.4), radius: 12)
                        }
                    }
                    
                    if let onSnooze = onSnooze {
                        Button(action: onSnooze) {
                            HStack {
                                Image(systemName: "moon.zzz.fill")
                                    .font(.system(size: 16))
                                Text("Snooze 5 min")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            }
                            .foregroundColor(.white.opacity(0.95))
                            .frame(width: 220, height: 46)
                            .background {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                .opacity(opacity)
            }
        }
        .onAppear {
            print("🎉 CompletionAnimationView: APPEARED - Starting animations")
            // Enhanced entrance animations
            withAnimation(.spring(response: 0.7, dampingFraction: 0.65)) {
                scale = 1.0
                rotation = 360
            }
            
            withAnimation(.easeOut(duration: 0.5).delay(0.25)) {
                opacity = 1.0
            }
            
            // Start confetti
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showConfetti = true
            }
            
            // Pulsing glow animation
            withAnimation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                starScale = 1.0
            }
        }
    }
}

#Preview {
    CompletionAnimationView(onDismiss: {})
}
