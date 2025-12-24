//
//  ContentView.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("OK TIMER")
                .font(.system(size: 36, weight: .light, design: .rounded))
                .foregroundColor(.primary.opacity(0.8))
            
            Text("05:00")
                .font(.system(size: 72, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .monospacedDigit()
            
            HStack(spacing: 16) {
                Button("Start") {
                    // Timer logic will be added
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button("Reset") {
                    // Reset logic will be added
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            #if os(iOS)
            Color.clear
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 0))
            #else
            Color.clear
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            #endif
        }
        .preferredColorScheme(.none)
    }
}

#Preview {
    ContentView()
}
