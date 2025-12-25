#!/bin/bash

echo "🧪 Testing macOS Focus Feature for OKTimer"
echo "==========================================="

echo "1. Building the app..."
xcodebuild -project OKTimer.xcodeproj -scheme OKTimer -configuration Debug build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "🧪 Manual Testing Instructions:"
    echo "1. Launch the app"
    echo "2. Set a timer (e.g., 30 seconds)"
    echo "3. Start the timer"
    echo "4. Click on another application to make OKTimer lose focus"
    echo "5. You should see a beautiful radial progress indicator overlay"
    echo "6. Click back on OKTimer - the overlay should disappear"
    echo ""
    echo "Expected behavior:"
    echo "- When timer is running and app loses focus: radial progress shows"
    echo "- When timer is not running: no overlay"
    echo "- When app regains focus: overlay disappears with animation"
else
    echo "❌ Build failed! Check the errors above."
fi
