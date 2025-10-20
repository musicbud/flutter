# MusicBud Test Development Plan 🚀

## 📋 Overview

This document outlines the comprehensive plan to complete test coverage for all BLoCs, integration scenarios, and widget components in the MusicBud Flutter application.

## 🎯 Goals

1. **Achieve 90%+ BLoC test coverage**
2. **Create integration tests for all major user flows**
3. **Build widget tests for all screens and components**
4. **Enable faster debugging through automated testing**
5. **Prevent regressions through comprehensive test suite**

## 📊 Current Status

### ✅ Completed (Phase 1)
- [x] ChatBloc unit tests (25+ test cases)
- [x] ContentBloc unit tests (28+ test cases)
- [x] BLoC integration tests (6 scenarios)
- [x] API data flow integration tests (6 scenarios)
- [x] Test infrastructure (runner script, guides)
- [x] Documentation (guides, quick reference)

**Total Completed**: 65+ test cases

### 🔄 In Progress (Phase 2-4)
- [ ] 3 more BLoC unit test suites
- [ ] 3 BLoC-specific integration tests
- [ ] 5 widget test suites
- [ ] Mock generation and test execution

**Estimated Completion**: 200+ total test cases

---

## 📅 Phase 2: Complete BLoC Unit Tests (Priority: HIGH)

### Task 1: BudMatchingBloc Unit Tests
**File**: `test/blocs/bud_matching/bud_matching_bloc_comprehensive_test.dart`

**Test Coverage** (~30 test cases):

#### A. Profile Fetching (5 tests)
- [ ] Fetches bud profile successfully
- [ ] Handles profile fetch failure
- [ ] Handles invalid bud ID
- [ ] Handles network timeout
- [ ] Handles empty profile data

#### B. Find Buds by Top Items (6 tests)
- [ ] Finds buds by top artists
- [ ] Finds buds by top tracks
- [ ] Finds buds by top genres
- [ ] Finds buds by top anime
- [ ] Finds buds by top manga
- [ ] Handles no matches found

#### C. Find Buds by Liked Items (5 tests)
- [ ] Finds buds by liked artists
- [ ] Finds buds by liked tracks
- [ ] Finds buds by liked genres
- [ ] Finds buds by liked albums
- [ ] Finds buds by liked AIO (all-in-one)

#### D. Find Buds by Specific Items (4 tests)
- [ ] Finds buds by specific artist ID
- [ ] Finds buds by specific track ID
- [ ] Finds buds by specific genre ID
- [ ] Finds buds by played tracks

#### E. Match Scoring & Filtering (5 tests)
- [ ] Sorts matches by match score
- [ ] Filters matches by minimum score
- [ ] Handles equal match scores
- [ ] Returns top N matches
- [ ] Handles empty match results

#### F. Edge Cases (5 tests)
- [ ] Handles very large match list (1000+)
- [ ] Handles network errors
- [ ] Handles authentication errors
- [ ] Handles malformed response data
- [ ] Handles rapid consecutive searches

**Estimated Time**: 4-5 hours

---

### Task 2: ProfileBloc Unit Tests
**File**: `test/blocs/profile/profile_bloc_comprehensive_test.dart`

**Test Coverage** (~35 test cases):

#### A. Profile Loading (5 tests)
- [ ] Loads user profile successfully
- [ ] Handles profile load failure
- [ ] Handles network timeout
- [ ] Handles unauthorized access
- [ ] Caches loaded profile

#### B. Profile Updates (8 tests)
- [ ] Updates profile successfully
- [ ] Validates required fields
- [ ] Handles update failure
- [ ] Updates first name
- [ ] Updates last name
- [ ] Updates birthday
- [ ] Updates gender
- [ ] Updates bio and interests

#### C. Avatar Management (4 tests)
- [ ] Requests avatar update
- [ ] Handles avatar upload success
- [ ] Handles avatar upload failure
- [ ] Validates image format/size

#### D. Top Items Loading (4 tests)
- [ ] Loads top tracks for profile
- [ ] Loads top artists for profile
- [ ] Loads top genres for profile
- [ ] Handles empty top items

#### E. Liked Items Loading (4 tests)
- [ ] Loads liked tracks for profile
- [ ] Loads liked artists for profile
- [ ] Loads liked genres for profile
- [ ] Handles empty liked items

#### F. Authentication & Session (4 tests)
- [ ] Checks authentication status
- [ ] Handles logout request
- [ ] Clears profile on logout
- [ ] Handles session expiry

#### G. Connected Services (3 tests)
- [ ] Loads connected services list
- [ ] Handles empty services
- [ ] Handles service connection errors

#### H. Edge Cases (3 tests)
- [ ] Handles concurrent profile updates
- [ ] Handles malformed profile data
- [ ] Handles very long bio text

**Estimated Time**: 5-6 hours

---

### Task 3: SettingsBloc Unit Tests
**File**: `test/blocs/settings/settings_bloc_comprehensive_test.dart`

**Test Coverage** (~25 test cases):

#### A. Load Settings (4 tests)
- [ ] Loads settings successfully
- [ ] Loads default settings on first run
- [ ] Handles load failure
- [ ] Caches loaded settings

#### B. Save Settings (4 tests)
- [ ] Saves settings successfully
- [ ] Persists settings to storage
- [ ] Handles save failure
- [ ] Validates setting values

#### C. Notification Settings (5 tests)
- [ ] Toggles push notifications
- [ ] Toggles email notifications
- [ ] Toggles message notifications
- [ ] Toggles match notifications
- [ ] Updates notification preferences

#### D. Privacy Settings (4 tests)
- [ ] Toggles profile visibility
- [ ] Updates privacy level
- [ ] Toggles location sharing
- [ ] Toggles online status visibility

#### E. Theme & Display (4 tests)
- [ ] Changes theme (light/dark/system)
- [ ] Updates font size
- [ ] Toggles animations
- [ ] Saves display preferences

#### F. Data Management (2 tests)
- [ ] Resets settings to defaults
- [ ] Clears cached data

#### G. Edge Cases (2 tests)
- [ ] Handles rapid setting changes
- [ ] Handles storage permission errors

**Estimated Time**: 3-4 hours

**Total Phase 2 Time**: 12-15 hours

---

## 📅 Phase 3: BLoC-Specific Integration Tests (Priority: HIGH)

### Task 4: ChatBloc Integration Tests
**File**: `integration_test/chat_bloc_integration_test.dart`

**Test Scenarios** (~10 scenarios):

#### A. Real-time Messaging (3 tests)
- [ ] Send message updates UI immediately
- [ ] Receive message appears in chat
- [ ] Message timestamps display correctly

#### B. Channel Management (3 tests)
- [ ] Switch between channels updates message list
- [ ] Create channel adds to channel list
- [ ] Empty channel shows empty state

#### C. Pagination & Scrolling (2 tests)
- [ ] Load more messages on scroll
- [ ] Maintains scroll position on new message

#### D. User Interactions (2 tests)
- [ ] Delete message removes from UI
- [ ] User list shows online status

**Estimated Time**: 3-4 hours

---

### Task 5: ContentBloc Integration Tests
**File**: `integration_test/content_bloc_integration_test.dart`

**Test Scenarios** (~12 scenarios):

#### A. Content Discovery (3 tests)
- [ ] Load discover screen shows content cards
- [ ] Categories switch content correctly
- [ ] Empty category shows empty state

#### B. User Interactions (4 tests)
- [ ] Like button toggles state
- [ ] Like count updates immediately
- [ ] Unlike removes from liked list
- [ ] Share button opens share dialog

#### C. Search & Filter (3 tests)
- [ ] Search updates results in real-time
- [ ] Filter applies to content list
- [ ] Sort changes content order

#### D. Infinite Scroll (2 tests)
- [ ] Scroll loads more content
- [ ] Pull to refresh reloads content

**Estimated Time**: 4-5 hours

---

### Task 6: BudMatchingBloc Integration Tests
**File**: `integration_test/bud_matching_bloc_integration_test.dart`

**Test Scenarios** (~10 scenarios):

#### A. Match Discovery (3 tests)
- [ ] Load matches displays match cards
- [ ] Empty matches shows empty state
- [ ] Match score displays correctly

#### B. Card Interactions (3 tests)
- [ ] Swipe right accepts match
- [ ] Swipe left rejects match
- [ ] Tap card opens profile

#### C. Filtering (2 tests)
- [ ] Apply filters updates match list
- [ ] Clear filters resets to all matches

#### D. Navigation (2 tests)
- [ ] View profile navigates correctly
- [ ] Back from profile restores match list

**Estimated Time**: 3-4 hours

**Total Phase 3 Time**: 10-13 hours

---

## 📅 Phase 4: Widget Tests (Priority: MEDIUM)

### Task 7: ChatScreen Widget Tests
**File**: `test/widgets/chat/chat_screen_widget_test.dart`

**Test Coverage** (~20 test cases):

#### Components to Test:
- [ ] ChatScreen renders correctly
- [ ] MessageList displays messages
- [ ] MessageInput accepts text input
- [ ] Send button triggers callback
- [ ] ChannelList displays channels
- [ ] UserList displays users
- [ ] Message bubble formatting
- [ ] Timestamp formatting
- [ ] Avatar displays
- [ ] Empty chat state
- [ ] Loading indicator
- [ ] Error state display
- [ ] Message deletion confirmation
- [ ] Channel creation dialog
- [ ] User profile sheet
- [ ] Online/offline indicators
- [ ] Typing indicators
- [ ] Message status icons
- [ ] Scroll to bottom button
- [ ] Navigation transitions

**Estimated Time**: 4-5 hours

---

### Task 8: DiscoverScreen Widget Tests
**File**: `test/widgets/discover/discover_screen_widget_test.dart`

**Test Coverage** (~18 test cases):

#### Components to Test:
- [ ] DiscoverScreen renders correctly
- [ ] ContentGrid displays items
- [ ] ContentCard shows all info
- [ ] Like button interaction
- [ ] Share button interaction
- [ ] FilterBar displays filters
- [ ] SearchBar accepts input
- [ ] CategoryTabs switch categories
- [ ] Loading skeleton animation
- [ ] Empty state display
- [ ] Error state display
- [ ] Pull to refresh
- [ ] Infinite scroll indicator
- [ ] Sort dropdown
- [ ] Filter chips
- [ ] Content detail navigation
- [ ] Image placeholders
- [ ] Content metadata display

**Estimated Time**: 4-5 hours

---

### Task 9: ProfileScreen Widget Tests
**File**: `test/widgets/profile/profile_screen_widget_test.dart`

**Test Coverage** (~22 test cases):

#### Components to Test:
- [ ] ProfileScreen renders correctly
- [ ] ProfileHeader displays info
- [ ] Avatar image displays
- [ ] Edit button triggers form
- [ ] TopItemsList displays items
- [ ] LikedItemsList displays items
- [ ] EditProfileForm validation
- [ ] Form field inputs
- [ ] Save button enabled/disabled
- [ ] Cancel button discards changes
- [ ] AvatarPicker opens gallery
- [ ] StatCards display metrics
- [ ] Settings navigation
- [ ] Logout button confirmation
- [ ] Empty top items state
- [ ] Empty liked items state
- [ ] Loading indicators
- [ ] Error displays
- [ ] Connected services list
- [ ] Delete account confirmation
- [ ] Privacy settings toggle
- [ ] Notification preferences

**Estimated Time**: 5-6 hours

---

### Task 10: BudMatchingScreen Widget Tests
**File**: `test/widgets/matching/bud_matching_screen_widget_test.dart`

**Test Coverage** (~16 test cases):

#### Components to Test:
- [ ] BudMatchingScreen renders correctly
- [ ] BudMatchCard displays info
- [ ] Match score badge
- [ ] Common interests display
- [ ] Swipe gesture left
- [ ] Swipe gesture right
- [ ] Tap card opens profile
- [ ] MatchFilters display
- [ ] Filter application
- [ ] SwipeableCard animation
- [ ] MatchList displays cards
- [ ] EmptyMatchState display
- [ ] Loading indicator
- [ ] Error state
- [ ] Navigation to profile
- [ ] Back button behavior

**Estimated Time**: 3-4 hours

---

### Task 11: Common Widget Component Tests
**File**: `test/widgets/common/common_widgets_test.dart`

**Test Coverage** (~25 test cases):

#### Components to Test:
- [ ] CustomButton renders correctly
- [ ] CustomButton disabled state
- [ ] CustomButton loading state
- [ ] CustomButton press callback
- [ ] LoadingIndicator displays
- [ ] LoadingIndicator with text
- [ ] ErrorWidget displays message
- [ ] ErrorWidget retry button
- [ ] EmptyState displays message
- [ ] EmptyState action button
- [ ] ContentCard displays data
- [ ] ContentCard image loading
- [ ] UserAvatar displays image
- [ ] UserAvatar fallback initials
- [ ] UserAvatar online indicator
- [ ] ListTile variants
- [ ] Custom dialog displays
- [ ] Dialog buttons trigger callbacks
- [ ] BottomSheet displays content
- [ ] BottomSheet drag to dismiss
- [ ] Snackbar displays message
- [ ] Toast notifications
- [ ] Badge display
- [ ] Chip selection
- [ ] Progress indicators

**Estimated Time**: 5-6 hours

**Total Phase 4 Time**: 21-26 hours

---

## 📅 Phase 5: Test Suite Completion (Priority: HIGH)

### Task 12: Generate Mocks and Run Tests
**Activities**:

#### A. Mock Generation (30 min)
- [ ] Generate all mocks with build_runner
- [ ] Fix any mock generation errors
- [ ] Verify mock files created
- [ ] Update import statements

#### B. Test Execution (1 hour)
- [ ] Run all unit tests
- [ ] Run all integration tests
- [ ] Run all widget tests
- [ ] Fix any test failures

#### C. Coverage Analysis (30 min)
- [ ] Generate coverage report
- [ ] Identify gaps in coverage
- [ ] Document coverage metrics
- [ ] Create coverage badges

#### D. Documentation (1 hour)
- [ ] Update test guides with new tests
- [ ] Add examples from new tests
- [ ] Document common patterns
- [ ] Create troubleshooting guide

**Estimated Time**: 3 hours

---

## 📈 Summary & Timeline

### Test Count Estimates

| Category | Current | Phase 2 | Phase 3 | Phase 4 | Total |
|----------|---------|---------|---------|---------|-------|
| Unit Tests | 53 | +90 | - | - | 143 |
| Integration Tests | 12 | - | +32 | - | 44 |
| Widget Tests | 0 | - | - | +101 | 101 |
| **Total** | **65** | **90** | **32** | **101** | **288** |

### Time Estimates

| Phase | Tasks | Estimated Time | Priority |
|-------|-------|----------------|----------|
| Phase 1 (Completed) | 4 | Completed ✅ | - |
| Phase 2 | 3 | 12-15 hours | HIGH |
| Phase 3 | 3 | 10-13 hours | HIGH |
| Phase 4 | 5 | 21-26 hours | MEDIUM |
| Phase 5 | 1 | 3 hours | HIGH |
| **Total** | **12** | **46-57 hours** | - |

### Recommended Schedule

**Week 1-2**: Phase 2 (BLoC Unit Tests)
- BudMatchingBloc: 4-5 hours
- ProfileBloc: 5-6 hours
- SettingsBloc: 3-4 hours

**Week 3**: Phase 3 (Integration Tests)
- ChatBloc integration: 3-4 hours
- ContentBloc integration: 4-5 hours
- BudMatchingBloc integration: 3-4 hours

**Week 4-5**: Phase 4 (Widget Tests)
- ChatScreen widgets: 4-5 hours
- DiscoverScreen widgets: 4-5 hours
- ProfileScreen widgets: 5-6 hours
- BudMatchingScreen widgets: 3-4 hours
- Common widgets: 5-6 hours

**Week 6**: Phase 5 (Completion)
- Mock generation: 30 min
- Test execution: 1 hour
- Coverage analysis: 30 min
- Documentation: 1 hour

---

## 🎯 Success Criteria

### Coverage Goals
- [ ] 90%+ BLoC test coverage
- [ ] 85%+ Widget test coverage
- [ ] 80%+ Integration test coverage
- [ ] 85%+ Overall test coverage

### Quality Goals
- [ ] All tests pass consistently
- [ ] No flaky tests
- [ ] Test execution time < 5 minutes
- [ ] Clear, descriptive test names
- [ ] Well-organized test groups

### Documentation Goals
- [ ] All tests documented
- [ ] Common patterns identified
- [ ] Troubleshooting guide complete
- [ ] Examples for all test types

---

## 🚀 Getting Started

### Start with Phase 2, Task 1:

```bash
# Create test file
touch test/blocs/bud_matching/bud_matching_bloc_comprehensive_test.dart

# Follow the test template from existing tests
# Reference: test/blocs/chat/chat_bloc_comprehensive_test.dart

# Generate mocks
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test test/blocs/bud_matching/bud_matching_bloc_comprehensive_test.dart
```

### Use Test Template:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([BudMatchingRepository])
import 'bud_matching_bloc_comprehensive_test.mocks.dart';

void main() {
  group('BudMatchingBloc', () {
    late BudMatchingBloc bloc;
    late MockBudMatchingRepository mockRepo;

    setUp(() {
      mockRepo = MockBudMatchingRepository();
      bloc = BudMatchingBloc(budMatchingRepository: mockRepo);
    });

    tearDown(() {
      bloc.close();
    });

    group('Profile Fetching', () {
      blocTest<BudMatchingBloc, BudMatchingState>(
        'fetches bud profile successfully',
        build: () {
          when(mockRepo.fetchBudProfile(any))
              .thenAnswer((_) async => budProfile);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchBudProfile(budId: '123')),
        expect: () => [
          BudMatchingLoading(),
          BudProfileLoaded(budProfile: budProfile),
        ],
      );
    });
  });
}
```

---

## 📞 Support & Resources

- **Test Guide**: `TESTING_GUIDE.md`
- **Quick Reference**: `TEST_QUICK_REFERENCE.md`
- **Test Runner**: `./run_comprehensive_tests.sh`
- **Examples**: Existing test files in `test/blocs/`

---

**Created**: 2025-10-14  
**Status**: Phase 2 Ready to Start  
**Progress**: 65/288 tests (23%)  
**Next Task**: BudMatchingBloc unit tests
