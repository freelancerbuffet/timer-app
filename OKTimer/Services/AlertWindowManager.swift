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
    private var alertWindow: NSWindow?
    private var dismissCallback: (() -> Void)?
    private var snoozeCallback: (() -> Void)?
    private var isShowingAlert = false
    
    init() {}
    
    deinit {
        // Ensure cleanup on deallocation
        Task { @MainActor in
            dismissAlert()
        }
    }
    
    func showFullscreenAlert(onDismiss: @escaping () -> Void, onSnooze: @escaping () -> Void) {
        // Prevent multiple alerts
        guard !isShowingAlert else { return }
        
        // Always dismiss existing alert first
        dismissAlert()
        
        // Set showing flag
        isShowingAlert = true
        
        // Store callbacks with weak self to avoid retain cycles
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
        
        // Create simple, direct action handlers with explicit weak references
        let alertView = SimpleFullscreenAlertView(
            onDismiss: { [weak self] in
                DispatchQueue.main.async {
                    self?.handleDismiss()
                }
            },
            onSnooze: { [weak self] in
                DispatchQueue.main.async {
                    self?.handleSnooze()
                }
            }
        )
        
        // Set up the content view with minimal nesting
        let hostingView = NSHostingView(rootView: alertView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        window.contentView = hostingView
        
        // Store the window reference
        self.alertWindow = window
        
        // Show the window
        window.makeKeyAndOrderFront(nil)
        window.center()
        
        // Activate the app
        NSApp.activate(ignoringOtherApps: true)
    }
    private func handleDismiss() {
        // Prevent multiple calls by checking if window still exists
        guard let window = alertWindow, isShowingAlert else { return }
        
        // Clear the showing flag immediately
        isShowingAlert = false
        
        // Capture callback first
        let callback = self.dismissCallback
        
        // Clear everything immediately to prevent race conditions
        self.alertWindow = nil
        self.dismissCallback = nil
        self.snoozeCallback = nil
        
        // Clear content view to break any potential retain cycles
        window.contentView = nil
        
        // Close window on the main queue
        DispatchQueue.main.async {
            window.orderOut(nil)
        }
        
        // Execute callback after clearing references
        if let callback = callback {
            DispatchQueue.main.async {
                callback()
            }
        }
    }

    private func handleSnooze() {
        // Prevent multiple calls by checking if window still exists
        guard let window = alertWindow, isShowingAlert else { return }
        
        // Clear the showing flag immediately
        isShowingAlert = false
        
        // Capture callback first
        let callback = self.snoozeCallback
        
        // Clear everything immediately to prevent race conditions
        self.alertWindow = nil
        self.dismissCallback = nil
        self.snoozeCallback = nil
        
        // Clear content view to break any potential retain cycles
        window.contentView = nil
        
        // Close window on the main queue
        DispatchQueue.main.async {
            window.orderOut(nil)
        }
        
        // Execute callback after clearing references
        if let callback = callback {
            DispatchQueue.main.async {
                callback()
            }
        }
    }
    private func closeWindow() {
        // This method is now only called from dismissAlert()
        guard let window = alertWindow else { return }
        
        // Clear the showing flag
        isShowingAlert = false
        
        // Clear content view to break any potential retain cycles
        window.contentView = nil
        
        // Clear references immediately
        alertWindow = nil
        dismissCallback = nil
        snoozeCallback = nil
        
        // Close window on main queue to avoid threading issues
        DispatchQueue.main.async {
            window.orderOut(nil)
        }
    }

    func dismissAlert() {
        // Only close if we actually have a window to avoid double-close
        guard alertWindow != nil, isShowingAlert else { return }
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
