### # MusicBud Flutter - Comprehensive Test Suite

## 📋 Overview

This comprehensive test suite covers all aspects of the MusicBud Flutter application including:
- **Unit Tests**: BLoC logic, services, repositories
- **Widget Tests**: UI components and screens
- **Integration Tests**: End-to-end user flows
- **Debug Tools**: Debugging dashboard and logging utilities

## 📁 Test Structure

```
test/
├── test_config.dart                          # Global test configuration
├── README.md                                  # This file
│
├── blocs/                                     # BLoC unit tests
│   └── auth/
│       └── auth_bloc_comprehensive_test.dart  # Complete AuthBloc tests
│
├── widgets/                                   # Widget tests
│   └── comprehensive_widget_test.dart         # UI component tests
│
├── integration_tests/                         # Integration tests
│   └── comprehensive_integration_test.dart    # End-to-end flows
│
├── services/                                  # Service tests
│   ├── api_service_test.dart
│   └── dynamic_theme_service_test.dart
│
└── test_utils/                                # Test utilities
    ├── mock_data.dart
    ├── test_helpers.dart
    └── widget_test_helpers.dart
```

## 🚀 Running Tests

### Run All Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run Specific Test Suites

```bash
# Unit tests only
flutter test test/blocs/
flutter test test/services/

# Widget tests only
flutter test test/widgets/

# Integration tests
flutter test integration_test/
```

### Run Individual Test Files

```bash
# AuthBloc tests
flutter test test/blocs/auth/auth_bloc_comprehensive_test.dart

# Widget tests
flutter test test/widgets/comprehensive_widget_test.dart

# Integration tests
flutter test test/integration_tests/comprehensive_integration_test.dart
```

### Run Tests with Verbose Output

```bash
flutter test --verbose

# With specific file
flutter test test/blocs/auth/auth_bloc_comprehensive_test.dart --verbose
```

## 🧪 Test Types

### 1. Unit Tests (BLoC & Services)

**Location**: `test/blocs/`, `test/services/`

**Purpose**: Test individual components in isolation

**Example**:
```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, Authenticated] when login succeeds',
  build: () => authBloc,
  act: (bloc) => bloc.add(LoginRequested(username: 'test', password: 'pass')),
  expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
);
```

**Run**:
```bash
flutter test test/blocs/auth/auth_bloc_comprehensive_test.dart
```

### 2. Widget Tests

**Location**: `test/widgets/`

**Purpose**: Test UI components and user interactions

**Example**:
```dart
testWidgets('Button tap triggers callback', (tester) async {
  await tester.pumpWidget(MyWidget());
  await tester.tap(find.text('Submit'));
  await tester.pump();
  expect(find.text('Success'), findsOneWidget);
});
```

**Run**:
```bash
flutter test test/widgets/comprehensive_widget_test.dart
```

### 3. Integration Tests

**Location**: `test/integration_tests/`

**Purpose**: Test complete user flows end-to-end

**Example**:
```dart
testWidgets('Complete login flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField).at(0), 'username');
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();
  expect(find.text('Welcome'), findsOneWidget);
});
```

**Run**:
```bash
flutter test test/integration_tests/comprehensive_integration_test.dart
```

## 🔧 Test Configuration

### TestConfig Class

Global configuration in `test_config.dart`:

```dart
class TestConfig {
  // Test credentials
  static const String testUsername = 'test_user';
  static const String testPassword = 'Test@123';
  static const String testToken = 'test_jwt_token_12345';
  
  // Timeouts
  static const Duration shortTimeout = Duration(seconds: 2);
  static const Duration mediumTimeout = Duration(seconds: 5);
  static const Duration longTimeout = Duration(seconds: 10);
}
```

### Test Utilities

```dart
// Pump widget with MaterialApp
await TestUtils.pumpTestWidget(tester, MyWidget());

// Create mock response
final response = TestUtils.createMockResponse(
  data: {'key': 'value'},
  statusCode: 200,
);

// Verify snackbar
TestUtils.verifySnackbar(tester, 'Success message');
```

## 📊 Test Coverage

### Generate Coverage Report

```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

### Current Coverage Targets

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 70%+ coverage
- **Integration Tests**: Major user flows covered
- **Overall**: 75%+ code coverage

## 🐛 Debugging Tests

### Debug Dashboard

Access the debugging dashboard in debug mode:

```dart
import 'package:musicbud_flutter/debug/debug_dashboard.dart';

// Add to your screen
floatingActionButton: DebugFAB(),
```

Features:
- **Logs Tab**: View all application logs
- **Network Tab**: Monitor API calls and responses
- **BLoCs Tab**: Track BLoC events and state changes
- **Performance Tab**: Monitor FPS and frame times
- **Overview Tab**: App info and quick actions

### Test Logging

Enable detailed test logging:

```dart
TestLogger.enabled = true;
TestLogger.log('Test message');
TestLogger.logError('Error occurred');
TestLogger.logSuccess('Test passed');
```

### BLoC Debugging

Enable BLoC observer for debugging:

```dart
Bloc.observer = DebugBlocObserver();
```

This will log:
- 🔵 BLoC Events
- 🟢 State Changes
- 🔴 Errors

### Network Debugging

Add Dio interceptor for network debugging:

```dart
dio.interceptors.add(DebugDioInterceptor());
```

This logs:
- 🌐 Requests
- ✅ Successful responses
- ❌ Errors

## 🎯 Testing Best Practices

### 1. Test Organization

```dart
group('Feature Name', () {
  setUp(() {
    // Setup before each test
  });

  tearDown(() {
    // Cleanup after each test
  });

  test('should do something', () {
    // Test logic
  });
});
```

### 2. Mock Dependencies

```dart
@GenerateMocks([AuthRepository, TokenProvider])
void main() {
  late MockAuthRepository mockRepo;
  
  setUp(() {
    mockRepo = MockAuthRepository();
  });
}
```

### 3. Use Test Data Generators

```dart
final userData = TestDataGenerator.generateUserProfile();
final contentList = TestDataGenerator.generateContentList(10);
```

### 4. Test Edge Cases

- Empty inputs
- Null values
- Network errors
- Timeout scenarios
- Concurrent operations

### 5. Async Testing

```dart
testWidgets('async test', (tester) async {
  await tester.pumpWidget(MyWidget());
  await tester.pump(Duration(seconds: 1));
  await tester.pumpAndSettle();
});
```

## 📝 Writing New Tests

### 1. Create Test File

```bash
# Create test file matching source structure
touch test/blocs/my_feature/my_feature_bloc_test.dart
```

### 2. Basic Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import '../../test_config.dart';

void main() {
  group('MyFeatureBloc', () {
    late MyFeatureBloc bloc;
    
    setUp(() {
      bloc = MyFeatureBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is correct', () {
      expect(bloc.state, isA<MyFeatureInitial>());
    });

    blocTest<MyFeatureBloc, MyFeatureState>(
      'emits correct states',
      build: () => bloc,
      act: (bloc) => bloc.add(MyFeatureEvent()),
      expect: () => [isA<MyFeatureLoading>(), isA<MyFeatureSuccess>()],
    );
  });
}
```

### 3. Widget Test Template

```dart
testWidgets('Widget test', (tester) async {
  await TestUtils.pumpTestWidget(tester, MyWidget());
  
  expect(find.text('Hello'), findsOneWidget);
  
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  expect(find.text('Clicked'), findsOneWidget);
});
```

## 🔍 Troubleshooting

### Test Fails with Timeout

```dart
// Increase timeout
testWidgets('test', (tester) async {
  await tester.pumpAndSettle(TestConfig.longTimeout);
}, timeout: Timeout(Duration(seconds: 30)));
```

### Widget Not Found

```dart
// Wait for widget to appear
await tester.pumpAndSettle();
await tester.pump(Duration(milliseconds: 500));
```

### Mock Not Working

```dart
// Verify mock was configured
when(mockRepo.getData()).thenAnswer((_) async => testData);

// Verify mock was called
verify(mockRepo.getData()).called(1);
```

### Network Image Fails in Tests

```dart
// Use test images or error builders
FadeInImage(
  placeholder: AssetImage('assets/placeholder.png'),
  image: NetworkImage('url'),
  imageErrorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error);
  },
);
```

## 📈 CI/CD Integration

### GitHub Actions Example

```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter test integration_test/
```

### Test Scripts

Add to `package.json` or Makefile:

```bash
# Run all tests
make test

# Run with coverage
make test-coverage

# Run integration tests
make test-integration
```

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [bloc_test Package](https://pub.dev/packages/bloc_test)
- [mockito Package](https://pub.dev/packages/mockito)
- [integration_test Package](https://docs.flutter.dev/testing/integration-tests)

## 🎉 Test Suite Features

### ✅ Completed
- [x] Global test configuration
- [x] AuthBloc comprehensive tests
- [x] Widget tests for common components
- [x] Integration tests for major flows
- [x] Debug dashboard
- [x] Test utilities and helpers
- [x] Mock data generators
- [x] Custom test matchers
- [x] Test logging system

### 🚧 TODO
- [ ] Tests for all remaining BLoCs
- [ ] Tests for all services
- [ ] Tests for all repositories
- [ ] Performance benchmarks
- [ ] Visual regression tests
- [ ] Accessibility tests
- [ ] Golden tests for UI

## 📞 Support

For questions or issues with tests:
1. Check this documentation
2. Review existing test examples
3. Check the debug dashboard logs
4. Review test output with `--verbose` flag

---

**Happy Testing! 🧪**

*Last Updated: January 14, 2025*
