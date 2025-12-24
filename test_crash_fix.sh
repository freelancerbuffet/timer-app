#!/bin/bash

echo "OKTimer Memory Crash Fix - Testing Script"
echo "========================================"
echo ""
echo "This script will help test the fullscreen alert dismiss fix."
echo ""
echo "Instructions:"
echo "1. Launch the OKTimer app (already launched)"
echo "2. Set a timer for 10 seconds"
echo "3. Wait for the fullscreen alert to appear"
echo "4. Click 'Dismiss' button multiple times quickly"
echo "5. Check if the app crashes"
echo ""
echo "Expected behavior: App should NOT crash when dismissing the alert"
echo ""
echo "Monitor crash logs with:"
echo "tail -f ~/Library/Logs/DiagnosticReports/OKTimer-*.ips"
echo ""
echo "Press Enter to continue monitoring logs..."
read

# Monitor for new crash reports
echo "Monitoring for crashes (Ctrl+C to stop)..."
while true; do
    latest_crash=$(ls -t ~/Library/Logs/DiagnosticReports/OKTimer-*.ips 2>/dev/null | head -1)
    if [[ -n $latest_crash ]]; then
        creation_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$latest_crash")
        current_time=$(date "+%Y-%m-%d %H:%M:%S")
        if [[ "$creation_time" > "$(date -v-10S "+%Y-%m-%d %H:%M:%S")" ]]; then
            echo "NEW CRASH DETECTED: $latest_crash"
            echo "Crash occurred at: $creation_time"
            break
        fi
    fi
    sleep 2
done
