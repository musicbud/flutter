import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Setup function called before running tests
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUpAll(() {
    // Mock SharedPreferences for all tests
    SharedPreferences.setMockInitialValues({});
  });

  await testMain();
}