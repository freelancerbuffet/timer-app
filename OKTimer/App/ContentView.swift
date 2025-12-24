//
//  ContentView.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var showSettings = false
    @State private var showStatistics = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with settings button
            HStack {
                Button(action: {
                    // Statistics feature coming soon
                }) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.primary.opacity(0.3))
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.primary.opacity(0.03))
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(true)
                .accessibilityLabel("Statistics (Coming Soon)")
                .accessibilityHint("Statistics feature is not yet available")
                
                Spacer()
                
                Text("OK TIMER")
                    .font(.system(size: 28, weight: .light, design: .rounded))
                    .foregroundColor(.primary.opacity(0.6))
                
                Spacer()
                
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.primary.opacity(0.5))
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.primary.opacity(0.06))
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Settings")
                .accessibilityHint("Open settings to customize sound, haptics, and theme")
            }
            .padding(.horizontal, 40)
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            Spacer()
            
            // Main timer display with progress ring
            TimerDisplayView(viewModel: viewModel, theme: settingsViewModel.settings.theme)
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
        .overlay {
            // Completion animation overlay (primarily for iOS)
            if viewModel.showCompletionAnimation {
                CompletionAnimationView(
                    onDismiss: {
                        withAnimation {
                            viewModel.dismissCompletionAnimation()
                        }
                    },
                    onSnooze: {
                        withAnimation {
                            viewModel.snoozeTimer()
                        }
                    }
                )
                .transition(.opacity)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(settingsViewModel: settingsViewModel)
        }
        .onAppear {
            viewModel.settingsViewModel = settingsViewModel
        }
    }
}

#Preview {
    ContentView()
}
