//
//  TimePickerView.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    let isDisabled: Bool
    
    @State private var minutesText: String = ""
    @State private var secondsText: String = ""
    @FocusState private var isMinutesFocused: Bool
    @FocusState private var isSecondsFocused: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            // Minutes input
            TimeInputField(
                text: $minutesText,
                value: $minutes,
                placeholder: "00",
                isFocused: $isMinutesFocused,
                isDisabled: isDisabled,
                maxValue: 59
            )
            .onSubmit {
                isSecondsFocused = true
            }
            
            Text(":")
                .font(.system(size: 32, weight: .light, design: .rounded))
                .foregroundColor(.primary.opacity(0.4))
                .padding(.horizontal, 4)
            
            // Seconds input
            TimeInputField(
                text: $secondsText,
                value: $seconds,
                placeholder: "00",
                isFocused: $isSecondsFocused,
                isDisabled: isDisabled,
                maxValue: 59
            )
            .onSubmit {
                isSecondsFocused = false
                isMinutesFocused = false
            }
        }
        .onAppear {
            minutesText = String(format: "%02d", minutes)
            secondsText = String(format: "%02d", seconds)
        }
        .onChange(of: minutes) { newValue in
            if !isMinutesFocused {
                minutesText = String(format: "%02d", newValue)
            }
        }
        .onChange(of: seconds) { newValue in
            if !isSecondsFocused {
                secondsText = String(format: "%02d", newValue)
            }
        }
        .opacity(isDisabled ? 0.4 : 1.0)
    }
}

struct TimeInputField: View {
    @Binding var text: String
    @Binding var value: Int
    let placeholder: String
    @FocusState.Binding var isFocused: Bool
    let isDisabled: Bool
    let maxValue: Int
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(isFocused ? 0.08 : 0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isFocused ? Color.accentColor.opacity(0.6) : Color.clear,
                            lineWidth: 2
                        )
                )
                .animation(.easeInOut(duration: 0.2), value: isFocused)
            
            // Text field
            TextField(placeholder, text: $text)
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .focused($isFocused)
                .disabled(isDisabled)
                .onChange(of: text) { newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    let truncated = String(filtered.prefix(2))
                    
                    if truncated != text {
                        text = truncated
                    }
                    
                    if let intValue = Int(truncated), intValue <= maxValue {
                        value = intValue
                    } else if let intValue = Int(truncated), intValue > maxValue {
                        let correctedValue = maxValue
                        value = correctedValue
                        text = String(format: "%02d", correctedValue)
                    } else if truncated.isEmpty {
                        value = 0
                    }
                }
                .onChange(of: isFocused) { focused in
                    if !focused && !text.isEmpty {
                        // Format the text when losing focus
                        text = String(format: "%02d", value)
                    } else if focused && text == "00" {
                        // Clear placeholder when focused
                        text = ""
                    }
                }
        }
        .frame(width: 80, height: 50)
    }
}

#Preview {
    VStack(spacing: 40) {
        TimePickerView(minutes: .constant(5), seconds: .constant(0), isDisabled: false)
        TimePickerView(minutes: .constant(10), seconds: .constant(30), isDisabled: true)
    }
    .padding()
}
