//
//  ProgressOverlayManager.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import Foundation
import SwiftUI

#if os(macOS)
import AppKit

@MainActor
class ProgressOverlayManager: ObservableObject {
    static let shared = ProgressOverlayManager()
    
    private var overlayWindow: NSWindow?
    private var isShowingOverlay = false
    
    private init() {}
    
    deinit {
        // Ensure cleanup on deallocation
        Task { @MainActor in
            hideOverlay()
        }
    }
    
    func showProgressOverlay(progress: Double, timeRemaining: TimeInterval, totalTime: TimeInterval) {
        // Always update if already showing, otherwise create new
        if isShowingOverlay, let window = overlayWindow {
            updateOverlayContent(progress: progress, timeRemaining: timeRemaining, totalTime: totalTime)
            return
        }
        
        // Create new overlay
        createOverlay(progress: progress, timeRemaining: timeRemaining, totalTime: totalTime)
    }
    
    func hideOverlay() {
        guard isShowingOverlay, let window = overlayWindow else { return }
        
        isShowingOverlay = false
        
        // Animate out
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            window.animator().alphaValue = 0
        } completionHandler: { [weak self] in
            window.close()
            self?.overlayWindow = nil
        }
    }
    
    private func createOverlay(progress: Double, timeRemaining: TimeInterval, totalTime: TimeInterval) {
        guard let screen = NSScreen.main else { return }
        
        // Create a thin progress bar along the top edge of the screen
        let screenFrame = screen.visibleFrame
        let overlayHeight: CGFloat = 8
        let overlayFrame = NSRect(
            x: screenFrame.minX,
            y: screenFrame.maxY - overlayHeight,
            width: screenFrame.width,
            height: overlayHeight
        )
        
        let window = NSWindow(
            contentRect: overlayFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        window.hidesOnDeactivate = false
        window.ignoresMouseEvents = true // Don't interfere with other apps
        
        // Create the progress view
        let progressView = SystemProgressBarView(
            progress: progress,
            timeRemaining: timeRemaining,
            totalTime: totalTime
        )
        
        let hostingView = NSHostingView(rootView: progressView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        window.contentView = hostingView
        
        // Store reference and show
        self.overlayWindow = window
        self.isShowingOverlay = true
        
        // Animate in
        window.alphaValue = 0
        window.orderFront(nil)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            window.animator().alphaValue = 1.0
        }
    }
    
    private func updateOverlayContent(progress: Double, timeRemaining: TimeInterval, totalTime: TimeInterval) {
        guard let window = overlayWindow else { return }
        
        let progressView = SystemProgressBarView(
            progress: progress,
            timeRemaining: timeRemaining,
            totalTime: totalTime
        )
        
        let hostingView = NSHostingView(rootView: progressView)
        window.contentView = hostingView
    }
}

// MARK: - System Progress Bar View
struct SystemProgressBarView: View {
    let progress: Double
    let timeRemaining: TimeInterval
    let totalTime: TimeInterval
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .fill(Color.black.opacity(0.7))
                
                // Progress fill
                Rectangle()
                    .fill(progressColor)
                    .frame(width: geometry.size.width * progress)
                
                // Text overlay
                HStack {
                    Text(timeText)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.8), radius: 1)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.8), radius: 1)
                        .padding(.trailing, 8)
                }
            }
        }
        .frame(height: 8)
    }
    
    private var progressColor: Color {
        if progress < 0.33 {
            return .blue
        } else if progress < 0.66 {
            return .orange
        } else {
            return .red
        }
    }
    
    private var timeText: String {
        let remaining = Int(timeRemaining)
        let minutes = remaining / 60
        let seconds = remaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#else
// iOS placeholder
@MainActor
class ProgressOverlayManager: ObservableObject {
    static let shared = ProgressOverlayManager()
    
    func showProgressOverlay(progress: Double, timeRemaining: TimeInterval, totalTime: TimeInterval) {
        // iOS implementation would go here
    }
    
    func hideOverlay() {
        // iOS implementation would go here
    }
}
#endif
