#!/bin/sh
set -e

# Xcode Cloud CI Post-Clone Script
# GridPulse F1 Tracker

echo "=== GridPulse CI Post-Clone ==="

# Install SwiftLint
if ! command -v swiftlint &> /dev/null; then
    echo "Installing SwiftLint..."
    brew install swiftlint
fi

# Install SwiftFormat
if ! command -v swiftformat &> /dev/null; then
    echo "Installing SwiftFormat..."
    brew install swiftformat
fi

# Run SwiftLint
echo "Running SwiftLint..."
swiftlint lint --quiet --reporter emoji

# Run SwiftFormat (lint mode only — don't modify files in CI)
echo "Running SwiftFormat check..."
swiftformat --lint .

echo "=== CI Post-Clone Complete ==="