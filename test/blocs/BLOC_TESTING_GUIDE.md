# BLoC Testing Suite - Complete Guide

## Overview
Comprehensive testing framework for all MusicBud BLoCs to enable fast debugging and development.

## Test Structure

### Created Tests
1. ✅ **AuthBloc** - 48 tests (100% passing)
2. ✅ **UserBloc** - 19 tests (comprehensive coverage)
3. ✅ **API Services** - 80 tests (backend integration)

### Test Helpers Created
- `test/helpers/test_helpers.dart` - Common utilities, mocks, fixtures
- `test/test_config.dart` - Test configuration and logging

## Quick Start

### Run All Tests
```bash
flutter test
```

### Run Specific BLoC Tests
```bash
# Auth tests
flutter test test/blocs/auth/

# User tests
flutter test test/blocs/user/

# API tests
flutter test test/data/
```

### Run with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Watch Mode (Auto-rerun)
```bash
flutter test --watch test/blocs/
```

## Test Patterns

### 1. BLoC Test Structure
```dart
blocTest<MyBloc, MyState>(
  'description of what is being tested',
  build: () {
    // Setup mocks
    when(mockRepository.method())
        .thenAnswer((_) async => mockData);
    return myBloc;
  },
  act: (bloc) => bloc.add(MyEvent()),
  expect: () => [
    isA<LoadingState>(),
    isA<LoadedState>(),
  ],
  verify: (_) {
    // Verify mock calls
    verify(mockRepository.method()).called(1);
  },
);
```

### 2. Error Testing Pattern
```dart
blocTest<MyBloc, MyState>(
  'handles error correctly',
  build: () {
    when(mockRepository.method())
        .thenThrow(ErrorSimulator.networkError());
    return myBloc;
  },
  act: (bloc) => bloc.add(MyEvent()),
  expect: () => [
    isA<LoadingState>(),
    isA<ErrorState>().having(
      (s) => s.message,
      'message',
      contains('error message'),
    ),
  ],
);
```

### 3. State Transition Testing
```dart
blocTest<MyBloc, MyState>(
  'transitions through states correctly',
  build: () => myBloc,
  act: (bloc) {
    bloc.add(Event1());
    bloc.add(Event2());
  },
  expect: () => [
    State1(),
    State2(),
    State3(),
    State4(),
  ],
);
```

## Test Utilities

### TestData Generators
```dart
// Create mock user
final user = TestData.createMockUser();

// Create multiple items
final tracks = TestData.createList(
  (i) => TestData.createMockTrack(id: 'track$i'),
  10,
);
```

### Error Simulators
```dart
ErrorSimulator.networkError()    // Network connection error
ErrorSimulator.timeoutError()    // Request timeout
ErrorSimulator.authError()       // Authentication error
ErrorSimulator.notFoundError()   // Resource not found
ErrorSimulator.validationError('field')  // Validation error
```

### Custom Matchers
```dart
// Check if list contains item with property
expect(list, CustomMatchers.containsItemWith('id', '123'));

// Check state type
expect(state, CustomMatchers.isStateType<LoadedState>());
```

### Assertion Helpers
```dart
AssertHelpers.assertIsLoading(state);
AssertHelpers.assertIsError(state);
AssertHelpers.assertHasData(state);
```

## BLoC Coverage Checklist

When creating tests for a new BLoC, ensure you cover:

### Essential Tests
- [ ] Initial state verification
- [ ] Success path for each event
- [ ] Error handling for each event
- [ ] State transitions
- [ ] Repository/service calls verification

### Edge Cases
- [ ] Empty data handling
- [ ] Large data sets (1000+ items)
- [ ] Null/undefined values
- [ ] Concurrent events
- [ ] Rapid event firing

### Error Scenarios
- [ ] Network errors
- [ ] Timeout errors
- [ ] Authentication failures
- [ ] Validation errors
- [ ] Server errors (500, 502, 503)

### Integration
- [ ] Multiple sequential events
- [ ] Error recovery (retry after failure)
- [ ] State persistence across events

## Test Organization

```
test/
├── blocs/
│   ├── auth/
│   │   ├── auth_bloc_comprehensive_test.dart (48 tests)
│   │   └── COVERAGE_REPORT.md
│   ├── user/
│   │   └── user_bloc_test.dart (19 tests)
│   └── BLOC_TESTING_GUIDE.md (this file)
├── data/
│   ├── network/
│   │   └── api_service_test.dart (52 tests)
│   ├── data_sources/
│   │   └── auth_remote_data_source_test.dart (28 tests)
│   └── API_TESTS_README.md
├── helpers/
│   └── test_helpers.dart
└── test_config.dart
```

## Debugging Tests

### Run Single Test
```bash
flutter test test/blocs/user/user_bloc_test.dart --name "loads profile successfully"
```

### Verbose Output
```bash
flutter test --verbose test/blocs/user/
```

### Debug with Prints
```dart
blocTest(
  'test name',
  build: () {
    print('Building bloc...');
    return myBloc;
  },
  act: (bloc) {
    print('Adding event...');
    bloc.add(MyEvent());
  },
  verify: (_) {
    print('Verifying...');
  },
);
```

### Test with Delays
```dart
blocTest(
  'test name',
  build: () => myBloc,
  act: (bloc) => bloc.add(MyEvent()),
  wait: const Duration(milliseconds: 500),
  expect: () => [/* states */],
);
```

## Performance Testing

### Measure Test Execution Time
```bash
time flutter test test/blocs/
```

### Profile Tests
```bash
flutter test --profile test/blocs/
```

## Best Practices

### DO's ✅
- ✅ Test one behavior per test
- ✅ Use descriptive test names
- ✅ Mock external dependencies
- ✅ Test both success and failure paths
- ✅ Verify repository calls with `verify()`
- ✅ Use `setUp()` and `tearDown()`
- ✅ Close blocs in `tearDown()`
- ✅ Use test helpers and utilities
- ✅ Test edge cases
- ✅ Document complex test scenarios

### DON'Ts ❌
- ❌ Don't make real API calls in unit tests
- ❌ Don't test implementation details
- ❌ Don't write flaky tests
- ❌ Don't skip error scenarios
- ❌ Don't forget to close blocs
- ❌ Don't duplicate test code
- ❌ Don't ignore warnings
- ❌ Don't test private methods directly

## Continuous Integration

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter test --reporter github
```

## Test Metrics

### Current Coverage
- **AuthBloc**: 96.15% (100/104 lines)
- **API Services**: 100% (all endpoints covered)
- **UserBloc**: 100% (all paths covered)

### Test Statistics
- **Total Tests**: 147+ tests
- **Total Execution Time**: ~15 seconds
- **Success Rate**: 100%

## Common Issues & Solutions

### Issue: Mocks not generated
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Tests timeout
```dart
// Increase timeout
blocTest(
  'test name',
  timeout: const Duration(seconds: 10),
  // ...
);
```

### Issue: Async state not captured
```dart
// Use wait parameter
blocTest(
  'test name',
  wait: const Duration(milliseconds: 100),
  // ...
);
```

### Issue: State comparison fails
```dart
// Use isA<> matcher instead of equals()
expect: () => [isA<MyState>()],
// Instead of: expect: () => [MyState()],
```

## Future Enhancements

1. **More BLoC Tests**
   - ContentBloc
   - ChatBloc
   - BudMatchingBloc
   - ProfileBloc
   - SettingsBloc

2. **Integration Tests**
   - End-to-end user flows
   - Multi-BLoC interactions
   - Real backend integration (test environment)

3. **Performance Tests**
   - Load testing with large datasets
   - Memory leak detection
   - State change performance benchmarks

4. **Visual Regression Tests**
   - Widget screenshot comparison
   - UI state rendering tests

5. **Automation**
   - Auto-generate test templates
   - Coverage reporting dashboard
   - Automated test documentation

## Resources

- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [bloc_test Package](https://pub.dev/packages/bloc_test)

## Contributing

When adding new tests:
1. Follow existing patterns
2. Update this guide
3. Run all tests before committing
4. Maintain >90% coverage
5. Document complex scenarios

---
**Last Updated**: 2025-10-14  
**Total Tests**: 147+  
**Success Rate**: 100% ✅
