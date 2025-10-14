#!/usr/bin/env bash

# Flutter Coverage Report Generator
# Usage: ./scripts/generate_coverage.sh [--open]

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

OPEN_BROWSER=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --open|-o)
            OPEN_BROWSER=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: ./scripts/generate_coverage.sh [--open]"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}📊 Flutter Coverage Report Generator${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

# Check if coverage data exists
if [ ! -f "coverage/lcov.info" ]; then
    echo -e "${YELLOW}⚠ No coverage data found. Running tests with coverage...${NC}"
    flutter test --coverage
    echo ""
fi

# Check for lcov
if ! command -v lcov &> /dev/null; then
    echo -e "${YELLOW}⚠ lcov not found. Please install it:${NC}"
    echo "  Linux: sudo apt-get install lcov"
    echo "  macOS: brew install lcov"
    exit 1
fi

# Generate HTML report
echo -e "${BLUE}Generating HTML coverage report...${NC}"
genhtml coverage/lcov.info -o coverage/html --quiet

# Calculate coverage statistics
echo -e "${BLUE}Calculating coverage statistics...${NC}"
COVERAGE_SUMMARY=$(lcov --summary coverage/lcov.info 2>&1)

# Extract coverage percentages
LINES_PERCENT=$(echo "$COVERAGE_SUMMARY" | grep "lines" | awk '{print $2}')
FUNCTIONS_PERCENT=$(echo "$COVERAGE_SUMMARY" | grep "functions" | awk '{print $2}')

echo ""
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}📈 Coverage Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "Lines:     ${GREEN}$LINES_PERCENT${NC}"
echo -e "Functions: ${GREEN}$FUNCTIONS_PERCENT${NC}"
echo ""

# Coverage threshold check
COVERAGE_NUM=$(echo "$LINES_PERCENT" | sed 's/%//' | cut -d'.' -f1)
if [ "$COVERAGE_NUM" -ge 60 ]; then
    echo -e "${GREEN}✅ Coverage meets 60% threshold${NC}"
else
    echo -e "${YELLOW}⚠️  Coverage below 60% threshold ($COVERAGE_NUM%)${NC}"
fi

echo ""
echo -e "${GREEN}✓ HTML report generated: coverage/html/index.html${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"

# Open in browser
if [ "$OPEN_BROWSER" = true ]; then
    echo ""
    echo -e "${BLUE}Opening coverage report in browser...${NC}"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open coverage/html/index.html
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        open coverage/html/index.html
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        start coverage/html/index.html
    else
        echo -e "${YELLOW}⚠ Cannot detect OS. Please open coverage/html/index.html manually${NC}"
    fi
fi
