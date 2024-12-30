#!/bin/bash

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt; then
            echo "debian"
        elif command_exists pacman; then
            echo "arch"
        elif command_exists paru; then
            echo "arch-paru"
        else
            echo "unknown-linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to install package manager if needed (for macOS)
install_brew() {
    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

# Function to install package manager if needed (for Windows)
install_choco() {
    if ! command_exists choco; then
        log_info "Installing Chocolatey..."
        powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    fi
}

# Function to install Flutter and Dart
install_flutter_dart() {
    local os=$1
    case $os in
        "debian")
            log_info "Installing Flutter and Dart on Debian/Ubuntu..."
            sudo apt update
            sudo apt install -y curl git unzip xz-utils zip libglu1-mesa
            git clone https://github.com/flutter/flutter.git ~/flutter
            export PATH="$PATH:$HOME/flutter/bin"
            ;;
        "arch"|"arch-paru")
            local installer=$([ "$os" == "arch-paru" ] && echo "paru" || echo "pacman")
            log_info "Installing Flutter and Dart on Arch Linux..."
            sudo $installer -Sy flutter dart --noconfirm
            ;;
        "macos")
            log_info "Installing Flutter and Dart on macOS..."
            install_brew
            brew install --cask flutter
            ;;
        "windows")
            log_info "Installing Flutter and Dart on Windows..."
            install_choco
            choco install flutter dart-sdk -y
            ;;
        *)
            log_error "Unsupported operating system"
            exit 1
            ;;
    esac
}

# Function to install Dart Frog CLI
install_dart_frog() {
    log_info "Installing Dart Frog CLI..."
    dart pub global activate dart_frog_cli
}

# Function to check if make is installed
check_make() {
    if ! command_exists make; then
        local os=$(detect_os)
        log_warning "Make not found. Installing..."
        case $os in
            "debian")
                sudo apt update && sudo apt install -y make
                ;;
            "arch"|"arch-paru")
                local installer=$([ "$os" == "arch-paru" ] && echo "paru" || echo "pacman")
                sudo $installer -Sy make --noconfirm
                ;;
            "macos")
                install_brew
                brew install make
                ;;
            "windows")
                install_choco
                choco install make -y
                ;;
        esac
    fi
}

# Modified start_backend function to use Makefile
start_backend() {
    log_info "Starting Dart Frog backend server..."
    cd backend || exit 1
    
    # Check if Makefile exists
    if [ ! -f "Makefile" ]; then
        log_error "Makefile not found in backend directory"
        exit 1
    fi

    # Run make commands
    make requirements || exit 1
    make install || exit 1
    make dev &
    BACKEND_PID=$!
    cd ..
    log_success "Backend server started using Makefile"
}

# Modified check_dependencies function
check_dependencies() {
    local os=$(detect_os)
    log_info "Detected OS: $os"

    # Check make
    check_make

    # Check Flutter and Dart
    if ! command_exists flutter || ! command_exists dart; then
        log_warning "Flutter and/or Dart not found. Installing..."
        install_flutter_dart "$os"
    fi

    # Check Dart Frog CLI
    if ! command_exists dart_frog; then
        log_warning "Dart Frog CLI not found. Installing..."
        install_dart_frog
    fi
}

# Modified cleanup function to use Makefile
cleanup() {
    log_info "Shutting down servers..."
    
    # Stop backend using Makefile if possible
    if [ -f "backend/Makefile" ]; then
        cd backend
        make docker/stop 2>/dev/null || true
        cd ..
    elif [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
    fi

    # Stop frontend
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
    fi
    
    log_success "Servers stopped"
    exit 0
}

# Modified main function to check Makefile
main() {
    # Set up trap for cleanup
    trap cleanup SIGINT SIGTERM

    # Print welcome message
    log_info "Starting development environment..."

    # Check and install dependencies
    check_dependencies

    # Ensure both directories exist
    if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
        log_error "Missing backend or frontend directory"
        exit 1
    fi

    # Check for backend Makefile
    if [ ! -f "backend/Makefile" ]; then
        log_error "Makefile not found in backend directory"
        exit 1
    fi

    # Start servers
    start_backend
    start_frontend

    # Keep script running
    log_success "Development environment is ready!"
    log_info "Access the frontend at: http://localhost:3000"
    log_info "Access the backend at: http://localhost:8080"
    log_info "Press Ctrl+C to stop all servers"
    log_info "Backend is managed by Makefile - see backend/Makefile for more commands"
    
    # Wait for user interrupt
    wait
}

# Run main function
main

