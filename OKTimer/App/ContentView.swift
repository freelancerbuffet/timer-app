//
//  ContentView.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var showSettings = false
    @State private var showStatistics = false
    @Environment(\.scenePhase) private var scenePhase
    @State private var isWindowFocused = true // Track window focus for macOS
    @State private var activeObserver: NSObjectProtocol?
    @State private var resignObserver: NSObjectProtocol?
    
    var body: some View {
        mainContent
            .onAppear(perform: setupView)
            .onDisappear(perform: cleanupView)
            .onChange(of: scenePhase, perform: handleScenePhaseChange)
            .onChange(of: isWindowFocused, perform: handleWindowFocusChange)
            .onChange(of: viewModel.progress, perform: handleProgressChange)
            .onChange(of: viewModel.timerState, perform: handleTimerStateChange)
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerView
            
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
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundView)
        .preferredColorScheme(.none)
        .overlay(completionAnimationOverlay)
        .overlay(radialProgressOverlay)
        .sheet(isPresented: $showSettings) {
            SettingsView(settingsViewModel: settingsViewModel)
        }
    }
    
    private var headerView: some View {
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
    }
    
    private var backgroundView: some View {
        #if os(iOS)
        Color.clear
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 0))
        #else
        Color.clear
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        #endif
    }
    
    @ViewBuilder
    private var completionAnimationOverlay: some View {
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
            .onAppear {
                print("🎉 DEBUG: Showing completion animation overlay - showCompletionAnimation is true")
                print("🎉 ContentView: CompletionAnimationView overlay appeared")
            }
        }
    }
    
    @ViewBuilder
    private var radialProgressOverlay: some View {
        #if os(macOS)
        if !isWindowFocused && viewModel.timerState == .running {
            RadialProgressIndicator(
                progress: viewModel.progress,
                timeRemaining: viewModel.timeRemaining,
                totalTime: viewModel.totalTime
            )
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.3), value: isWindowFocused)
            .onAppear {
                NSLog("🎯 DEBUG: RadialProgressIndicator appeared!")
                NSLog("🎯 isWindowFocused: \(isWindowFocused)")
                NSLog("🎯 scenePhase: \(scenePhase)")
                NSLog("🎯 timerState: \(viewModel.timerState)")
                NSLog("🎯 progress: \(viewModel.progress)")
            }
        }
        #endif
    }
    
    private func setupView() {
        viewModel.settingsViewModel = settingsViewModel
        NSLog("🚀 ContentView appeared - setting up focus monitoring")
        
        #if os(macOS)
        // Monitor window focus changes on macOS
        activeObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            isWindowFocused = true
            NSLog("🔄 macOS: App became active, hiding radial progress")
        }
        
        resignObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didResignActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            isWindowFocused = false
            NSLog("🔄 macOS: App lost focus, showing radial progress if timer is running")
            NSLog("🔄 Current timer state: \(viewModel.timerState)")
        }
        NSLog("🚀 macOS: Notification observers set up successfully")
        #endif
    }
    
    private func cleanupView() {
        #if os(macOS)
        // Clean up notification observers
        if let activeObserver = activeObserver {
            NotificationCenter.default.removeObserver(activeObserver)
        }
        if let resignObserver = resignObserver {
            NotificationCenter.default.removeObserver(resignObserver)
        }
        #endif
    }
    
    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        NSLog("🔄 Scene phase changed to: \(newPhase)")
        if newPhase == .background || newPhase == .inactive {
            if viewModel.timerState == .running {
                NSLog("🎯 Timer is running, radial progress indicator should show")
            }
        }
    }
    
    private func handleWindowFocusChange(_ focused: Bool) {
        NSLog("🔄 macOS: Window focus changed to: \(focused)")
        NSLog("🔄 Timer state: \(viewModel.timerState)")
        NSLog("🔄 Should show overlay: \(!focused && viewModel.timerState == .running)")
        
        #if os(macOS)
        // Manage system-wide overlay based on focus
        if !focused && viewModel.timerState == .running {
            NSLog("🎯 macOS: Timer is running and window lost focus, showing system progress overlay")
            AlertWindowManager.shared.showProgressOverlay(
                progress: viewModel.progress,
                timeRemaining: viewModel.timeRemaining,
                totalTime: viewModel.totalTime
            )
        } else {
            AlertWindowManager.shared.hideProgressOverlay()
        }
        #endif
    }
    
    private func handleProgressChange(_: Double) {
        #if os(macOS)
        // Update system overlay if it's visible
        if !isWindowFocused && viewModel.timerState == .running {
            AlertWindowManager.shared.showProgressOverlay(
                progress: viewModel.progress,
                timeRemaining: viewModel.timeRemaining,
                totalTime: viewModel.totalTime
            )
        }
        #endif
    }
    
    private func handleTimerStateChange(_ newState: TimerState) {
        NSLog("🔄 Timer state changed to: \(newState)")
        #if os(macOS)
        // Hide system overlay when timer stops
        if newState != .running {
            AlertWindowManager.shared.hideProgressOverlay()
        }
        #endif
    }
}

#Preview {
    ContentView()
}
