# AuthBloc Test Coverage Report

## Summary
- **Total Lines**: 104
- **Lines Covered**: 100
- **Coverage Percentage**: 96.15%
- **Total Tests**: 48
- **Test Status**: ✅ All Passing

## Coverage Details

### Fully Covered Areas (100%)
✅ **Authentication Events**
- Login (success, failure, network errors, empty credentials)
- Register (success, failure, invalid email)
- Logout (success, failure, token clearing)
- Token refresh (success, failure)

✅ **Service Connection Events**
- Get service auth URL (success, error)
- Connect services: Spotify, YTMusic, MAL, LastFM (success, error)
- Refresh service tokens: Spotify, YTMusic (success, error, unsupported service)

✅ **State Management**
- All state classes and their props methods
- Authenticated.copyWith() method
- State equality checks

✅ **Event Management**
- All event classes and their props methods  
- Event equality checks

✅ **Edge Cases**
- Very long usernames
- Special characters in credentials
- Sequential login requests
- Timeout scenarios

### Uncovered Lines (4 lines: 246-249)

**Location**: `lib/blocs/auth/auth_bloc.dart` lines 246-249

**Code**:
```dart
if (state is Authenticated) {
  final currentState = state as Authenticated;
  emit(currentState.copyWith(
    connectedServices: Map.from(currentState.connectedServices)
      ..[event.service] = true,
  ));
}
```

**Reason**: This code is unreachable due to a bug in the BLoC implementation.

**Bug Description**:
In the `_onConnectService` handler, `AuthLoading()` is emitted on line 230 before checking if the state is `Authenticated` on line 245. Once `AuthLoading()` is emitted, `this.state` is updated immediately to `AuthLoading`, so the check `if (state is Authenticated)` will always be false.

**Fix Recommendation**:
The handler should either:
1. Check the state BEFORE emitting `AuthLoading()`, OR
2. Store the previous state in a variable before emitting `AuthLoading()`, OR  
3. Restructure the logic to emit the loading state differently

**Proposed Fix**:
```dart
Future<void> _onConnectService(
  ConnectService event,
  Emitter<AuthState> emit,
) async {
  try {
    final previousState = state;  // Store state before emitting AuthLoading
    emit(AuthLoading());
    
    switch (event.service) {
      case 'spotify':
        await _authRepository.connectSpotify(event.code);
        break;
      // ... other cases
    }
    
    if (previousState is Authenticated) {  // Check the stored state
      emit(previousState.copyWith(
        connectedServices: Map.from(previousState.connectedServices)
          ..[event.service] = true,
      ));
    }
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}
```

## Test Categories

### 1. Event Tests (25 tests)
- LoginRequested (4 tests)
- RegisterRequested (3 tests)
- LogoutRequested (3 tests)
- TokenRefreshRequested (2 tests)
- Service Connection (10 tests)
- Event Props & Equality (3 tests)

### 2. State Tests (16 tests)
- State equality (3 tests)
- Authenticated.copyWith (3 tests)
- State props methods (5 tests)
- ServiceAuthUrlReceived (1 test)

### 3. Edge Case Tests (4 tests)
- Long usernames
- Special characters
- Sequential requests
- Timeouts

### 4. Integration Tests (3 tests)
- Initial state
- End-to-end flows

## Running Tests

### Run all AuthBloc tests:
```bash
flutter test test/blocs/auth/auth_bloc_comprehensive_test.dart
```

### Run with coverage:
```bash
flutter test --coverage test/blocs/auth/auth_bloc_comprehensive_test.dart
```

### View coverage report:
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run specific test:
```bash
flutter test test/blocs/auth/auth_bloc_comprehensive_test.dart --name "test name"
```

## Test Organization

```
test/blocs/auth/
├── auth_bloc_comprehensive_test.dart  # All tests
├── auth_bloc_comprehensive_test.mocks.dart  # Generated mocks
└── COVERAGE_REPORT.md  # This file
```

## Dependencies

- `flutter_test`: Flutter testing framework
- `bloc_test`: BLoC-specific testing utilities
- `mockito`: Mocking framework
- Test configuration: `test/test_config.dart`

## Notes

- All tests use proper setup/tearDown to ensure clean state
- Mocks are properly generated using `@GenerateMocks` annotation
- Tests follow AAA pattern (Arrange, Act, Assert)
- Edge cases and error paths are thoroughly tested
- Test logging helps with debugging

## Future Improvements

1. Fix the BLoC bug to achieve 100% coverage
2. Add performance benchmarks
3. Add property-based tests using `package:test_api`
4. Add integration tests with real repositories (using test databases)
