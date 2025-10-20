# Test Suite Quick Reference 🚀

## Run Tests

```bash
# All unit tests
flutter test

# With coverage
./run_comprehensive_tests.sh --coverage

# Integration tests
./run_comprehensive_tests.sh --integration

# Specific file
flutter test test/blocs/chat/chat_bloc_comprehensive_test.dart

# Specific test by name
flutter test --name "sends message successfully"

# Verbose output
flutter test --verbose
```

## Generate Mocks

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Test Files

### Unit Tests ✅
- `test/blocs/chat/chat_bloc_comprehensive_test.dart` - 25+ tests
- `test/blocs/content/content_bloc_comprehensive_test.dart` - 28+ tests

### Integration Tests ✅
- `integration_test/bloc_integration_test.dart` - 6 scenarios
- `integration_test/api_data_flow_test.dart` - 6 scenarios

## Test Structure

```dart
blocTest<MyBloc, MyState>(
  'description',
  build: () {
    when(mock.method()).thenAnswer((_) async => data);
    return bloc;
  },
  act: (bloc) => bloc.add(Event()),
  expect: () => [LoadingState(), SuccessState()],
  verify: (_) => verify(mock.method()).called(1),
);
```

## Debugging Tips

### Run Single Test
```bash
flutter test test/blocs/chat/chat_bloc_comprehensive_test.dart --name "channel list"
```

### Add Debug Print
```dart
act: (bloc) {
  print('Current state: ${bloc.state}');
  bloc.add(MyEvent());
},
```

### Inspect State
```dart
expect: () => [
  isA<MyState>()
    .having((s) => s.data, 'data field', expectedValue)
    .having((s) => s.count, 'count', greaterThan(0)),
],
```

## Common Test Patterns

### Test Success
```dart
build: () {
  when(mock.getData()).thenAnswer((_) async => data);
  return bloc;
},
expect: () => [LoadingState(), SuccessState(data)],
```

### Test Error
```dart
build: () {
  when(mock.getData()).thenThrow(Exception('Error'));
  return bloc;
},
expect: () => [LoadingState(), ErrorState('Error')],
```

### Test Empty
```dart
build: () {
  when(mock.getList()).thenAnswer((_) async => []);
  return bloc;
},
expect: () => [
  LoadingState(),
  isA<SuccessState>().having((s) => s.items, 'empty', isEmpty),
],
```

### Test Pagination
```dart
act: (bloc) async {
  bloc.add(LoadPage(1));
  await Future.delayed(Duration(milliseconds: 100));
  bloc.add(LoadPage(2));
},
```

## Coverage Report

```bash
# Generate
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# View
open coverage/html/index.html          # macOS
xdg-open coverage/html/index.html      # Linux
start coverage/html/index.html          # Windows
```

## Mock Setup

### Mock Repository
```dart
late MockRepository mockRepo;

setUp(() {
  mockRepo = MockRepository();
  bloc = MyBloc(repository: mockRepo);
});

tearDown(() {
  bloc.close();
});
```

### Mock Return Value
```dart
when(mockRepo.method()).thenAnswer((_) async => value);
```

### Mock Error
```dart
when(mockRepo.method()).thenThrow(Exception('Error'));
```

### Verify Calls
```dart
verify: (_) {
  verify(mockRepo.method()).called(1);
  verifyNoMoreInteractions(mockRepo);
},
```

## Test Checklist ✅

- [ ] Test initial state
- [ ] Test loading state
- [ ] Test success state
- [ ] Test error state
- [ ] Test empty data
- [ ] Test large data
- [ ] Test edge cases
- [ ] Verify repository calls
- [ ] Generate mocks
- [ ] All tests pass

## Key Files

| File | Purpose |
|------|---------|
| `TESTING_GUIDE.md` | Comprehensive guide |
| `TEST_QUICK_REFERENCE.md` | This file |
| `run_comprehensive_tests.sh` | Test runner script |
| `test/helpers/test_helpers.dart` | Test utilities |

## Test Counts

- **ChatBloc**: 25+ unit tests
- **ContentBloc**: 28+ unit tests
- **BLoC Integration**: 6 scenarios
- **API Data Flow**: 6 scenarios
- **Total**: 65+ test cases

## Next Steps

1. Run tests: `flutter test`
2. Check coverage: `./run_comprehensive_tests.sh --coverage`
3. Fix any failures
4. Add more tests for other BLoCs

## Support

- 📖 Full guide: `TESTING_GUIDE.md`
- 🔧 Test runner: `./run_comprehensive_tests.sh --help`
- 🐛 Debug: Use `--verbose` and `print()`

---

**Quick Start**: `flutter test` → Fix failures → `./run_comprehensive_tests.sh --coverage` → View report
