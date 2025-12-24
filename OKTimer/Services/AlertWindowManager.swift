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

class AlertWindowManager: ObservableObject {
    static let shared = AlertWindowManager()
    
    private var alertWindow: NSWindow?
    
    private init() {}
    
    func showFullscreenAlert(onDismiss: @escaping () -> Void, onSnooze: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Create the alert window
            let window = NSWindow(
                contentRect: NSScreen.main?.frame ?? .zero,
                styleMask: [.borderless, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            
            window.isOpaque = false
            window.backgroundColor = .clear
            window.level = .screenSaver // Above all other windows
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            
            // Set the content view
            let hostingView = NSHostingView(rootView: FullscreenAlertView(
                onDismiss: { [weak self, weak window] in
                    onDismiss()
                    window?.close()
                    self?.alertWindow = nil
                },
                onSnooze: { [weak self, weak window] in
                    onSnooze()
                    window?.close()
                    self?.alertWindow = nil
                }
            ))
            
            window.contentView = hostingView
            
            // Show the window
            window.makeKeyAndOrderFront(nil)
            window.center()
            
            // Activate the app to bring the window to front
            NSApp.activate(ignoringOtherApps: true)
            
            self.alertWindow = window
        }
    }
    
    func dismissAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.alertWindow?.close()
            self?.alertWindow = nil
        }
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
