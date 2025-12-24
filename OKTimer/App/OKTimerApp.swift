//
//  OKTimerApp.swift
//  OKTimer
//
//  Created by Developer on 12/23/25.
//

import SwiftUI

@main
struct OKTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        #endif
    }
}
