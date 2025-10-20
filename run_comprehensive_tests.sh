#!/bin/bash

# Comprehensive Test Runner for MusicBud Flutter
# Run all tests and generate reports

set -e

echo "🧪 MusicBud Comprehensive Test Suite"
echo "====================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
RUN_COVERAGE=false
RUN_INTEGRATION=false
RUN_UNIT_ONLY=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --coverage|-c)
      RUN_COVERAGE=true
      shift
      ;;
    --integration|-i)
      RUN_INTEGRATION=true
      shift
      ;;
    --unit|-u)
      RUN_UNIT_ONLY=true
      shift
      ;;
    --verbose|-v)
      VERBOSE=true
      shift
      ;;
    --help|-h)
      echo "Usage: ./run_comprehensive_tests.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  -c, --coverage       Generate coverage report"
      echo "  -i, --integration    Run integration tests"
      echo "  -u, --unit          Run only unit tests"
      echo "  -v, --verbose       Verbose output"
      echo "  -h, --help          Show this help message"
      echo ""
      echo "Examples:"
      echo "  ./run_comprehensive_tests.sh                    # Run all unit tests"
      echo "  ./run_comprehensive_tests.sh --coverage         # Run with coverage"
      echo "  ./run_comprehensive_tests.sh --integration      # Run integration tests"
      echo "  ./run_comprehensive_tests.sh -c -i              # Coverage + integration"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Function to print status
print_status() {
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
  print_error "Flutter is not installed or not in PATH"
  exit 1
fi

print_status "Flutter detected: $(flutter --version | head -n 1)"
echo ""

# Generate mocks if needed
echo "📦 Generating Mocks..."
if flutter pub run build_runner build --delete-conflicting-outputs > /dev/null 2>&1; then
  print_status "Mocks generated successfully"
else
  print_warning "Mock generation had warnings (this is usually okay)"
fi
echo ""

# Run unit tests
if [ "$RUN_UNIT_ONLY" = true ] || [ "$RUN_INTEGRATION" = false ]; then
  echo "🧪 Running Unit Tests..."
  echo ""
  
  if [ "$VERBOSE" = true ]; then
    VERBOSE_FLAG="--verbose"
  else
    VERBOSE_FLAG=""
  fi
  
  if [ "$RUN_COVERAGE" = true ]; then
    echo "   Running with coverage..."
    if flutter test --coverage $VERBOSE_FLAG; then
      print_status "Unit tests passed"
      
      # Generate HTML coverage report
      echo ""
      echo "📊 Generating Coverage Report..."
      if command -v genhtml &> /dev/null; then
        genhtml coverage/lcov.info -o coverage/html --quiet
        print_status "Coverage report generated: coverage/html/index.html"
        
        # Calculate coverage percentage
        COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}')
        echo "   Coverage: $COVERAGE"
      else
        print_warning "genhtml not installed. Install with: sudo apt-get install lcov"
      fi
    else
      print_error "Unit tests failed"
      exit 1
    fi
  else
    if flutter test $VERBOSE_FLAG; then
      print_status "Unit tests passed"
    else
      print_error "Unit tests failed"
      exit 1
    fi
  fi
  echo ""
fi

# Run integration tests
if [ "$RUN_INTEGRATION" = true ]; then
  echo "🔗 Running Integration Tests..."
  echo ""
  
  # Check if device is connected
  DEVICES=$(flutter devices --machine | grep -o '"id"' | wc -l)
  if [ "$DEVICES" -eq 0 ]; then
    print_error "No devices connected. Please connect a device or start an emulator."
    exit 1
  fi
  
  print_status "Device detected"
  
  if [ "$VERBOSE" = true ]; then
    VERBOSE_FLAG="--verbose"
  else
    VERBOSE_FLAG=""
  fi
  
  # Run integration tests
  if flutter test integration_test/ $VERBOSE_FLAG; then
    print_status "Integration tests passed"
  else
    print_error "Integration tests failed"
    exit 1
  fi
  echo ""
fi

# Summary
echo ""
echo "================================"
echo "✅ Test Suite Complete!"
echo "================================"
echo ""

if [ "$RUN_COVERAGE" = true ]; then
  echo "📊 Coverage Report: coverage/html/index.html"
  echo ""
fi

# Specific test results
echo "Test Results:"
echo "-------------"

if [ "$RUN_UNIT_ONLY" = true ] || [ "$RUN_INTEGRATION" = false ]; then
  echo "✅ Unit Tests: PASSED"
fi

if [ "$RUN_INTEGRATION" = true ]; then
  echo "✅ Integration Tests: PASSED"
fi

echo ""
echo "🎉 All tests passed successfully!"
echo ""

# Optional: Open coverage report in browser
if [ "$RUN_COVERAGE" = true ]; then
  read -p "Open coverage report in browser? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v xdg-open &> /dev/null; then
      xdg-open coverage/html/index.html
    elif command -v open &> /dev/null; then
      open coverage/html/index.html
    else
      echo "Coverage report location: $(pwd)/coverage/html/index.html"
    fi
  fi
fi

exit 0
