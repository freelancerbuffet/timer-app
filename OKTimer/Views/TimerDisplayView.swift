//
//  TimerDisplayView.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI

struct TimerDisplayView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var isShowingPicker = false
    @State private var pickerMinutes = 5
    @State private var pickerSeconds = 0
    
    #if os(iOS)
    let timerFontSize: CGFloat = 72
    let ringSize: CGFloat = 280
    #else
    let timerFontSize: CGFloat = 96
    let ringSize: CGFloat = 340
    #endif
    
    var body: some View {
        ZStack {
            // Progress ring
            ProgressRingView(progress: viewModel.progress)
                .frame(width: ringSize, height: ringSize)
                .opacity(viewModel.timerState == .idle ? 0.3 : 1.0)
            
            // Timer display or picker
            VStack(spacing: 16) {
                if isShowingPicker && viewModel.timerState == .idle {
                    VStack(spacing: 16) {
                        TimePickerView(
                            minutes: $pickerMinutes,
                            seconds: $pickerSeconds,
                            isDisabled: false
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        
                        // Done button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isShowingPicker = false
                                viewModel.setTime(minutes: pickerMinutes, seconds: pickerSeconds)
                            }
                        }) {
                            Text("Done")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.accentColor)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.accentColor.opacity(0.15))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } else {
                    timerText
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        .onTapGesture {
                            if viewModel.timerState == .idle {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isShowingPicker = true
                                }
                            }
                        }
                }
            }
        }
        .onChange(of: viewModel.timerState) { newState in
            if newState == .idle {
                pickerMinutes = viewModel.minutes
                pickerSeconds = viewModel.seconds
            }
            if newState != .idle && isShowingPicker {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isShowingPicker = false
                }
            }
        }
        .onAppear {
            pickerMinutes = viewModel.minutes
            pickerSeconds = viewModel.seconds
        }
    }
    
    private var timerText: some View {
        VStack(spacing: 8) {
            Text(viewModel.formattedTime)
                .font(.system(size: timerFontSize, weight: .semibold, design: .rounded))
                .foregroundColor(textColor)
                .monospacedDigit()
                .animation(.easeInOut(duration: 0.2), value: viewModel.formattedTime)
            
            if viewModel.timerState == .idle {
                HStack(spacing: 4) {
                    Image(systemName: "pencil")
                        .font(.system(size: 12, weight: .medium))
                    Text("Tap to set time")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                }
                .foregroundColor(.primary.opacity(0.35))
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: viewModel.timerState)
            }
        }
        .padding(.vertical, 8)
        .background(
            Group {
                if viewModel.timerState == .idle {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.primary.opacity(0.03))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                        )
                } else {
                    Rectangle().fill(Color.clear)
                }
            }
        )
        .scaleEffect(viewModel.timerState == .idle ? 1.0 : 1.05)
        .animation(.easeInOut(duration: 0.3), value: viewModel.timerState)
    }
    
    private var textColor: Color {
        switch viewModel.timerState {
        case .idle:
            return .primary.opacity(0.6)
        case .running:
            return .primary
        case .paused:
            return .orange
        case .completed:
            return .green
        }
    }
}

#Preview {
    TimerDisplayView(viewModel: TimerViewModel())
        .padding()
}
