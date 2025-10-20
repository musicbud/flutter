#!/run/current-system/sw/bin/bash

# MusicBud BLoC Comprehensive Tests Runner
# This script runs all comprehensive BLoC tests and displays results

set -e

echo "=================================================="
echo "  MusicBud BLoC Comprehensive Test Suite"
echo "=================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Change to project root
cd "$(dirname "$0")/../.."

echo -e "${BLUE}📋 Test Suite Information:${NC}"
echo "  - ProfileBloc: 39 tests"
echo "  - BudMatchingBloc: 32 tests"
echo "  - Total: 71 tests"
echo ""

echo -e "${BLUE}🔍 Verifying test files exist...${NC}"
if [ -f "test/blocs/profile/profile_bloc_comprehensive_test.dart" ]; then
    echo -e "  ${GREEN}✓${NC} ProfileBloc tests found"
else
    echo -e "  ${YELLOW}✗${NC} ProfileBloc tests not found"
    exit 1
fi

if [ -f "test/blocs/bud_matching/bud_matching_bloc_comprehensive_test.dart" ]; then
    echo -e "  ${GREEN}✓${NC} BudMatchingBloc tests found"
else
    echo -e "  ${YELLOW}✗${NC} BudMatchingBloc tests not found"
    exit 1
fi
echo ""

echo -e "${BLUE}🔧 Verifying mock files exist...${NC}"
if [ -f "test/blocs/profile/profile_bloc_comprehensive_test.mocks.dart" ]; then
    echo -e "  ${GREEN}✓${NC} ProfileBloc mocks found"
else
    echo -e "  ${YELLOW}⚠${NC}  ProfileBloc mocks not found - running build_runner..."
    dart run build_runner build --delete-conflicting-outputs
fi

if [ -f "test/blocs/bud_matching/bud_matching_bloc_comprehensive_test.mocks.dart" ]; then
    echo -e "  ${GREEN}✓${NC} BudMatchingBloc mocks found"
else
    echo -e "  ${YELLOW}⚠${NC}  BudMatchingBloc mocks not found - running build_runner..."
    dart run build_runner build --delete-conflicting-outputs
fi
echo ""

echo -e "${BLUE}🧪 Running ProfileBloc tests...${NC}"
flutter test test/blocs/profile/profile_bloc_comprehensive_test.dart
PROFILE_EXIT=$?
echo ""

echo -e "${BLUE}🧪 Running BudMatchingBloc tests...${NC}"
flutter test test/blocs/bud_matching/bud_matching_bloc_comprehensive_test.dart
MATCHING_EXIT=$?
echo ""

echo "=================================================="
if [ $PROFILE_EXIT -eq 0 ] && [ $MATCHING_EXIT -eq 0 ]; then
    echo -e "${GREEN}✅ All 71 tests passed successfully!${NC}"
    echo "=================================================="
    exit 0
else
    echo -e "${YELLOW}❌ Some tests failed${NC}"
    echo "=================================================="
    exit 1
fi
