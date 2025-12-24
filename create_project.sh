#!/bin/bash

echo "Creating OKTimer Xcode Project..."

# Remove existing project files
rm -rf OKTimer.xcodeproj

# Create the project using xcodegen or manually
# For now, let's open Xcode and create it manually

echo "Please follow these steps to create the project:"
echo ""
echo "1. Open Xcode"
echo "2. Select 'Create a new Xcode project'"
echo "3. Choose 'Multiplatform' > 'App'"
echo "4. Fill in the details:"
echo "   - Product Name: OKTimer"
echo "   - Bundle Identifier: com.oktimer.OKTimer"
echo "   - Language: Swift"
echo "   - Interface: SwiftUI"
echo "   - Use Core Data: No"
echo "   - Include Tests: Yes (optional)"
echo "5. Choose this directory: $(pwd)"
echo "6. Click 'Create'"
echo ""
echo "After creating the project:"
echo "1. Delete the default ContentView.swift"
echo "2. Copy files from OKTimer_backup/ into the project"
echo "3. Add files to Xcode project by right-clicking and selecting 'Add Files'"

# Open Xcode
open -a Xcode
