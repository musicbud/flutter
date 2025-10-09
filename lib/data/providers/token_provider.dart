import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_constants.dart';

class TokenProvider {
  String? _accessToken;
  String? _refreshToken;
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs?.getString(AppConstants.authTokenKey);
    _refreshToken = _prefs?.getString(AppConstants.refreshTokenKey);
    if (kDebugMode) {
      debugPrint('🔑 TokenProvider: Initialized - Access: ${_accessToken != null ? "loaded" : "none"}, Refresh: ${_refreshToken != null ? "loaded" : "none"}');
    }
  }

  String? get token => _accessToken;

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  Future<void> updateTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _prefs?.setString(AppConstants.authTokenKey, accessToken);
    await _prefs?.setString(AppConstants.refreshTokenKey, refreshToken);
    if (kDebugMode) {
      debugPrint('🔑 TokenProvider: Tokens updated and saved to storage');
    }
  }

  Future<void> updateAccessToken(String newToken) async {
    _accessToken = newToken;
    await _prefs?.setString(AppConstants.authTokenKey, newToken);
    if (kDebugMode) {
      debugPrint('🔑 TokenProvider: Access token updated');
    }
  }

  Future<void> updateToken(String newToken) async {
    await updateAccessToken(newToken);
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await _prefs?.remove(AppConstants.authTokenKey);
    await _prefs?.remove(AppConstants.refreshTokenKey);
    if (kDebugMode) {
      debugPrint('🔑 TokenProvider: Tokens cleared from storage');
    }
  }

  Future<void> clearToken() async {
    await clearTokens();
  }
}