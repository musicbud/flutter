# MusicBud BLoC Comprehensive Test Suite

Welcome to the MusicBud BLoC test suite! This directory contains comprehensive unit tests for the core BLoC layer of the MusicBud application.

## 📊 Quick Stats

- **Total Tests**: 71
- **Test Files**: 2 main test files
- **Success Rate**: 100% ✅
- **Execution Time**: < 5 seconds
- **Coverage**: ProfileBloc (39 tests) + BudMatchingBloc (32 tests)

## 🗂️ Directory Structure

```
test/blocs/
├── README.md                          # This file
├── COMPREHENSIVE_TEST_SUMMARY.md      # Detailed overview
├── run_comprehensive_tests.sh         # Test runner script
│
├── profile/
│   ├── profile_bloc_comprehensive_test.dart
│   ├── profile_bloc_comprehensive_test.mocks.dart
│   └── TEST_SUMMARY.md
│
└── bud_matching/
    ├── bud_matching_bloc_comprehensive_test.dart
    ├── bud_matching_bloc_comprehensive_test.mocks.dart
    └── TEST_SUMMARY.md
```

## 🚀 Quick Start

### Run All Tests

```bash
# Using the provided script (recommended)
./test/blocs/run_comprehensive_tests.sh

# Or manually
flutter test test/blocs/profile/profile_bloc_comprehensive_test.dart test/blocs/bud_matching/bud_matching_bloc_comprehensive_test.dart
```

### Run Individual Test Suites

```bash
# ProfileBloc tests only
flutter test test/blocs/profile/profile_bloc_comprehensive_test.dart

# BudMatchingBloc tests only
flutter test test/blocs/bud_matching/bud_matching_bloc_comprehensive_test.dart
```

### Generate Mocks (if needed)

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 📖 Test Documentation

Each test suite has its own detailed documentation:

- **[ProfileBloc Tests](profile/TEST_SUMMARY.md)** - 39 tests covering user profile management
- **[BudMatchingBloc Tests](bud_matching/TEST_SUMMARY.md)** - 32 tests covering user matching
- **[Overall Summary](COMPREHENSIVE_TEST_SUMMARY.md)** - Complete test suite overview

## 🧪 What's Tested

### ProfileBloc (39 tests)
- ✅ Profile loading and updates
- ✅ Authentication and logout
- ✅ Top items (tracks, artists, genres)
- ✅ Liked items management
- ✅ Connected services
- ✅ Error handling and edge cases

### BudMatchingBloc (32 tests)
- ✅ Bud profile fetching
- ✅ Matching by top items (music & anime/manga)
- ✅ Matching by liked items
- ✅ Specific item matching
- ✅ Match scoring and filtering
- ✅ Error recovery and edge cases

## 🛠️ Technologies

- **Flutter Test** - Testing framework
- **bloc_test** - BLoC-specific testing utilities
- **mockito** - Mocking library
- **build_runner** - Code generation for mocks

## ✅ Prerequisites

Before running tests, ensure you have:

1. Flutter SDK installed
2. Project dependencies installed: `flutter pub get`
3. Mocks generated: `dart run build_runner build`

## 📈 CI/CD Integration

These tests are CI/CD ready! Example GitHub Actions configuration:

```yaml
- name: Install dependencies
  run: flutter pub get

- name: Generate mocks
  run: dart run build_runner build --delete-conflicting-outputs

- name: Run BLoC tests
  run: flutter test test/blocs/**/*_comprehensive_test.dart

- name: Generate coverage
  run: flutter test --coverage
```

## 🎯 Test Quality

- **Independent**: Each test runs in isolation
- **Fast**: ~70ms average per test
- **Maintainable**: Well-organized and documented
- **Comprehensive**: Covers happy paths, errors, and edge cases

## 📝 Writing New Tests

When adding new BLoC tests:

1. Follow the existing test structure
2. Use descriptive test names
3. Include success and failure scenarios
4. Add edge case testing
5. Update documentation

Example test structure:

```dart
blocTest<MyBloc, MyState>(
  'descriptive test name explaining what is tested',
  build: () {
    // Setup mocks
    when(mockRepo.method()).thenAnswer((_) async => data);
    return myBloc;
  },
  act: (bloc) => bloc.add(MyEvent()),
  expect: () => [
    LoadingState(),
    SuccessState(data: data),
  ],
  verify: (_) {
    verify(mockRepo.method()).called(1);
  },
);
```

## 🔍 Debugging Tests

### Run with verbose output
```bash
flutter test --reporter expanded test/blocs/**/*_comprehensive_test.dart
```

### Run a specific test
```bash
flutter test test/blocs/profile/profile_bloc_comprehensive_test.dart --plain-name "updates profile successfully"
```

### Generate coverage report
```bash
flutter test --coverage test/blocs/**/*_comprehensive_test.dart
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🐛 Troubleshooting

### Mocks not found
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Tests failing after code changes
1. Regenerate mocks: `dart run build_runner build`
2. Clean and get dependencies: `flutter clean && flutter pub get`
3. Re-run tests

### Slow test execution
- Tests should complete in < 5 seconds
- If slower, check for unnecessary delays or timeouts in tests

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [bloc_test Package](https://pub.dev/packages/bloc_test)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [BLoC Pattern Guide](https://bloclibrary.dev)

## 🤝 Contributing

When contributing tests:

1. Ensure all tests pass before submitting PR
2. Add tests for new BLoC functionality
3. Update documentation if needed
4. Follow existing code style and patterns

## 📞 Support

For questions or issues with the test suite:

1. Check the test documentation in each directory
2. Review the COMPREHENSIVE_TEST_SUMMARY.md
3. Examine existing tests for examples
4. Refer to Flutter and BLoC documentation

---

**Last Updated**: October 14, 2025  
**Maintained By**: MusicBud Development Team  
**Test Framework**: Flutter 3.x, BLoC 8.x
