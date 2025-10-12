#!/usr/bin/env bash

# MusicBud Flutter Development Helper Script
# This script provides convenient commands for common development tasks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if we're in nix-shell
check_nix_shell() {
    if [ -z "$IN_NIX_SHELL" ]; then
        print_warning "Not in nix-shell environment. Some commands may fail."
        return 1
    fi
    return 0
}

# Function to run Flutter command with proper environment
run_flutter() {
    cd "$PROJECT_ROOT"
    export LD_LIBRARY_PATH="/nix/store/ga9ismvvkc7vhz4dnk51ws2472di7708-fontconfig-2.17.1-lib/lib:/nix/store/gj3zjsggvvj16g5vi2iyf00pfzgwqglh-libepoxy-1.5.10/lib:$LD_LIBRARY_PATH"
    
    if check_nix_shell; then
        flutter "$@"
    else
        print_status "Starting nix-shell environment..."
        nix-shell -p libsecret pkg-config sysprof glib gtk3 xorg.libX11 --run "flutter $*"
    fi
}

# Function to show help
show_help() {
    cat << EOF
MusicBud Flutter Development Helper

USAGE:
    $0 <command> [options]

COMMANDS:
    run         Run the app on Linux (debug mode)
    build       Build the app for Linux
    clean       Clean build artifacts and get dependencies
    test        Run all tests
    analyze     Run static code analysis
    format      Format code according to Dart style
    deps        Get/update dependencies
    doctor      Check Flutter installation and dependencies
    logs        Show recent app logs
    kill        Kill all running Flutter processes
    help        Show this help message

EXAMPLES:
    $0 run              # Run the app
    $0 build            # Build for Linux
    $0 clean            # Clean and get deps
    $0 test             # Run tests
    $0 analyze          # Check code quality

EOF
}

# Function to run the app
run_app() {
    print_status "Starting MusicBud Flutter app on Linux..."
    run_flutter run -d linux --debug
}

# Function to build the app
build_app() {
    print_status "Building MusicBud Flutter app for Linux..."
    run_flutter build linux --debug
    
    if [ -f "$PROJECT_ROOT/build/linux/x64/debug/bundle/musicbud_flutter" ]; then
        print_success "Build completed successfully!"
        print_status "Executable: build/linux/x64/debug/bundle/musicbud_flutter"
    else
        print_error "Build failed or executable not found"
        exit 1
    fi
}

# Function to clean and get dependencies
clean_project() {
    print_status "Cleaning project and getting dependencies..."
    cd "$PROJECT_ROOT"
    
    run_flutter clean
    run_flutter pub get
    
    print_success "Project cleaned and dependencies updated"
}

# Function to run tests
run_tests() {
    print_status "Running tests..."
    run_flutter test
}

# Function to run static analysis
run_analysis() {
    print_status "Running static code analysis..."
    run_flutter analyze
}

# Function to format code
format_code() {
    print_status "Formatting code..."
    run_flutter format lib/ test/
    print_success "Code formatted"
}

# Function to update dependencies
update_deps() {
    print_status "Getting/updating dependencies..."
    run_flutter pub get
    print_success "Dependencies updated"
}

# Function to check Flutter doctor
check_doctor() {
    print_status "Checking Flutter installation..."
    run_flutter doctor -v
}

# Function to show recent logs
show_logs() {
    print_status "Recent Flutter logs:"
    if command -v journalctl &> /dev/null; then
        journalctl --user -u flutter --since "10 minutes ago" || echo "No systemd logs found"
    fi
    
    # Also check for any log files
    if [ -d "$HOME/.flutter-logs" ]; then
        ls -la "$HOME/.flutter-logs/"
    fi
}

# Function to kill Flutter processes
kill_flutter() {
    print_status "Killing Flutter processes..."
    pkill -f "flutter" || print_warning "No Flutter processes found"
    pkill -f "musicbud_flutter" || print_warning "No MusicBud processes found"
    print_success "Flutter processes terminated"
}

# Main command handling
case "${1:-help}" in
    run)
        run_app
        ;;
    build)
        build_app
        ;;
    clean)
        clean_project
        ;;
    test)
        run_tests
        ;;
    analyze)
        run_analysis
        ;;
    format)
        format_code
        ;;
    deps)
        update_deps
        ;;
    doctor)
        check_doctor
        ;;
    logs)
        show_logs
        ;;
    kill)
        kill_flutter
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo
        show_help
        exit 1
        ;;
esac