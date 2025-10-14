#!/usr/bin/env bash

# Flutter Test Runner Script
# Usage: ./scripts/run_tests.sh [OPTIONS]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
RUN_UNIT=false
RUN_WIDGET=false
RUN_INTEGRATION=false
RUN_ALL=false
WITH_COVERAGE=false
VERBOSE=false
CLEAN_FIRST=false

# Help message
show_help() {
    cat << EOF
Flutter Test Runner Script

Usage: ./scripts/run_tests.sh [OPTIONS]

Options:
    -u, --unit              Run unit tests (BLoC, services, data)
    -w, --widget            Run widget tests
    -i, --integration       Run integration tests
    -a, --all               Run all test types
    -c, --coverage          Generate coverage report
    -v, --verbose           Verbose output
    --clean                 Clean before running tests
    -h, --help              Show this help message

Examples:
    ./scripts/run_tests.sh --unit --coverage
    ./scripts/run_tests.sh --all --clean
    ./scripts/run_tests.sh -u -w -c
    ./scripts/run_tests.sh --integration

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--unit)
            RUN_UNIT=true
            shift
            ;;
        -w|--widget)
            RUN_WIDGET=true
            shift
            ;;
        -i|--integration)
            RUN_INTEGRATION=true
            shift
            ;;
        -a|--all)
            RUN_ALL=true
            RUN_UNIT=true
            RUN_WIDGET=true
            RUN_INTEGRATION=true
            shift
            ;;
        -c|--coverage)
            WITH_COVERAGE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --clean)
            CLEAN_FIRST=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# If no test type specified, run all
if [ "$RUN_UNIT" = false ] && [ "$RUN_WIDGET" = false ] && [ "$RUN_INTEGRATION" = false ]; then
    echo -e "${YELLOW}No test type specified, running all tests...${NC}"
    RUN_ALL=true
    RUN_UNIT=true
    RUN_WIDGET=true
    RUN_INTEGRATION=true
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Flutter Test Runner - MusicBud      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

START_TIME=$(date +%s)

# Clean if requested
if [ "$CLEAN_FIRST" = true ]; then
    echo -e "${YELLOW}🧹 Cleaning build artifacts...${NC}"
    flutter clean
    flutter pub get
    echo -e "${GREEN}✓ Clean complete${NC}"
    echo ""
fi

# Generate mocks
echo -e "${YELLOW}🔧 Generating mocks...${NC}"
flutter pub run build_runner build --delete-conflicting-outputs > /dev/null 2>&1 || true
echo -e "${GREEN}✓ Mocks generated${NC}"
echo ""

# Coverage flag
COVERAGE_FLAG=""
if [ "$WITH_COVERAGE" = true ]; then
    COVERAGE_FLAG="--coverage"
fi

# Verbose flag
REPORTER_FLAG="--reporter compact"
if [ "$VERBOSE" = true ]; then
    REPORTER_FLAG="--reporter expanded"
fi

TOTAL_PASSED=0
TOTAL_FAILED=0
FAILED_SUITES=()

# Run unit tests
if [ "$RUN_UNIT" = true ]; then
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}📦 Running Unit Tests${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    
    if flutter test $COVERAGE_FLAG $REPORTER_FLAG test/blocs/ test/services/ test/data/ 2>&1; then
        echo -e "${GREEN}✓ Unit tests passed${NC}"
        ((TOTAL_PASSED++))
    else
        echo -e "${RED}✗ Unit tests failed${NC}"
        ((TOTAL_FAILED++))
        FAILED_SUITES+=("Unit Tests")
    fi
    echo ""
fi

# Run widget tests
if [ "$RUN_WIDGET" = true ]; then
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}🎨 Running Widget Tests${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    
    if [ -d "test/widgets" ] && [ "$(ls -A test/widgets 2>/dev/null)" ]; then
        if flutter test $COVERAGE_FLAG $REPORTER_FLAG test/widgets/ 2>&1; then
            echo -e "${GREEN}✓ Widget tests passed${NC}"
            ((TOTAL_PASSED++))
        else
            echo -e "${RED}✗ Widget tests failed${NC}"
            ((TOTAL_FAILED++))
            FAILED_SUITES+=("Widget Tests")
        fi
    else
        echo -e "${YELLOW}⚠ No widget tests found${NC}"
    fi
    echo ""
fi

# Run integration tests
if [ "$RUN_INTEGRATION" = true ]; then
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}🔗 Running Integration Tests${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    
    if [ -d "integration_test" ] && [ "$(ls -A integration_test/*.dart 2>/dev/null)" ]; then
        if flutter test $REPORTER_FLAG integration_test/ 2>&1; then
            echo -e "${GREEN}✓ Integration tests passed${NC}"
            ((TOTAL_PASSED++))
        else
            echo -e "${RED}✗ Integration tests failed${NC}"
            ((TOTAL_FAILED++))
            FAILED_SUITES+=("Integration Tests")
        fi
    else
        echo -e "${YELLOW}⚠ No integration tests found${NC}"
    fi
    echo ""
fi

# Generate coverage report
if [ "$WITH_COVERAGE" = true ]; then
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}📊 Generating Coverage Report${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    
    if [ -f "coverage/lcov.info" ]; then
        # Generate HTML report
        if command -v genhtml &> /dev/null; then
            genhtml coverage/lcov.info -o coverage/html --quiet
            echo -e "${GREEN}✓ HTML coverage report generated at coverage/html/index.html${NC}"
        else
            echo -e "${YELLOW}⚠ genhtml not found, skipping HTML report generation${NC}"
            echo -e "${YELLOW}  Install lcov: sudo apt-get install lcov (Linux) or brew install lcov (macOS)${NC}"
        fi
        
        # Calculate coverage percentage
        if command -v lcov &> /dev/null; then
            COVERAGE_SUMMARY=$(lcov --summary coverage/lcov.info 2>&1)
            COVERAGE_PERCENT=$(echo "$COVERAGE_SUMMARY" | grep "lines" | awk '{print $2}')
            echo -e "${BLUE}📈 Coverage: $COVERAGE_PERCENT${NC}"
            
            # Check threshold
            COVERAGE_NUM=$(echo "$COVERAGE_PERCENT" | sed 's/%//' | cut -d'.' -f1)
            if [ "$COVERAGE_NUM" -ge 60 ]; then
                echo -e "${GREEN}✓ Coverage meets 60% threshold${NC}"
            else
                echo -e "${YELLOW}⚠ Coverage below 60% threshold ($COVERAGE_NUM%)${NC}"
            fi
        fi
    else
        echo -e "${RED}✗ No coverage data found${NC}"
    fi
    echo ""
fi

# Summary
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}📝 Test Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "Passed: ${GREEN}$TOTAL_PASSED${NC}"
echo -e "Failed: ${RED}$TOTAL_FAILED${NC}"
echo -e "Duration: ${DURATION}s"

if [ ${#FAILED_SUITES[@]} -gt 0 ]; then
    echo -e "\n${RED}Failed test suites:${NC}"
    for suite in "${FAILED_SUITES[@]}"; do
        echo -e "  ${RED}✗ $suite${NC}"
    done
fi

echo -e "${BLUE}════════════════════════════════════════${NC}"

# Exit with error if any tests failed
if [ $TOTAL_FAILED -gt 0 ]; then
    echo -e "${RED}❌ Some tests failed!${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
fi
