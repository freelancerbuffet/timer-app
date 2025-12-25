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
    private var progressOverlayWindow: NSWindow?
    private var dismissCallback: (() -> Void)?
    private var snoozeCallback: (() -> Void)?
    private var isShowingAlert = false
    private var isShowingProgressOverlay = false
    
    private init() {}
    
    deinit {
        // Ensure cleanup on deallocation
        Task { @MainActor in
            dismissAlert()
            hideProgressOverlay()
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
    
    // MARK: - Progress Overlay Methods
    
    func showProgressOverlay(progress: Double, timeRemaining: TimeInterval, totalTime: TimeInterval) {
        guard !isShowingProgressOverlay else {
            updateProgressOverlay(progress: progress, timeRemaining: timeRemaining, totalTime: totalTime)
            return
        }
        
        isShowingProgressOverlay = true
        
        // Get the main screen bounds
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.frame
        
        // Create a small overlay window in the top-right corner
        let overlaySize: CGFloat = 120
        let margin: CGFloat = 20
        let overlayFrame = NSRect(
            x: screenFrame.maxX - overlaySize - margin,
            y: screenFrame.maxY - overlaySize - margin,
            width: overlaySize,
            height: overlaySize
        )
        
        let window = NSWindow(
            contentRect: overlayFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.hidesOnDeactivate = false
        window.ignoresMouseEvents = true // Don't interfere with user interactions
        
        let overlayView = SystemProgressOverlayView(
            progress: progress,
            timeRemaining: timeRemaining,
            totalTime: totalTime
        )
        
        let hostingView = NSHostingView(rootView: overlayView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        window.contentView = hostingView
        
        self.progressOverlayWindow = window
        window.orderFront(nil)
    }
    
    func updateProgressOverlay(progress: Double, timeRemaining: TimeInterval, totalTime: TimeInterval) {
        guard let window = progressOverlayWindow,
              let hostingView = window.contentView as? NSHostingView<SystemProgressOverlayView> else {
            return
        }
        
        let updatedView = SystemProgressOverlayView(
            progress: progress,
            timeRemaining: timeRemaining,
            totalTime: totalTime
        )
        
        hostingView.rootView = updatedView
    }
    
    func hideProgressOverlay() {
        guard let window = progressOverlayWindow, isShowingProgressOverlay else { return }
        
        isShowingProgressOverlay = false
        
        // Clear content view
        window.contentView = nil
        
        // Clear reference
        progressOverlayWindow = nil
        
        // Close window
        DispatchQueue.main.async {
            window.orderOut(nil)
        }
    }
}

// MARK: - System Progress Overlay View

private struct SystemProgressOverlayView: View {
    let progress: Double
    let timeRemaining: TimeInterval
    let totalTime: TimeInterval
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            RoundedRectangle(cornerRadius: 16)
                .fill(.black.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
            
            // Progress indicator
            RadialProgressIndicator(
                progress: progress,
                timeRemaining: timeRemaining,
                totalTime: totalTime,
                isSystemOverlay: true
            )
            .padding(12)
        }
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
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

// Simple alert view with confetti and beautiful animations
private struct SimpleFullscreenAlertView: View {
    let onDismiss: () -> Void
    let onSnooze: () -> Void
    
    @State private var scale: CGFloat = 0.3
    @State private var bellScale: CGFloat = 1.0
    @State private var opacity: Double = 0
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.95)
                .ignoresSafeArea()
            
            // Confetti layer
            if showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                // Alert icon with pulsing animation
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.red.opacity(0.6), Color.orange.opacity(0.3), Color.clear],
                                center: .center,
                                startRadius: 50,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                        .scaleEffect(bellScale)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.red, .orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)
                        .scaleEffect(bellScale)
                    
                    Image(systemName: "bell.fill")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.5), radius: 10)
                        .scaleEffect(bellScale)
                }
                .scaleEffect(scale)
                
                // Message with enhanced styling
                VStack(spacing: 20) {
                    Text("⏰ TIME'S UP!")
                        .font(.system(size: 56, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .red.opacity(0.5), radius: 15)
                        .shadow(color: .orange.opacity(0.3), radius: 30)
                    
                    Text("Your timer has completed")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                }
                .opacity(opacity)
                
                Spacer()
                
                // Enhanced buttons with gradients
                VStack(spacing: 16) {
                    Button(action: onDismiss) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                            Text("Dismiss")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: 320, minHeight: 64)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .cyan],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .cyan.opacity(0.5), radius: 15)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: onSnooze) {
                        HStack {
                            Image(systemName: "moon.zzz.fill")
                                .font(.system(size: 18, weight: .medium))
                            Text("Snooze 5 min")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                        }
                        .foregroundColor(.white.opacity(0.95))
                        .frame(maxWidth: 320, minHeight: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .opacity(opacity)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            // Entrance animations
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                opacity = 1.0
            }
            
            // Start confetti after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showConfetti = true
            }
            
            // Pulsing bell animation
            withAnimation(
                Animation.easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true)
            ) {
                bellScale = 1.15
            }
        }
    }
}
