#!/usr/bin/env bash

# Flutter Test Data Cleaner
# Usage: ./scripts/clean_test_data.sh [--deep]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DEEP_CLEAN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --deep|-d)
            DEEP_CLEAN=true
            shift
            ;;
        -h|--help)
            echo "Flutter Test Data Cleaner"
            echo ""
            echo "Usage: ./scripts/clean_test_data.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --deep, -d    Deep clean (includes Flutter cache and build files)"
            echo "  --help, -h    Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}🧹 Flutter Test Data Cleaner${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

CLEANED_COUNT=0

# Remove coverage data
if [ -d "coverage" ]; then
    echo -e "${YELLOW}Removing coverage data...${NC}"
    rm -rf coverage
    echo -e "${GREEN}✓ Coverage data removed${NC}"
    ((CLEANED_COUNT++))
else
    echo -e "${BLUE}ℹ No coverage data found${NC}"
fi

# Remove test results
if [ -f "test-results.xml" ] || [ -f "test_report.json" ]; then
    echo -e "${YELLOW}Removing test results...${NC}"
    rm -f test-results.xml test_report.json
    echo -e "${GREEN}✓ Test results removed${NC}"
    ((CLEANED_COUNT++))
else
    echo -e "${BLUE}ℹ No test results found${NC}"
fi

# Remove generated mocks
echo -e "${YELLOW}Removing generated mocks...${NC}"
find . -name "*.mocks.dart" -type f -delete 2>/dev/null || true
find . -name "*.g.dart" -type f -delete 2>/dev/null || true
echo -e "${GREEN}✓ Generated mocks removed${NC}"
((CLEANED_COUNT++))

# Remove integration test logs
if ls integration_test/*.log 1> /dev/null 2>&1; then
    echo -e "${YELLOW}Removing integration test logs...${NC}"
    rm -f integration_test/*.log
    echo -e "${GREEN}✓ Integration test logs removed${NC}"
    ((CLEANED_COUNT++))
else
    echo -e "${BLUE}ℹ No integration test logs found${NC}"
fi

# Deep clean
if [ "$DEEP_CLEAN" = true ]; then
    echo ""
    echo -e "${YELLOW}Performing deep clean...${NC}"
    
    # Remove build directory
    if [ -d "build" ]; then
        echo -e "${YELLOW}Removing build directory...${NC}"
        rm -rf build
        echo -e "${GREEN}✓ Build directory removed${NC}"
        ((CLEANED_COUNT++))
    fi
    
    # Remove .dart_tool
    if [ -d ".dart_tool" ]; then
        echo -e "${YELLOW}Removing .dart_tool directory...${NC}"
        rm -rf .dart_tool
        echo -e "${GREEN}✓ .dart_tool directory removed${NC}"
        ((CLEANED_COUNT++))
    fi
    
    # Remove pub cache
    echo -e "${YELLOW}Running flutter clean...${NC}"
    flutter clean > /dev/null 2>&1
    echo -e "${GREEN}✓ Flutter clean complete${NC}"
    ((CLEANED_COUNT++))
    
    # Get dependencies again
    echo -e "${YELLOW}Reinstalling dependencies...${NC}"
    flutter pub get > /dev/null 2>&1
    echo -e "${GREEN}✓ Dependencies reinstalled${NC}"
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}📝 Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "Items cleaned: ${GREEN}$CLEANED_COUNT${NC}"

if [ "$DEEP_CLEAN" = true ]; then
    echo -e "Clean type: ${YELLOW}Deep${NC}"
else
    echo -e "Clean type: ${BLUE}Standard${NC}"
    echo ""
    echo -e "${BLUE}💡 Tip: Use --deep for a more thorough clean${NC}"
fi

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Test data cleanup complete!${NC}"
