#!/usr/bin/env bash

# MusicBud Test Runner
# Fast test execution and debugging script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}   MusicBud Test Runner${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

# Function to run tests with timing
run_tests() {
    local test_path=$1
    local test_name=$2
    
    echo -e "${YELLOW}Running ${test_name}...${NC}"
    start_time=$(date +%s)
    
    if flutter test "$test_path" --reporter compact; then
        end_time=$(date +%s)
        duration=$((end_time - start_time))
        echo -e "${GREEN}✅ ${test_name} passed in ${duration}s${NC}"
        echo ""
        return 0
    else
        end_time=$(date +%s)
        duration=$((end_time - start_time))
        echo -e "${RED}❌ ${test_name} failed after ${duration}s${NC}"
        echo ""
        return 1
    fi
}

# Parse command line arguments
case "$1" in
    "all")
        echo "Running all tests..."
        run_tests "test/" "All Tests"
        ;;
    "auth")
        echo "Running Auth BLoC tests..."
        run_tests "test/blocs/auth/" "Auth BLoC"
        ;;
    "user")
        echo "Running User BLoC tests..."
        run_tests "test/blocs/user/" "User BLoC"
        ;;
    "api")
        echo "Running API tests..."
        run_tests "test/data/" "API Services"
        ;;
    "blocs")
        echo "Running all BLoC tests..."
        run_tests "test/blocs/" "All BLoCs"
        ;;
    "coverage")
        echo "Running tests with coverage..."
        flutter test --coverage
        echo -e "${GREEN}Coverage report generated at coverage/lcov.info${NC}"
        if command -v genhtml &> /dev/null; then
            echo "Generating HTML coverage report..."
            genhtml coverage/lcov.info -o coverage/html
            echo -e "${GREEN}HTML report generated at coverage/html/index.html${NC}"
        fi
        ;;
    "watch")
        echo "Running tests in watch mode..."
        flutter test --watch test/
        ;;
    "quick")
        echo "Running quick test suite..."
        echo ""
        
        # Run critical tests only
        run_tests "test/blocs/auth/auth_bloc_comprehensive_test.dart" "Auth BLoC"
        run_tests "test/data/network/api_service_test.dart" "API Service"
        
        echo -e "${GREEN}════════════════════════════════════════${NC}"
        echo -e "${GREEN}Quick test suite completed!${NC}"
        echo -e "${GREEN}════════════════════════════════════════${NC}"
        ;;
    "debug")
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Please specify test name${NC}"
            echo "Usage: ./run_tests.sh debug \"test name\""
            exit 1
        fi
        echo "Running test: $2"
        flutter test --verbose --name "$2"
        ;;
    "generate")
        echo "Generating mocks..."
        flutter pub run build_runner build --delete-conflicting-outputs
        echo -e "${GREEN}✅ Mocks generated successfully${NC}"
        ;;
    "clean")
        echo "Cleaning test artifacts..."
        rm -rf coverage/
        flutter clean
        flutter pub get
        echo -e "${GREEN}✅ Clean completed${NC}"
        ;;
    "help"|*)
        echo "Usage: ./run_tests.sh [command]"
        echo ""
        echo "Commands:"
        echo "  all       - Run all tests"
        echo "  auth      - Run Auth BLoC tests"
        echo "  user      - Run User BLoC tests"
        echo "  api       - Run API tests"
        echo "  blocs     - Run all BLoC tests"
        echo "  coverage  - Run tests with coverage report"
        echo "  watch     - Run tests in watch mode"
        echo "  quick     - Run critical tests only (fast)"
        echo "  debug     - Run specific test with verbose output"
        echo "  generate  - Generate mock files"
        echo "  clean     - Clean test artifacts"
        echo "  help      - Show this help message"
        echo ""
        echo "Examples:"
        echo "  ./run_tests.sh quick"
        echo "  ./run_tests.sh debug \"loads profile successfully\""
        echo "  ./run_tests.sh coverage"
        ;;
esac
