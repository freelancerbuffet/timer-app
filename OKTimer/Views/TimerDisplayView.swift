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
                    TimePickerView(
                        minutes: $pickerMinutes,
                        seconds: $pickerSeconds,
                        isDisabled: false
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                } else {
                    timerText
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
        }
        .onTapGesture {
            if viewModel.timerState == .idle {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isShowingPicker.toggle()
                    if !isShowingPicker {
                        // Apply picker values
                        viewModel.setTime(minutes: pickerMinutes, seconds: pickerSeconds)
                    }
                }
            }
        }
        .onChange(of: viewModel.timerState) { oldValue, newState in
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
        VStack(spacing: 4) {
            Text(viewModel.formattedTime)
                .font(.system(size: timerFontSize, weight: .semibold, design: .rounded))
                .foregroundColor(textColor)
                .monospacedDigit()
                .animation(.easeInOut(duration: 0.2), value: viewModel.formattedTime)
            
            if viewModel.timerState == .idle {
                Text("tap to edit")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.primary.opacity(0.4))
                    .transition(.opacity)
            }
        }
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
