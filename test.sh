#!/bin/bash

# CI/CD Test Script for MusicBud Flutter Project
# This script runs widget tests, integration tests, generates coverage reports,
# and builds for different platforms with appropriate exit codes.

set -e  # Exit on any error

echo "Starting CI/CD test suite..."

# Clean previous coverage and reports
rm -rf coverage/
rm -f test_report.json
rm -f junit_report.xml

# Function to run tests with reporting
run_tests() {
    local test_type=$1
    local test_path=$2
    local platform=$3

    echo "Running $test_type tests on $platform..."

    if [ "$platform" = "vm" ]; then
        flutter test $test_path --machine --coverage > test_report_$test_type.json
    else
        flutter test $test_path --platform=$platform --machine --coverage > test_report_$test_type.json
    fi

    echo "$test_type tests on $platform completed."
}

# Run widget tests on VM (default)
run_tests "widget" "" "vm"

# Run widget tests on Chrome (web platform)
run_tests "widget_web" "" "chrome"

# Run integration tests
echo "Running integration tests..."
flutter test integration_test/ --machine > integration_test_report.json

# Generate coverage report
echo "Generating coverage report..."
if [ -d "coverage/" ]; then
    # Convert LCOV to HTML if lcov is available
    if command -v genhtml >/dev/null 2>&1; then
        genhtml coverage/lcov.info -o coverage/html/
        echo "HTML coverage report generated at coverage/html/index.html"
    fi
    echo "LCOV coverage report available at coverage/lcov.info"
else
    echo "No coverage data generated"
fi

# Generate JUnit XML report from test reports (requires additional tooling)
# This is a placeholder - in CI/CD, you might use a tool like junitreport
echo "Test reports generated:"
echo "- Widget test report: test_report_widget.json"
echo "- Widget web test report: test_report_widget_web.json"
echo "- Integration test report: integration_test_report.json"

# Build for different platforms (as additional validation)
echo "Building for Android..."
flutter build apk --release

echo "Building for iOS..."
flutter build ios --release --no-codesign

echo "Building for Web..."
flutter build web --release

echo "Building for Linux..."
flutter build linux --release

echo "Building for macOS..."
flutter build macos --release

echo "Building for Windows..."
flutter build windows --release

echo "All tests and builds completed successfully!"