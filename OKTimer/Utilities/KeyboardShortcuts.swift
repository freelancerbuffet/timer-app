//
//  KeyboardShortcuts.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import SwiftUI

extension View {
    func timerKeyboardShortcuts(viewModel: TimerViewModel) -> some View {
        self
            .keyboardShortcut("s", modifiers: [.command], action: {
                // Start/Pause timer
                if viewModel.timerState == .idle || viewModel.timerState == .paused {
                    viewModel.startTimer()
                } else if viewModel.timerState == .running {
                    viewModel.pauseTimer()
                }
            })
            .keyboardShortcut("r", modifiers: [.command], action: {
                // Reset timer
                viewModel.resetTimer()
            })
            .keyboardShortcut("1", modifiers: [.command], action: {
                // 1 minute preset
                if viewModel.timerState == .idle {
                    viewModel.setPresetTime(seconds: 60)
                }
            })
            .keyboardShortcut("5", modifiers: [.command], action: {
                // 5 minutes preset
                if viewModel.timerState == .idle {
                    viewModel.setPresetTime(seconds: 300)
                }
            })
    }
}
