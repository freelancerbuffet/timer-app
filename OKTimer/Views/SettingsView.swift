//
//  SettingsView.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                // Audio section
                Section {
                    Toggle("Sound Effects", isOn: $settingsViewModel.settings.soundEnabled)
                } header: {
                    Text("Audio")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                }
                
                // Haptics section (iOS only)
                #if os(iOS)
                Section {
                    Toggle("Haptic Feedback", isOn: $settingsViewModel.settings.hapticsEnabled)
                } header: {
                    Text("Haptics")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                }
                #endif
                
                // Theme section
                Section {
                    Picker("Color Theme", selection: $settingsViewModel.settings.theme) {
                        ForEach(TimerSettings.ColorTheme.allCases, id: \.id) { theme in
                            HStack {
                                Circle()
                                    .fill(themeColor(for: theme))
                                    .frame(width: 20, height: 20)
                                Text(theme.rawValue)
                            }
                            .tag(theme)
                        }
                    }
                } header: {
                    Text("Appearance")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                }
                
                // About section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("About")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                }
            }
            .navigationTitle("Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func themeColor(for theme: TimerSettings.ColorTheme) -> Color {
        switch theme {
        case .blue:
            return .blue
        case .green:
            return .green
        case .orange:
            return .orange
        case .purple:
            return .purple
        case .monochrome:
            return .gray
        }
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel())
}
