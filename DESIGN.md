# OK TIMER - Phase 1 UI Design Documentation

## Visual Design Overview

The OK TIMER app now features a beautiful, minimalist design with the following visual hierarchy:

### Layout Structure (Top to Bottom)

```
┌─────────────────────────────────────────────┐
│                                             │
│              OK TIMER                       │  ← Subtle header (light font)
│                                             │
│                                             │
│            ┌─────────────┐                  │
│         ╱                  ╲                │
│       │                      │              │
│      │    ┏━━━━━━━━━━━┓     │             │  ← Progress Ring
│      │    ┃   05:00   ┃     │             │  ← Timer Display
│      │    ┗━━━━━━━━━━━┛     │             │    (tap to edit)
│       │                      │              │
│         ╲                  ╱                │
│            └─────────────┘                  │
│                                             │
│                                             │
│    [1m] [5m] [10m] [15m] [30m]            │  ← Preset Buttons
│                                             │
│        ┏━━━━━━━┓  ┌─────────┐             │  ← Control Buttons
│        ┃ Start ┃  │  Reset  │             │    (Start/Pause + Reset)
│        ┗━━━━━━━┛  └─────────┘             │
│                                             │
└─────────────────────────────────────────────┘
```

## Color Scheme & Styling

### Progress Ring Gradients
- **0-33% Progress**: Blue (#007AFF) → Cyan
- **33-66% Progress**: Cyan → Orange
- **66-100% Progress**: Orange → Red

### Backgrounds
- **iOS**: Ultra-thin material blur (full screen, no border radius)
- **macOS**: Ultra-thin material blur (20pt border radius for window chrome)

### Typography
- **Header**: 28pt, Light weight, Rounded design, 60% opacity
- **Timer Display**: 72pt (iOS) / 96pt (macOS), Semibold, Rounded, Monospaced
- **Preset Buttons**: 15pt, Medium weight, Rounded
- **Control Buttons**: 17pt, Semibold/Medium, Rounded

### Button Styles

#### Primary Button (Start/Pause/Resume)
- Gradient background: Blue → Cyan
- White text
- 12pt corner radius
- Press animation: 96% scale
- Minimum width: 120pt

#### Secondary Button (Reset)
- Light fill: 8% primary color opacity
- 70% opacity text
- 12pt corner radius
- Press animation: 96% scale
- Minimum width: 100pt

#### Preset Buttons
- Light fill: 8% primary color opacity
- 70% opacity text (30% when disabled)
- 10pt corner radius
- Minimum size: 44x36pt

## State-Based Visual Feedback

### Timer States

1. **Idle State**
   - Timer display: 60% opacity
   - Progress ring: 30% opacity
   - Shows "tap to edit" hint below timer
   - Preset buttons: enabled
   - Primary button: "Start"

2. **Running State**
   - Timer display: 100% opacity, primary color
   - Progress ring: 100% opacity with gradient
   - Smooth progress animation
   - Preset buttons: disabled
   - Primary button: "Pause"
   - Reset button: visible

3. **Paused State**
   - Timer display: 100% opacity, orange color
   - Progress ring: 100% opacity, current progress
   - Preset buttons: disabled
   - Primary button: "Resume"
   - Reset button: visible

4. **Completed State**
   - Timer display: 100% opacity, green color
   - Shows "00:00"
   - Progress ring: 100% complete
   - Primary button: "Done!" (disabled)
   - Reset button: visible

## Interactive Features

### Tap-to-Edit Timer
- Tap the timer display when in idle state
- Smooth transition to wheel pickers for minutes and seconds
- Tap again to confirm and return to timer display
- Automatically hides picker when timer starts

### Smooth Animations
- All state transitions: 0.3s ease-in-out
- Button presses: 0.15s ease-in-out
- Progress ring updates: 0.3s ease-in-out
- Scale effects on buttons: 95-96% on press
- Opacity fades for state changes

### Preset Buttons
- One-tap to set common timer durations
- Automatically disabled when timer is running/paused
- Visual feedback on press with scale animation

## Cross-Platform Adaptations

### iOS Specific
- Full-screen layout (no border radius on background)
- Smaller timer font (72pt)
- Smaller progress ring (280pt diameter)
- Touch-optimized button sizes (min 44pt)

### macOS Specific
- Windowed layout with rounded corners (20pt radius)
- Larger timer font (96pt)
- Larger progress ring (340pt diameter)
- Mouse-optimized button interactions

## Accessibility Features
- Monospaced digits for consistent timer display
- High contrast between text and backgrounds
- Clear visual state indicators
- Large touch targets (minimum 44x44pt)
- Support for Light and Dark mode
- Smooth, non-jarring animations

## Performance Characteristics
- Timer updates every 0.1 seconds for smooth progress
- Efficient Combine-based reactive updates
- No unnecessary view re-renders
- Smooth 60fps animations
- Low battery impact with optimized timer implementation

---

**Design Philosophy**: Simple, elegant, minimalist — letting the timer be the hero while providing all necessary controls in an unobtrusive, beautiful interface.
