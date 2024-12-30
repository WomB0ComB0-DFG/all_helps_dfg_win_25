#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DIST_FOLDER="distribution"
DATE_STAMP=$(date +%Y%m%d_%H%M%S)
BUILD_FOLDER="${DIST_FOLDER}/${DATE_STAMP}"

# Create distribution folder
echo -e "${BLUE}Creating distribution folder...${NC}"
mkdir -p "$BUILD_FOLDER"

# Function to handle errors
handle_error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# Build Android APK
build_android() {
    echo -e "${BLUE}Building Android APK...${NC}"
    flutter build apk --release || handle_error "Android build failed"
    
    # Copy APK to distribution folder
    cp build/app/outputs/flutter-apk/app-release.apk "${BUILD_FOLDER}/app-release.apk"
    echo -e "${GREEN}Android APK built successfully!${NC}"
}

# Build iOS
build_ios() {
    echo -e "${BLUE}Building iOS...${NC}"
    flutter build ios --release --no-codesign || handle_error "iOS build failed"
    echo -e "${GREEN}iOS build completed!${NC}"
    echo -e "${BLUE}Note: For iOS distribution, please use Xcode to create an archive and upload to TestFlight${NC}"
}

# Main execution
echo "🚀 Starting app distribution process..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    handle_error "Flutter is not installed"
fi

# Build Android
build_android

# Check if running on macOS for iOS build
if [[ "$OSTYPE" == "darwin"* ]]; then
    build_ios
else
    echo -e "${BLUE}Skipping iOS build (not on macOS)${NC}"
fi

# Print results
echo -e "\n${GREEN}Build completed successfully!${NC}"
echo -e "Distribution files are located in: ${BUILD_FOLDER}"
echo -e "\nAndroid APK: ${BUILD_FOLDER}/app-release.apk"