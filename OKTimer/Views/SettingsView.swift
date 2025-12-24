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
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.system(size: 28, weight: .light, design: .rounded))
                    .foregroundColor(.primary.opacity(0.8))
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary.opacity(0.6))
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color.primary.opacity(0.06))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Audio section
                    SettingsSection(title: "Audio", icon: "speaker.wave.2") {
                        SettingsToggle(
                            title: "Sound Effects",
                            subtitle: "Play completion sound",
                            isOn: $settingsViewModel.settings.soundEnabled
                        )
                    }
                    
                    // Haptics section (iOS only)
                    #if os(iOS)
                    SettingsSection(title: "Haptics", icon: "iphone.radiowaves.left.and.right") {
                        SettingsToggle(
                            title: "Haptic Feedback",
                            subtitle: "Vibration when timer completes",
                            isOn: $settingsViewModel.settings.hapticsEnabled
                        )
                    }
                    #endif
                    
                    // Theme section
                    SettingsSection(title: "Appearance", icon: "paintbrush") {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Color Theme")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                ForEach(TimerSettings.ColorTheme.allCases, id: \.id) { theme in
                                    ThemeOption(
                                        theme: theme,
                                        isSelected: settingsViewModel.settings.theme == theme
                                    ) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            settingsViewModel.settings.theme = theme
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // About section
                    SettingsSection(title: "About", icon: "info.circle") {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("OK Timer")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.primary)
                                Text("Version 1.0.0")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            #if os(iOS)
            Color.clear
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 0))
            #else
            Color.clear
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            #endif
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

// MARK: - Settings Section
struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.accentColor)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.primary.opacity(0.8))
            }
            
            VStack(spacing: 0) {
                content
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.primary.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Settings Toggle
struct SettingsToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .scaleEffect(0.8)
        }
    }
}

// MARK: - Theme Option
struct ThemeOption: View {
    let theme: TimerSettings.ColorTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(themeColor(for: theme))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(isSelected ? 0.3 : 0.1), lineWidth: isSelected ? 2 : 1)
                    )
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(theme.rawValue)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .regular, design: .rounded))
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
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
