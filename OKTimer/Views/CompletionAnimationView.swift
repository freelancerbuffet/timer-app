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
    
    let onDismiss: () -> Void
    let onSnooze: (() -> Void)?
    
    init(onDismiss: @escaping () -> Void, onSnooze: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
        self.onSnooze = onSnooze
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 24) {
                // Checkmark icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                
                // Completion message
                VStack(spacing: 8) {
                    Text("Time's Up!")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Well done!")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                .opacity(opacity)
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: onDismiss) {
                        Text("OK")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 44)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .cyan],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            }
                    }
                    
                    if let onSnooze = onSnooze {
                        Button(action: onSnooze) {
                            Text("Snooze 5 min")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .frame(width: 200, height: 38)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.15))
                                }
                        }
                    }
                }
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                rotation = 360
            }
            
            withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                opacity = 1.0
            }
        }
    }
}

#Preview {
    CompletionAnimationView(onDismiss: {})
}
