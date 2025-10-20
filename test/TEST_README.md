# MusicBud Test Directory 🧪

## Navigation Guide

This directory contains all unit and widget tests for the MusicBud Flutter application.

---

## Quick Links

- 📖 **[Testing Guide](../TESTING_GUIDE.md)** - Comprehensive testing documentation
- ⚡ **[Quick Reference](../TEST_QUICK_REFERENCE.md)** - Common commands and patterns
- 📅 **[Development Plan](../TEST_DEVELOPMENT_PLAN.md)** - Detailed roadmap
- 📊 **[Progress Tracker](../TEST_PROGRESS.md)** - Current progress
- 📝 **[Plan Summary](../TEST_PLAN_SUMMARY.md)** - Executive summary

---

## Directory Structure

```
test/
├── blocs/                          # BLoC unit tests
│   ├── chat/
│   │   ├── chat_bloc_comprehensive_test.dart        ✅ 25 tests
│   │   └── chat_bloc_comprehensive_test.mocks.dart
│   ├── content/
│   │   ├── content_bloc_comprehensive_test.dart     ✅ 28 tests
│   │   └── content_bloc_comprehensive_test.mocks.dart
│   ├── bud_matching/
│   │   └── bud_matching_bloc_comprehensive_test.dart ⏳ 0 tests
│   ├── profile/
│   │   └── profile_bloc_comprehensive_test.dart      ⏳ 0 tests
│   └── settings/
│       └── settings_bloc_comprehensive_test.dart     ⏳ 0 tests
│
├── widgets/                        # Widget tests
│   ├── chat/                      ⏳ Not started
│   ├── discover/                  ⏳ Not started
│   ├── profile/                   ⏳ Not started
│   ├── matching/                  ⏳ Not started
│   └── common/                    ⏳ Not started
│
├── helpers/                        # Test utilities
│   └── test_helpers.dart          ✅ Mock factories & utilities
│
└── TEST_README.md                  # This file
```

---

## Test Categories

### ✅ BLoC Unit Tests (Completed: 2/5)

**Purpose**: Test business logic in isolation  
**Pattern**: blocTest with mocked repositories  
**Location**: `test/blocs/`

**Completed:**
- ✅ ChatBloc (25 tests)
- ✅ ContentBloc (28 tests)

**Todo:**
- ⏳ BudMatchingBloc (30 tests planned)
- ⏳ ProfileBloc (35 tests planned)
- ⏳ SettingsBloc (25 tests planned)

### ⏳ Widget Tests (Completed: 0/5)

**Purpose**: Test UI components in isolation  
**Pattern**: testWidgets with mocked BLoCs  
**Location**: `test/widgets/`

**Planned:**
- ⏳ ChatScreen widgets (20 tests)
- ⏳ DiscoverScreen widgets (18 tests)
- ⏳ ProfileScreen widgets (22 tests)
- ⏳ BudMatchingScreen widgets (16 tests)
- ⏳ Common widgets (25 tests)

---

## Running Tests

### All Tests
```bash
# From project root
flutter test

# With verbose output
flutter test --verbose

# With coverage
flutter test --coverage
```

### Specific Tests
```bash
# Run BLoC tests
flutter test test/blocs/

# Run specific BLoC
flutter test test/blocs/chat/

# Run single test file
flutter test test/blocs/chat/chat_bloc_comprehensive_test.dart

# Run single test by name
flutter test --name "sends message successfully"
```

### Widget Tests
```bash
# Run all widget tests
flutter test test/widgets/

# Run specific widget tests
flutter test test/widgets/chat/
```

---

## Test Templates

### BLoC Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([MyRepository])
import 'my_bloc_test.mocks.dart';

void main() {
  group('MyBloc', () {
    late MyBloc bloc;
    late MockMyRepository mockRepo;

    setUp(() {
      mockRepo = MockMyRepository();
      bloc = MyBloc(repository: mockRepo);
    });

    tearDown(() {
      bloc.close();
    });

    group('Feature Group', () {
      blocTest<MyBloc, MyState>(
        'description of what should happen',
        build: () {
          when(mockRepo.method()).thenAnswer((_) async => data);
          return bloc;
        },
        act: (bloc) => bloc.add(MyEvent()),
        expect: () => [
          MyLoadingState(),
          MySuccessState(data),
        ],
        verify: (_) {
          verify(mockRepo.method()).called(1);
        },
      );
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('MyWidget', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MyWidget(),
        ),
      );

      expect(find.byType(MyWidget), findsOneWidget);
      expect(find.text('Expected Text'), findsOneWidget);
    });

    testWidgets('handles user interaction', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MyWidget(),
        ),
      );

      // Tap button
      await tester.tap(find.byKey(Key('my_button')));
      await tester.pump();

      // Verify result
      expect(find.text('Result'), findsOneWidget);
    });
  });
}
```

---

## Mock Generation

### Generate Mocks
```bash
# Generate all mocks
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter pub run build_runner watch
```

### Mock Files
Mocks are generated as `.mocks.dart` files next to test files:
- `chat_bloc_comprehensive_test.mocks.dart`
- `content_bloc_comprehensive_test.mocks.dart`

---

## Test Helpers

### Location
`test/helpers/test_helpers.dart`

### Available Utilities

**FakeDataFactory** - Generate test data:
```dart
// User profile
FakeDataFactory.userProfile(id: 'user123');

// Chat message
FakeDataFactory.chatMessage(content: 'Test');

// Music track
FakeDataFactory.track(title: 'Song Name');

// Lists
FakeDataFactory.trackList(10);
FakeDataFactory.artistList(5);
```

**TestUtils** - Test utilities:
```dart
// Error generators
TestUtils.apiError('API Error');
TestUtils.networkError();
TestUtils.authError();

// State checkers
TestUtils.isLoadingState(state);
TestUtils.isErrorState(state);
TestUtils.isSuccessState(state);
```

**MockResponseBuilder** - API responses:
```dart
// Paginated response
MockResponseBuilder.paginatedResponse(data: items);

// Success response
MockResponseBuilder.successResponse(data: data);

// Error response
MockResponseBuilder.errorResponse(message: 'Error');
```

---

## Common Patterns

### Testing Success Path
```dart
blocTest<MyBloc, MyState>(
  'emits success when operation succeeds',
  build: () {
    when(mockRepo.getData()).thenAnswer((_) async => data);
    return bloc;
  },
  act: (bloc) => bloc.add(LoadData()),
  expect: () => [LoadingState(), SuccessState(data)],
);
```

### Testing Error Handling
```dart
blocTest<MyBloc, MyState>(
  'emits error when operation fails',
  build: () {
    when(mockRepo.getData()).thenThrow(Exception('Error'));
    return bloc;
  },
  act: (bloc) => bloc.add(LoadData()),
  expect: () => [LoadingState(), ErrorState('Error')],
);
```

### Testing Empty Results
```dart
blocTest<MyBloc, MyState>(
  'handles empty data',
  build: () {
    when(mockRepo.getList()).thenAnswer((_) async => []);
    return bloc;
  },
  act: (bloc) => bloc.add(LoadList()),
  expect: () => [
    LoadingState(),
    isA<SuccessState>().having(
      (s) => s.items,
      'empty list',
      isEmpty,
    ),
  ],
);
```

---

## Coverage

### Generate Coverage Report
```bash
# Generate coverage
flutter test --coverage

# Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html

# View report
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

### Coverage Goals
- BLoCs: 90%+
- Widgets: 85%+
- Overall: 85%+

---

## Troubleshooting

### Mock Generation Fails
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Tests Timeout
Add timeout to test:
```dart
testWidgets('test', (tester) async {
  // ...
}, timeout: Timeout(Duration(minutes: 5)));
```

### State Mismatch
Use `.having()` to inspect properties:
```dart
expect: () => [
  isA<MyState>()
    .having((s) => s.property, 'description', expectedValue),
],
```

---

## Best Practices

### ✅ Do
- Write descriptive test names
- Group related tests
- Test both success and failure paths
- Test edge cases
- Use `setUp()` and `tearDown()`
- Verify repository interactions
- Keep tests independent

### ❌ Don't
- Write interdependent tests
- Skip edge cases
- Test implementation details
- Use real API calls in unit tests
- Leave commented-out tests
- Duplicate test logic

---

## Next Steps

1. **Review existing tests**: `test/blocs/chat/` and `test/blocs/content/`
2. **Read the guide**: See `../TESTING_GUIDE.md`
3. **Check the plan**: See `../TEST_DEVELOPMENT_PLAN.md`
4. **Start coding**: Begin with BudMatchingBloc tests

---

## Quick Commands Reference

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific file
flutter test test/blocs/chat/chat_bloc_comprehensive_test.dart

# Run by name
flutter test --name "test name"

# Generate mocks
flutter pub run build_runner build --delete-conflicting-outputs

# Verbose output
flutter test --verbose
```

---

**Last Updated**: 2025-10-14  
**Current Progress**: 53/143 unit tests (37%)  
**Next Task**: BudMatchingBloc tests
