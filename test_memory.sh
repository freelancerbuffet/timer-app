#!/bin/bash

# Memory Management Test Script for OKTimer
# This script helps test the fullscreen alert memory management fixes

echo "🧪 OKTimer Memory Management Test"
echo "=================================="
echo ""

# Check if app is running
if pgrep -f "OKTimer.app" > /dev/null; then
    echo "✅ OKTimer is currently running"
else
    echo "❌ OKTimer is not running. Starting app..."
    cd /Users/lxps/Documents/GitHub/timer-app
    open /Users/lxps/Library/Developer/Xcode/DerivedData/OKTimer-*/Build/Products/Debug/OKTimer.app
    sleep 2
fi

echo ""
echo "📋 Test Instructions:"
echo "1. Set a timer for 5-10 seconds in OKTimer"
echo "2. Wait for the fullscreen alert to appear"
echo "3. Test both 'Dismiss' and 'Snooze' buttons"
echo "4. Repeat this process 5-10 times"
echo "5. Monitor for any crashes or memory issues"
echo ""
echo "🔍 Look for:"
echo "- No EXC_BAD_ACCESS crashes"
echo "- Smooth alert animations"
echo "- Proper window cleanup"
echo "- No memory leaks"
echo ""

# Monitor memory usage
echo "💾 Current memory usage:"
ps -o pid,rss,comm -p $(pgrep -f "OKTimer.app") 2>/dev/null || echo "App not found in process list"
echo ""

echo "🏃‍♂️ Test is ready. Please run the timer tests manually in the OKTimer app."
echo "Press any key when testing is complete..."
read -n 1 -s

echo ""
echo "📊 Final memory check:"
ps -o pid,rss,comm -p $(pgrep -f "OKTimer.app") 2>/dev/null || echo "App no longer running"

echo ""
echo "✨ Test completed. Check console for any crash logs if issues occurred."
