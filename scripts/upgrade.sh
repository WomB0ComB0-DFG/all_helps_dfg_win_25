#!/bin/bash

# Function to extract package versions from flutter pub outdated
get_latest_versions() {
    flutter pub outdated | grep -v "Package Name" | grep -v "dependencies:" | grep -v "^$" | while read -r line
    do
        # Skip the header line with dashes
        if [[ $line == *"Current"* ]]; then
            continue
        fi

        # Extract package name and latest version
        package=$(echo "$line" | awk '{print $1}')
        latest=$(echo "$line" | awk '{print $NF}')

        # Skip if package or latest version is empty
        if [ -z "$package" ] || [ -z "$latest" ]; then
            continue
        fi

        # Update pubspec.yaml
        if grep -q "^  $package:" "pubspec.yaml"; then
            sed -i "s/^  $package:.*$/  $package: ^$latest/" pubspec.yaml
        elif grep -q "^  flutter_lints:" "pubspec.yaml" && [ "$package" = "flutter_lints" ]; then
            sed -i "s/^  flutter_lints:.*$/  flutter_lints: ^$latest/" pubspec.yaml
        fi
    done
}

echo "🔍 Checking for outdated packages..."
get_latest_versions

echo "♻️ Running flutter pub get..."
flutter pub get

echo "✨ Dependencies updated successfully!"