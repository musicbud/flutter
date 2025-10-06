import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_constants.dart';

class TokenProvider {
  String? _token;
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs?.getString(AppConstants.authTokenKey);
    if (kDebugMode) {
      debugPrint('🔑 TokenProvider: Initialized - ${_token != null ? "Token loaded from storage" : "No token in storage"}');
    }
  }

  String? get token {
    if (kDebugMode) {
      debugPrint('🔑 TokenProvider: Getting token - ${_token != null ? "Token exists" : "No token"}');
    }
    return _token;
  }

  Future<void> updateToken(String newToken) async {
    _token = newToken;
    await _prefs?.setString(AppConstants.authTokenKey, newToken);
    if (kDebugMode) {
      debugPrint('🔑 TokenProvider: Token updated and saved to storage');
    }
  }

  Future<void> clearToken() async {
    _token = null;
    await _prefs?.remove(AppConstants.authTokenKey);
    if (kDebugMode) {
      debugPrint('🔑 TokenProvider: Token cleared from storage');
    }
  }
}