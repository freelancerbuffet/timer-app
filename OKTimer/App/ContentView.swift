//
//  ContentView.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("OK TIMER")
                .font(.system(size: 28, weight: .light, design: .rounded))
                .foregroundColor(.primary.opacity(0.6))
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            Spacer()
            
            // Main timer display with progress ring
            TimerDisplayView(viewModel: viewModel)
                .padding(.vertical, 30)
            
            Spacer()
            
            // Preset buttons
            PresetButtonsView(
                onPresetSelected: { seconds in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.setPresetTime(seconds: seconds)
                    }
                },
                isDisabled: viewModel.timerState != .idle
            )
            .padding(.bottom, 24)
            
            // Timer controls
            TimerControlsView(viewModel: viewModel)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            #if os(iOS)
            Color.clear
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 0))
            #else
            Color.clear
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            #endif
        }
        .preferredColorScheme(.none)
    }
}

#Preview {
    ContentView()
}
