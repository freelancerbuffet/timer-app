# ⏰ OK TIMER

<div align="center">

**A beautifully minimalistic timer application for iOS and macOS**

[![Platform](https://img.shields.io/badge/Platform-iOS%2015%2B%20%7C%20macOS%2012%2B-blue)](https://developer.apple.com/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-green)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Screenshots](#-screenshots) • [Architecture](#-architecture)

</div>

---

## ✨ Features

### Core Functionality
- ⏱️ **Precise Timer** - Countdown with 0.1 second precision using Combine
- 🎯 **Quick Presets** - One-tap access to 1, 5, 10, 15, and 30 minute timers
- ⌨️ **Keyboard Input** - Type timer duration directly for ultimate speed
- 🎨 **5 Beautiful Themes** - Blue, Green, Orange, Purple, and Monochrome color schemes
- 🔄 **Progress Ring** - Animated circular progress with dynamic gradient colors

### User Experience
- 🎉 **Celebration Animations** - Confetti and stars when timer completes
- 🚨 **Fullscreen Alerts** (macOS) - Impossible-to-miss alerts that takeover your entire screen
- 😴 **Snooze Function** - Quick 5-minute snooze with auto-restart
- 🔊 **Sound Effects** - Pleasant chime on completion (toggleable)
- 📳 **Haptic Feedback** (iOS) - Tactile response for all actions (toggleable)
- 🔔 **Background Notifications** - Get alerted even when app is closed

### Design & Accessibility
- 🌓 **Dark/Light Mode** - Automatic theme support
- 💎 **Translucent UI** - Ultra-thin material blur effects
- ♿ **Full Accessibility** - VoiceOver support with descriptive labels
- 📱 **Responsive Layout** - Optimized for all screen sizes
- ⌨️ **Keyboard Shortcuts** (macOS) - Cmd+S, Cmd+R, Cmd+1, Cmd+5

### Advanced Features
- ⚙️ **Customizable Settings** - Audio, haptics, and theme preferences
- 💾 **Persistent State** - All settings saved automatically
- 🎯 **Radial Progress View** - Beautiful minimalist view when app loses focus
- 🔗 **URL Scheme Support** - oktimer:// for automation and shortcuts

---

## 📱 Installation

### Requirements
- **iOS**: 15.0 or later
- **macOS**: 12.0 (Monterey) or later
- **Xcode**: 14.0 or later
- **Swift**: 5.9 or later

### Build from Source

```bash
# Clone the repository
git clone https://github.com/freelancerbuffet/timer-app.git
cd timer-app

# Open in Xcode
open OKTimer.xcodeproj

# Select your target (iOS or macOS) and run
```

---

## 🎯 Usage

### Basic Operations

1. **Set Time**: Tap the timer display and enter minutes/seconds, or use preset buttons
2. **Start**: Tap the Start button or press `Cmd+S` (macOS)
3. **Pause**: Tap Pause during countdown or press `Cmd+S` (macOS)
4. **Reset**: Tap Reset or press `Cmd+R` (macOS)

### Keyboard Shortcuts (macOS)

| Shortcut | Action |
|----------|--------|
| `Cmd+S` | Start/Pause timer |
| `Cmd+R` | Reset timer |
| `Cmd+1` | Set 1 minute timer |
| `Cmd+5` | Set 5 minute timer |

### Settings

Access settings via the gear icon to customize:
- **Sound Effects** - Toggle completion chime on/off
- **Haptic Feedback** (iOS) - Enable/disable haptic responses
- **Theme** - Choose from 5 color schemes

---

## 📸 Screenshots

### iOS
<details>
<summary>View iOS Screenshots</summary>

*Timer Display with Progress Ring*
- Clean, minimalist interface
- Circular progress with gradient
- Quick preset buttons

*Completion Celebration*
- Confetti animation
- Animated checkmark
- Snooze or dismiss options

*Settings*
- Beautiful card-based layout
- Theme picker with previews
- Audio and haptic toggles

</details>

### macOS
<details>
<summary>View macOS Screenshots</summary>

*Main Timer Window*
- Translucent blur background
- Keyboard-friendly input
- Smooth animations

*Fullscreen Alert*
- Takes over entire screen
- Impossible to miss
- Pulsing bell icon with confetti
- Gradient action buttons

*Radial Progress Indicator*
- Minimalist progress ring
- Starts at 12 o'clock position
- Dynamic gradient colors
- Friendly to eyes

</details>

---

## 🏗️ Architecture

### MVVM Pattern with SwiftUI

```
OKTimer/
├── App/
│   ├── OKTimerApp.swift          # App entry point
│   └── ContentView.swift         # Main view
├── Models/
│   ├── TimerState.swift          # Timer state enum
│   ├── TimerSettings.swift       # Settings model
│   └── TimerSession.swift        # Session tracking
├── ViewModels/
│   ├── TimerViewModel.swift      # Timer business logic
│   └── SettingsViewModel.swift   # Settings management
├── Views/
│   ├── TimerDisplayView.swift    # Main timer display
│   ├── ProgressRingView.swift    # Circular progress
│   ├── TimerControlsView.swift   # Start/Pause/Reset buttons
│   ├── PresetButtonsView.swift   # Quick presets
│   ├── TimePickerView.swift      # Time input
│   ├── SettingsView.swift        # Settings interface
│   ├── CompletionAnimationView.swift  # iOS completion
│   ├── ConfettiView.swift        # Celebration effects
│   └── RadialProgressIndicator.swift  # Minimalist progress
├── Services/
│   ├── SoundService.swift        # Audio playback
│   ├── HapticService.swift       # Haptic feedback (iOS)
│   └── AlertWindowManager.swift  # macOS alert windows
└── Utilities/
    ├── ColorTheme.swift          # Theme definitions
    ├── KeyboardShortcuts.swift   # Keyboard support
    └── AppFeatures.swift         # Notifications & features
```

### Key Technologies

- **SwiftUI** - Modern declarative UI framework
- **Combine** - Reactive timer updates with 0.1s precision
- **UserDefaults** - Settings and preference persistence
- **UserNotifications** - Background notification support
- **AVFoundation** - Audio playback for completion sounds
- **AppKit** (macOS) - Window management for fullscreen alerts
- **UIKit** (iOS) - Haptic feedback generation

---

## 🎨 Design Philosophy

OK Timer follows these core principles:

1. **Minimalism** - Only essential features, nothing more
2. **Beauty** - Smooth animations and delightful interactions
3. **Clarity** - Clean typography and intuitive interface
4. **Accessibility** - VoiceOver support for all users
5. **Performance** - 60fps animations, efficient battery use
6. **Privacy** - All data stored locally, no tracking

---

## 🚀 Roadmap

### Future Enhancements
- [ ] Apple Watch companion app
- [ ] Live Activities with Dynamic Island support
- [ ] Siri Shortcuts integration
- [ ] Focus Mode automation
- [ ] iCloud sync across devices
- [ ] Session statistics and history
- [ ] Custom sound effects
- [ ] Multiple timer support
- [ ] Timer templates

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Design inspired by modern iOS/macOS design principles
- Built with ❤️ using SwiftUI and Combine
- Special thanks to the Swift and SwiftUI communities

---

## 📧 Contact

For questions, suggestions, or feedback:
- Open an issue on GitHub
- Submit a pull request
- Contact the maintainers

---

<div align="center">

**Made with ⏰ and ❤️**

⭐ Star this repo if you find it useful!

</div>

## ✅ Current Status

**✓ Phase 1-4 Complete - Production-Ready with Modern Features**
- Beautiful minimalist UI with translucent blur effects
- Full timer functionality (Start, Pause, Resume, Reset)
- Circular progress ring with gradient color transitions
- Quick preset buttons (1m, 5m, 10m, 15m, 30m)
- Keyboard-friendly text input for time setting
- Smooth animations for all state transitions
- Light/Dark mode support
- Responsive layout for iOS and macOS
- **Sound effects on timer completion**
- **Haptic feedback for all timer actions (iOS)**
- **Animated completion overlay with checkmark**
- **⚙️ Settings with audio/haptic toggles**
- **🎨 5 color themes (Blue, Green, Orange, Purple, Monochrome)**
- **💾 Persistent preferences with UserDefaults**
- **♿ Comprehensive accessibility (VoiceOver, labels, hints)**
- **📊 Statistics & session tracking**
- **🏆 Session history with completion metrics**
- **📱 Home Screen widget foundation**
- **🔗 Deep linking support (oktimer://)**

**✓ Project Setup Complete**
- Xcode project structure created and configured
- SwiftUI app template with iOS 15.0+ and macOS 12.0+ support
- Project builds and runs successfully on both platforms
- Directory structure matches architectural requirements
- MVVM architecture fully implemented

## 🚀 Development Phases

### Phase 1: Core Timer Functionality & Visual Design ✅
**Priority: HIGH - Foundation & User Experience**
- [x] Implement `TimerViewModel` with state management using Combine
- [x] Create `TimerDisplayView` with countdown display (MM:SS format)
- [x] Build `TimePickerView` for setting minutes and seconds
- [x] Add `TimerControlsView` with Start/Pause/Resume/Reset buttons
- [x] Implement precise countdown logic (0.1s intervals)
- [x] Implement translucent background with ultra-thin material blur
- [x] Create `ProgressRingView` with gradient color transitions
- [x] Add `PresetButtonsView` for quick timer presets (1, 5, 10, 15, 30 min)
- [x] Implement smooth animations for state transitions
- [x] Support Light/Dark mode with proper color schemes
- [x] Responsive layout for different screen sizes

**Status: COMPLETE ✓**

### Phase 2: Completion Experience ✅
**Priority: MEDIUM - Delight**
- [x] Create `CompletionAnimationView` with bounce and scale effects
- [x] Implement `SoundService` for notification sounds
- [x] Add system sounds (using iOS/macOS system chimes)
- [x] Implement `HapticService` for iOS haptic feedback
- [ ] Create `NotificationService` for background notifications (Phase 3)
- [ ] Handle background timer completion and app foregrounding (Phase 3)

**Status: COMPLETE ✓**

### Phase 3: Settings & Customization ✅
**Priority: MEDIUM - Flexibility**
- [x] Build `SettingsView` with grouped settings sections
- [x] Implement `SettingsViewModel` for preference management  
- [x] Add theme selection (Blue, Green, Orange, Purple, Monochrome)
- [x] Add sound toggle (enable/disable completion sound)
- [x] Add haptic feedback toggle (iOS only)
- [x] Implement UserDefaults persistence for all settings
- [x] Integrate settings into timer functionality

**Status: COMPLETE ✓**

### Phase 4: Polish & Modern Features ✅
**Priority: HIGH - 2025-2030 Best-Seller Strategy**
- [x] Comprehensive accessibility support (VoiceOver, labels, hints)
- [x] Session tracking and history
- [x] Statistics view with metrics (today, week, total, average)
- [x] Home Screen widget foundation (small & medium)
- [x] Deep linking support (oktimer:// URL scheme)
- [x] Statistics button in main UI
- [x] Performance optimized for smooth animations
- [x] Clean data architecture with UserDefaults
- [ ] App icon design and implementation
- [ ] Unit and UI tests
- [ ] Dynamic Type support
- [ ] Additional widget sizes

**Status: CORE FEATURES COMPLETE ✓**
- [ ] Prepare App Store assets and descriptions

**Estimated Time: 1 week**

## 🏗️ Architecture Overview

**SwiftUI + MVVM Pattern**
- Views: Pure SwiftUI declarative UI
- ViewModels: `@ObservableObject` classes managing state
- Models: Value types for data representation
- Services: Business logic and system integration

**Key Technologies**
- SwiftUI for cross-platform UI
- Combine for reactive programming
- AVAudioPlayer for sound playback
- UserDefaults for settings persistence
- Local notifications for background alerts

## 📁 Current Project Structure

```
OKTimer/
├── App/
│   ├── OKTimerApp.swift          ✅ App entry point
│   └── ContentView.swift         ✅ Main container view
├── Views/
│   ├── TimerDisplayView.swift    ✅ Main timer display with tap-to-edit
│   ├── TimerControlsView.swift   ✅ Start/pause/reset buttons
│   ├── TimePickerView.swift      ✅ Time input interface
│   ├── PresetButtonsView.swift   ✅ Quick preset buttons
│   ├── ProgressRingView.swift    ✅ Circular progress indicator
│   ├── CompletionAnimationView.swift ✅ Completion overlay with animation
│   └── SettingsView.swift        ✅ Settings screen
├── ViewModels/
│   ├── TimerViewModel.swift      ✅ Timer logic and state (Combine-based)
│   └── SettingsViewModel.swift   ✅ Settings management
├── Models/
│   ├── TimerState.swift          ✅ Timer state enum
│   └── TimerSettings.swift       ✅ User preferences model
├── Services/
│   ├── SoundService.swift        ✅ Sound playback management
│   ├── HapticService.swift       ✅ Haptic feedback (iOS)
│   └── NotificationService.swift 📝 Phase 3 - Local notifications
├── Utilities/
│   └── ColorTheme.swift          ✅ Theme color definitions
└── Resources/
    ├── Sounds/                   📂 Ready for audio files
    └── Assets.xcassets/          ✅ App assets
```

## 🛠️ Getting Started

### Prerequisites
- Xcode 14.0+ (recommended: latest version)
- macOS 12.0+ for development
- iOS 15.0+ or macOS 12.0+ for deployment
- Apple Developer account (for device testing)

### Quick Start
```bash
# Clone the repository
git clone <repository-url>
cd timer-app

# Open in Xcode
open OKTimer.xcodeproj

# Or use the setup script
./setup.sh
```

### Building & Running
```bash
# Build for iOS Simulator
xcodebuild -scheme OKTimer -destination 'platform=iOS Simulator,name=iPhone 15' build

# Build for macOS
xcodebuild -scheme OKTimer -destination 'platform=macOS' build

# Run tests (when available)
xcodebuild test -scheme OKTimer
```

## 📝 Next Steps

1. **Phase 2: Completion Experience** - Add sound effects, haptic feedback, and completion animations
2. **Phase 3: Settings & Customization** - Implement settings screen with theme selection
3. **Phase 4: Polish & Optimization** - Add app icon, accessibility features, and tests
4. **App Store Release** - Prepare assets and submit to App Store

## 🎨 Design Highlights

**Current Implementation:**
- Ultra-thin material blur background
- Circular progress ring with dynamic gradients (Blue → Cyan → Orange → Red)
- Large monospaced timer display (72pt iOS / 96pt macOS)
- Smooth animations (0.3s ease-in-out transitions)
- Custom button styles with press effects
- Tap-to-edit time picker functionality
- Quick preset buttons (1m, 5m, 10m, 15m, 30m)

**Color Scheme**
- Light: White translucent with blue accent (#007AFF)
- Dark: Dark gray translucent with blue accent (#0A84FF)
- Progress ring: Dynamic gradient (Blue → Orange → Red)

**Typography**
- Timer: SF Pro Rounded, Semibold, 72pt (iOS) / 96pt (macOS)
- Buttons: SF Pro, Medium, 17pt
- Settings: SF Pro, Regular, 15pt

**Key Measurements**
- Edge padding: 24pt (iOS) / 32pt (macOS)
- Corner radius: 16pt cards, 12pt buttons
- Progress ring: 8pt thickness

## 🧪 Development Guidelines

### Code Style
- Use SwiftUI's declarative patterns
- Prefer `struct` over `class` when possible
- Leverage property wrappers: `@State`, `@ObservedObject`, `@Published`
- Keep views under 200 lines; extract subviews as needed
- Use `// MARK: -` for code organization

### Naming Conventions
- ViewModels: `*ViewModel`
- Services: `*Service` 
- Views: `*View`
- Use descriptive names: `startTimer()` not `start()`

### Error Handling
- Use `Result<Success, Error>` for service operations
- Implement proper error states in ViewModels
- Provide user-friendly error messages

## 📊 Success Criteria

- **Performance**: Timer accuracy within ±0.5 seconds over 60 minutes
- **Usability**: Set and start timer in under 5 seconds
- **Responsiveness**: App launch to ready state under 2 seconds
- **Cross-platform**: Identical functionality on iOS and macOS
- **Accessibility**: Full VoiceOver and Dynamic Type support

## 🔮 Future Enhancements (Post-V1)

- Multiple concurrent timers
- Named timers with presets
- Pomodoro technique support
- Siri Shortcuts integration
- Widgets for iOS/macOS
- Apple Watch companion
- iCloud sync across devices

## 🤝 Contributing

1. Follow the phase-based development approach
2. Create feature branches for each major component
3. Write unit tests for ViewModels and Services
4. Test on both iOS and macOS before committing
5. Update this roadmap as features are completed

---

**Last Updated**: December 2025  
**Project Status**: Ready for Development  
**Current Phase**: Phase 1 (Core Timer Functionality)
