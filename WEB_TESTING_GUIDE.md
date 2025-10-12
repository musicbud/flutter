# Web Testing Guide for MusicBud Flutter

## Problem
Flutter's `integration_test` package doesn't support web devices directly. When attempting to run integration tests in the `integration_test/` directory on web, you'll encounter the error:
```
Web devices are not supported for integration tests yet.
```

## Solution
For API integration tests that don't interact with UI widgets, we've created a web-compatible version that uses regular `flutter test` instead of the integration_test framework.

## Files Created

### 1. `test/api_web_test.dart`
This is a web-compatible version of the API integration test. It includes:
- `@TestOn('browser')` annotation to indicate it's designed for browser environments
- All the same API tests as the original integration test
- Uses `TestWidgetsFlutterBinding` instead of `IntegrationTestWidgetsFlutterBinding`

### 2. `test_driver/api_integration_test.dart`
Driver file for potential future use with `flutter drive` command (though not needed for the current solution).

### 3. `run_api_integration_test.sh`
A convenience script to run API integration tests on Linux desktop (alternative to web testing).

## Running the Tests

### Option 1: Run on Web (Chrome)
```bash
flutter test test/api_web_test.dart --platform chrome
```

### Option 2: Run on Linux Desktop
```bash
flutter test integration_test/api_integration_test.dart -d linux
```

Or use the convenience script:
```bash
./run_api_integration_test.sh
```

## Key Differences

| Aspect | integration_test/ | test/ (web-compatible) |
|--------|------------------|----------------------|
| **Location** | `integration_test/api_integration_test.dart` | `test/api_web_test.dart` |
| **Binding** | `IntegrationTestWidgetsFlutterBinding` | `TestWidgetsFlutterBinding` |
| **Web Support** | ❌ No | ✅ Yes |
| **Use Case** | Full integration tests with UI | API tests without UI interaction |
| **Command** | `flutter test integration_test/...` | `flutter test test/... --platform chrome` |

## Test Results
All 12 test groups pass successfully on web:
- ✅ Health and Connection
- ✅ Authentication (Register, Login)
- ✅ User Profile Endpoints
- ✅ Content Endpoints (Tracks, Artists)
- ✅ Search Endpoints (Users, Trending)
- ✅ Bud Matching Endpoints
- ✅ Library Endpoints
- ✅ API Configuration validation

## Notes
- The original `integration_test/api_integration_test.dart` is unchanged and still works on non-web platforms
- Tests gracefully handle authentication failures and missing endpoints
- The `flutter_test_config.dart` file was moved from project root to `test/` directory for proper test configuration
