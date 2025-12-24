//
//  TimerControlsView.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI

struct TimerControlsView: View {
    @ObservedObject var viewModel: TimerViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            // Primary action button (Start/Pause/Resume)
            Button(action: primaryAction) {
                Text(primaryButtonLabel)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .frame(minWidth: 120)
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(viewModel.timerState == .completed)
            .accessibilityLabel(primaryButtonLabel)
            .accessibilityHint(accessibilityHint)
            
            // Secondary action button (Reset/Stop)
            if viewModel.timerState != .idle {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.resetTimer()
                    }
                }) {
                    Text("Reset")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .frame(minWidth: 100)
                }
                .buttonStyle(SecondaryButtonStyle())
                .transition(.scale.combined(with: .opacity))
                .accessibilityLabel("Reset timer")
                .accessibilityHint("Reset the timer to its original time")
            }
        }
    }
    
    private var primaryButtonLabel: String {
        switch viewModel.timerState {
        case .idle:
            return "Start"
        case .running:
            return "Pause"
        case .paused:
            return "Resume"
        case .completed:
            return "Done!"
        }
    }
    
    private var accessibilityHint: String {
        switch viewModel.timerState {
        case .idle:
            return "Start the timer countdown"
        case .running:
            return "Pause the timer"
        case .paused:
            return "Resume the timer countdown"
        case .completed:
            return "Timer has completed"
        }
    }
    
    private func primaryAction() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch viewModel.timerState {
            case .idle, .paused:
                viewModel.startTimer()
            case .running:
                viewModel.pauseTimer()
            case .completed:
                break
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            }
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.primary.opacity(0.7))
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primary.opacity(0.08))
                    .opacity(configuration.isPressed ? 0.6 : 1.0)
            }
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 40) {
        TimerControlsView(viewModel: {
            let vm = TimerViewModel()
            return vm
        }())
        
        TimerControlsView(viewModel: {
            let vm = TimerViewModel()
            vm.startTimer()
            return vm
        }())
    }
    .padding()
}
