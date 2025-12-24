//
//  AlertWindowManager.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import Foundation
import SwiftUI

#if os(macOS)
import AppKit

@MainActor
class AlertWindowManager: ObservableObject {
    static let shared = AlertWindowManager()
    
    private var alertWindow: NSWindow?
    private var dismissCallback: (() -> Void)?
    private var snoozeCallback: (() -> Void)?
    
    private init() {}
    
    func showFullscreenAlert(onDismiss: @escaping () -> Void, onSnooze: @escaping () -> Void) {
        // Always dismiss existing alert first
        dismissAlert()
        
        // Store callbacks
        self.dismissCallback = onDismiss
        self.snoozeCallback = onSnooze
        
        // Create the alert window
        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1280, height: 800)
        let window = NSWindow(
            contentRect: screenFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.hidesOnDeactivate = false
        window.ignoresMouseEvents = false
        
        // Create simple, direct action handlers
        let alertView = SimpleFullscreenAlertView(
            onDismiss: { [weak self] in
                self?.handleDismiss()
            },
            onSnooze: { [weak self] in
                self?.handleSnooze()
            }
        )
        
        // Set up the content view with minimal nesting
        window.contentView = NSHostingView(rootView: alertView)
        
        // Store the window reference
        self.alertWindow = window
        
        // Show the window
        window.makeKeyAndOrderFront(nil)
        window.center()
        
        // Activate the app
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func handleDismiss() {
        let callback = self.dismissCallback
        closeWindow()
        callback?()
    }
    
    private func handleSnooze() {
        let callback = self.snoozeCallback
        closeWindow()
        callback?()
    }
    
    private func closeWindow() {
        if let window = alertWindow {
            window.orderOut(nil)
            window.close()
            alertWindow = nil
        }
        dismissCallback = nil
        snoozeCallback = nil
    }
    
    func dismissAlert() {
        closeWindow()
    }
}
#endif

#if os(iOS)
class AlertWindowManager: ObservableObject {
    static let shared = AlertWindowManager()
    
    private init() {}
    
    func showFullscreenAlert(onDismiss: @escaping () -> Void, onSnooze: @escaping () -> Void) {
        // On iOS, we'll use the in-app overlay which is already implemented
        // This is just a placeholder for API compatibility
    }
    
    func dismissAlert() {
        // Placeholder for iOS
    }
}
#endif

// Simple alert view with minimal state and animation to avoid memory issues
private struct SimpleFullscreenAlertView: View {
    let onDismiss: () -> Void
    let onSnooze: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Alert icon
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "bell.fill")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Message
                VStack(spacing: 12) {
                    Text("⏰ TIME'S UP!")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Your timer has completed")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Buttons
                VStack(spacing: 12) {
                    Button("Dismiss", action: onDismiss)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: 250, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                    
                    Button("Snooze 5 min", action: onSnooze)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(maxWidth: 250, minHeight: 45)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                }
                .padding(.bottom, 50)
            }
        }
    }
}
