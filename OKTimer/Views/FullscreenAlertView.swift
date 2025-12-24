//
//  FullscreenAlertView.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import SwiftUI

struct FullscreenAlertView: View {
    let onDismiss: () -> Void
    let onSnooze: () -> Void
    
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Full screen dark background
            Color.black.opacity(0.95)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Pulsing alert icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.red, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Image(systemName: "bell.fill")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(scale)
                
                // Alert message
                VStack(spacing: 16) {
                    Text("⏰ TIME'S UP!")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Your timer has completed")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                .opacity(opacity)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 16) {
                    Button(action: onDismiss) {
                        Text("Dismiss")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: 300)
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .cyan],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: onSnooze) {
                        Text("Snooze 5 min")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .frame(maxWidth: 300)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .opacity(opacity)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                opacity = 1.0
            }
            
            pulseScale = 1.15
        }
    }
}

#Preview {
    FullscreenAlertView(onDismiss: {}, onSnooze: {})
}
