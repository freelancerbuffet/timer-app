//
//  PresetButtonsView.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI

struct PresetButtonsView: View {
    let onPresetSelected: (TimeInterval) -> Void
    let isDisabled: Bool
    
    private let presets: [(label: String, seconds: TimeInterval)] = [
        ("1m", 60),
        ("5m", 300),
        ("10m", 600),
        ("15m", 900),
        ("30m", 1800)
    ]
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(presets, id: \.label) { preset in
                Button(preset.label) {
                    onPresetSelected(preset.seconds)
                }
                .buttonStyle(PresetButtonStyle(isDisabled: isDisabled))
                .disabled(isDisabled)
                .accessibilityLabel(accessibilityLabel(for: preset))
                .accessibilityHint("Set timer to this duration")
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Preset timers")
    }
    
    private func accessibilityLabel(for preset: (label: String, seconds: TimeInterval)) -> String {
        let minutes = Int(preset.seconds) / 60
        return "\(minutes) minute\(minutes == 1 ? "" : "s")"
    }
}

struct PresetButtonStyle: ButtonStyle {
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .foregroundColor(isDisabled ? .primary.opacity(0.3) : .primary.opacity(0.7))
            .frame(minWidth: 44, minHeight: 36)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.primary.opacity(configuration.isPressed ? 0.15 : 0.08))
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        PresetButtonsView(onPresetSelected: { _ in }, isDisabled: false)
        PresetButtonsView(onPresetSelected: { _ in }, isDisabled: true)
    }
    .padding()
}
