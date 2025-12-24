#!/bin/bash

# OKTimer Setup Script
# This script helps set up the development environment for OK Timer

echo "🕐 OK Timer - Development Setup"
echo "================================"

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed or not in PATH"
    echo "Please install Xcode from the App Store first"
    exit 1
fi

# Check Xcode version
XCODE_VERSION=$(xcodebuild -version | head -n 1 | cut -d' ' -f2)
echo "✅ Found Xcode version: $XCODE_VERSION"

# Check if we're in the right directory
if [ ! -f "OKTimer.xcodeproj/project.pbxproj" ]; then
    echo "❌ Could not find OKTimer.xcodeproj"
    echo "Please run this script from the timer-app directory"
    exit 1
fi

echo "✅ Found OKTimer project"

# Test if the project builds
echo "🔨 Testing project build..."
if xcodebuild -project OKTimer.xcodeproj -scheme OKTimer -destination 'platform=macOS' build -quiet; then
    echo "✅ Project builds successfully!"
else
    echo "⚠️  Build test failed, but you can still open in Xcode to debug"
fi

# Open the project
echo "🚀 Opening OKTimer project in Xcode..."
if [ -f "OKTimer.xcworkspace/contents.xcworkspacedata" ]; then
    open OKTimer.xcworkspace
else
    open OKTimer.xcodeproj
fi

echo ""
echo "📋 Next Steps:"
echo "1. In Xcode, select your development team in the Signing & Capabilities tab"
echo "2. Choose your target device (iOS Simulator or Mac)"
echo "3. Press Cmd+R to build and run the app"
echo ""
echo "🏗️  Project Structure Ready:"
echo "   - iOS 15.0+ and macOS 12.0+ support"
echo "   - SwiftUI interface with basic timer display"
echo "   - Complete folder structure for development"
echo "   - Asset catalog and entitlements configured"
echo ""
echo "📖 Refer to the README.md for detailed development information"
echo "✨ Happy coding!"
