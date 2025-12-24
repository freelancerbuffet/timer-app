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
    
    var body: some View {
        HStack(spacing: 8) {
            // Minutes picker
            Picker("Minutes", selection: $minutes) {
                ForEach(0..<60, id: \.self) { minute in
                    Text("\(minute)").tag(minute)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 70, height: 30)
            .clipped()
            .disabled(isDisabled)
            
            Text(":")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.primary.opacity(0.6))
            
            // Seconds picker
            Picker("Seconds", selection: $seconds) {
                ForEach(0..<60, id: \.self) { second in
                    Text("\(second)").tag(second)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 70, height: 30)
            .clipped()
            .disabled(isDisabled)
        }
        .opacity(isDisabled ? 0.4 : 1.0)
    }
}

#Preview {
    VStack(spacing: 40) {
        TimePickerView(minutes: .constant(5), seconds: .constant(0), isDisabled: false)
        TimePickerView(minutes: .constant(10), seconds: .constant(30), isDisabled: true)
    }
    .padding()
}
