# OK TIMER - Product Requirements Document (PRD)

## Product Vision

OK TIMER is a beautifully minimalistic timer application for iOS and macOS that helps users stay focused and aware of their time. When the timer completes, it captures attention through delightful animations and gentle sound notifications, making time management both functional and enjoyable.

## Core Principles

- **Minimalistic**: Clean, uncluttered interface with essential features only
- **Translucent**: Modern glass-morphism design that feels lightweight and elegant
- **Classy**: Refined aesthetics with smooth animations and tasteful interactions
- **Useful**: Quick to set, easy to use, reliable in notification

## Target Platforms

- iOS 15.0+
- macOS 12.0+
- Built with Xcode 14+ and Swift 5.7+

---

## Features & Functionality

### 1. Timer Interface

**Primary Display**
- Large, readable countdown display (MM:SS format)
- Translucent background with subtle blur effect
- Minimal chrome, maximizing display area
- Support for both portrait and landscape orientations (iOS)

**Timer Controls**
- Time input with intuitive wheel/picker interface
  - Minutes: 0-99
  - Seconds: 0-59
- Quick preset buttons: 1min, 5min, 10min, 15min, 30min
- Start/Pause button (single, context-aware button)
- Reset button (appears when timer is running or paused)

**Visual Feedback**
- Progress ring that depletes as time counts down
- Color transition: Blue → Yellow → Orange → Red as time approaches zero
- Pulsing animation in final 10 seconds

### 2. Timer Completion Experience

**Animation**
- Gentle bounce animation that scales the display (1.0x → 1.2x → 1.0x)
- Confetti particle effect (subtle, not overwhelming)
- Screen pulse effect (3 pulses, subtle opacity change)
- Animation duration: ~3 seconds total

**Sound**
- Pleasant, non-jarring notification sound
- Options:
  - "Gentle Chime" (default) - soft bell sound
  - "Soft Ding" - minimal single tone
  - "Happy Bells" - uplifting two-tone chime
- Volume respects system settings
- Repeats 3 times with 1-second intervals
- Option to continue ringing until dismissed

**User Attention**
- Haptic feedback (iOS): Medium impact pattern, 3 pulses
- App badge notification (when in background)
- Local notification with custom sound
- Brings app to foreground if in background (on user permission)

### 3. Settings & Customization

**Appearance**
- Light/Dark mode (follows system or manual override)
- Translucency intensity adjustment (Low/Medium/High)
- Color theme selection:
  - Ocean Blue (default)
  - Forest Green
  - Sunset Orange
  - Monochrome

**Notification Options**
- Sound selection
- Vibration pattern (iOS)
- Notification repeat count (1-5 or continuous)
- Show notification in background toggle

**App Behavior**
- Keep screen awake while timer running (toggle)
- Start timer immediately after setting time (toggle)
- Show milliseconds in final 10 seconds (toggle)

---

## Design Specifications

### Color Palette

**Light Mode**
- Background: `rgba(255, 255, 255, 0.7)` with system blur
- Primary Text: `rgba(0, 0, 0, 0.9)`
- Secondary Text: `rgba(0, 0, 0, 0.6)`
- Accent (Blue): `#007AFF`
- Progress Ring: Gradient from `#007AFF` to `#FF3B30`

**Dark Mode**
- Background: `rgba(28, 28, 30, 0.8)` with system blur
- Primary Text: `rgba(255, 255, 255, 0.95)`
- Secondary Text: `rgba(255, 255, 255, 0.6)`
- Accent (Blue): `#0A84FF`
- Progress Ring: Gradient from `#0A84FF` to `#FF453A`

### Typography
- Timer Display: SF Pro Rounded, Weight: Semibold, Size: 72pt (iOS) / 96pt (macOS)
- Preset Buttons: SF Pro, Weight: Medium, Size: 17pt
- Settings Labels: SF Pro, Weight: Regular, Size: 15pt

### Spacing & Layout
- Edge padding: 24pt (iOS) / 32pt (macOS)
- Element spacing: 16pt standard, 24pt for major sections
- Corner radius: 16pt for cards, 12pt for buttons
- Progress ring thickness: 8pt

### Animations
- Standard duration: 0.3s with ease-in-out timing
- Spring animations for interactive elements (dampening: 0.7, response: 0.5)
- Completion animation: 3s total with custom bezier curves

---

## Technical Architecture

### Project Structure

```
OKTimer/
├── App/
│   ├── OKTimerApp.swift          # App entry point
│   └── ContentView.swift          # Main container view
├── Views/
│   ├── TimerDisplayView.swift    # Main timer display
│   ├── TimerControlsView.swift   # Start/pause/reset buttons
│   ├── TimePickerView.swift      # Time input interface
│   ├── PresetButtonsView.swift   # Quick preset buttons
│   ├── SettingsView.swift        # Settings screen
│   └── CompletionAnimationView.swift # Completion animation overlay
├── ViewModels/
│   ├── TimerViewModel.swift      # Timer logic and state
│   └── SettingsViewModel.swift   # Settings management
├── Models/
│   ├── TimerState.swift          # Timer state enum
│   ├── TimerSettings.swift       # User preferences model
│   └── SoundOption.swift         # Sound selection enum
├── Services/
│   ├── TimerService.swift        # Core timer functionality
│   ├── SoundService.swift        # Sound playback management
│   ├── HapticService.swift       # Haptic feedback (iOS)
│   └── NotificationService.swift # Local notifications
├── Utilities/
│   ├── ColorTheme.swift          # Theme color definitions
│   ├── AnimationPresets.swift    # Reusable animations
│   └── Extensions/
│       ├── View+Extensions.swift
│       └── Color+Extensions.swift
└── Resources/
    ├── Sounds/
    │   ├── gentle-chime.wav
    │   ├── soft-ding.wav
    │   └── happy-bells.wav
    └── Assets.xcassets/
```

### Key Classes & Responsibilities

**TimerViewModel**
- Manages timer state (idle, running, paused, completed)
- Handles countdown logic using Combine framework
- Publishes UI updates via `@Published` properties
- Coordinates with services for sound, haptics, notifications

**TimerService**
- Pure timer logic implementation
- Uses `Timer.publish()` for precise countdown
- Calculates remaining time and progress percentage
- Thread-safe timer operations

**SoundService**
- Manages `AVAudioPlayer` instances
- Preloads sound files for instant playback
- Handles volume and repeat logic
- Respects system audio settings

**NotificationService**
- Requests user permission for notifications
- Schedules local notifications when timer completes
- Creates notification content with custom sound
- Handles notification actions (dismiss, restart)

### State Management

**TimerState Enum**
```swift
enum TimerState {
    case idle           // No timer set
    case running        // Timer counting down
    case paused         // Timer paused
    case completed      // Timer reached zero
}
```

**Data Flow**
- SwiftUI with MVVM architecture
- Combine framework for reactive updates
- UserDefaults for settings persistence
- No external dependencies required

### Performance Considerations

- Timer updates at 10 Hz (0.1s intervals) for smooth UI
- Animations use `withAnimation()` for 60fps performance
- Lazy loading of sound assets
- Efficient particle system for confetti (max 50 particles)
- Background task handling for timer completion

---

## User Experience Flow

### First Launch
1. App opens to timer interface in idle state
2. Optional: Brief tooltip showing tap to set time
3. Clean slate, ready to use immediately

### Setting a Timer
1. User taps on time display OR taps preset button
2. Time picker appears with smooth animation
3. User selects minutes and seconds
4. Taps "Start" or picker auto-confirms after 1s of no interaction
5. Timer begins countdown immediately

### Timer Running
1. Large countdown display with progress ring
2. Pause button visible and easily accessible
3. Reset button available (with confirmation for long timers)
4. User can leave app; timer continues in background
5. Screen stays awake (if setting enabled)

### Timer Completion
1. Animation begins: bounce + confetti
2. Sound plays (3 repetitions)
3. Haptic feedback pulses (iOS)
4. If in background: notification appears
5. User taps anywhere to dismiss or "Restart" button to go again

### Settings Access
1. Settings icon in top-right corner (SF Symbol: gear)
2. Sheet presentation with grouped settings
3. Changes apply immediately (except sound preview)
4. "Done" button dismisses settings

---

## Implementation Guidelines

### Phase 1: Core Timer (MVP)
- [ ] Basic UI layout with timer display
- [ ] Time picker implementation
- [ ] Timer countdown logic
- [ ] Start/pause/reset functionality
- [ ] Simple completion alert

### Phase 2: Visual Polish
- [ ] Translucent background with blur
- [ ] Progress ring with color gradient
- [ ] Smooth animations for state changes
- [ ] Preset buttons
- [ ] Dark mode support

### Phase 3: Completion Experience
- [ ] Completion animation (bounce + confetti)
- [ ] Sound service integration
- [ ] Haptic feedback (iOS)
- [ ] Background notification support

### Phase 4: Settings & Customization
- [ ] Settings screen
- [ ] Theme selection
- [ ] Sound options
- [ ] App behavior preferences
- [ ] Persistence with UserDefaults

### Phase 5: Polish & Optimization
- [ ] App icon and branding
- [ ] macOS-specific optimizations
- [ ] Accessibility features (VoiceOver, Dynamic Type)
- [ ] Performance optimization
- [ ] App Store assets preparation

---

## Code Style Guidelines

### Swift Best Practices
- Use Swift's native types and standard library
- Leverage SwiftUI's declarative syntax
- Prefer value types (struct) over reference types (class) when appropriate
- Use property wrappers: `@State`, `@Binding`, `@ObservedObject`, `@Published`
- Implement proper error handling with `Result` or `throws`

### Naming Conventions
- ViewModels: `*ViewModel`
- Services: `*Service`
- Views: `*View`
- Use clear, descriptive names: `startTimer()` not `start()`
- Constants: `private let defaultTimerDuration = 300`

### Code Organization
- One primary component per file
- Group related extensions together
- Use `// MARK: -` for section organization
- Keep view files under 200 lines; extract subviews as needed

### Comments
- Document public APIs with `///` doc comments
- Explain "why" not "what" in regular comments
- Complex algorithms deserve explanation
- No commented-out code in final version

---

## Testing Strategy

### Unit Tests
- Timer calculation logic
- State transitions
- Time formatting functions
- Settings persistence

### UI Tests
- Timer start/pause/reset flow
- Time picker interaction
- Settings navigation
- Completion behavior

### Manual Testing Checklist
- [ ] Timer accuracy over 30 minutes
- [ ] Background behavior (app minimized)
- [ ] Notification delivery
- [ ] Sound playback at various volumes
- [ ] Orientation changes (iOS)
- [ ] Dark mode appearance
- [ ] Accessibility with VoiceOver
- [ ] Performance with multiple timer completions

---

## Accessibility

- Support Dynamic Type (text scales with system settings)
- VoiceOver labels for all interactive elements
- High contrast mode support
- Reduce motion option (disable confetti/bounce)
- Ensure 4.5:1 minimum contrast ratio for text
- Keyboard navigation support (macOS)
- Minimum touch target: 44x44 points

---

## Future Enhancements (Post-V1)

- Multiple concurrent timers
- Named timers (e.g., "Tea", "Meeting", "Exercise")
- Timer history and statistics
- Pomodoro mode (work/break intervals)
- Siri shortcuts integration
- Widget support (iOS/macOS)
- iCloud sync across devices
- Custom sounds import
- Focus mode integration
- Apple Watch companion app

---

## Success Metrics

- **Usability**: User can set and start timer in < 5 seconds
- **Reliability**: Timer accuracy within ±0.5 seconds over 60 minutes
- **Performance**: App launch to ready state < 2 seconds
- **Delight**: 90%+ of users keep default notification sound (indicates quality)
- **Engagement**: Users open app at least 3 times per week

---

## Development Timeline Estimate

- **Week 1**: Core timer functionality (Phase 1)
- **Week 2**: Visual design implementation (Phase 2)
- **Week 3**: Completion experience (Phase 3)
- **Week 4**: Settings & customization (Phase 4)
- **Week 5**: Polish, testing, optimization (Phase 5)

---

## Getting Started

### Prerequisites
- Xcode 14.0 or later
- macOS 12.0 or later for development
- Apple Developer account (for device testing and distribution)

### Setup Instructions
1. Clone this repository
2. Open `OKTimer.xcodeproj` in Xcode
3. Select your development team in Signing & Capabilities
4. Build and run on simulator or device
5. Refer to inline code documentation for component details

### Building
```bash
# Build for iOS simulator
xcodebuild -scheme OKTimer -destination 'platform=iOS Simulator,name=iPhone 14' build

# Build for macOS
xcodebuild -scheme OKTimer -destination 'platform=macOS' build

# Run tests
xcodebuild test -scheme OKTimer
```

---

## License

See LICENSE file for details.

---

## Contact & Support

For questions or suggestions about this PRD or the implementation, please open an issue in the GitHub repository.

---

*Last Updated: December 2025*
*PRD Version: 1.0*
