// import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Commented out due to libsecret-1 dependency issues
import 'package:shared_preferences/shared_preferences.dart';

/// A token provider that falls back to SharedPreferences when SecureStorage is not available
/// This is especially useful for environments where libsecret-1 or similar system libraries are not available
class CrossPlatformTokenProvider {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';
  
  SharedPreferences? _prefs;
  bool _useSecureStorage = false; // Always use SharedPreferences for cross-platform compatibility

  CrossPlatformTokenProvider() {
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _useSecureStorage = false; // Always use SharedPreferences
    } catch (e) {
      // This should not happen with SharedPreferences, but just in case
      throw Exception('Failed to initialize SharedPreferences: $e');
    }
  }

  Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await _initializeStorage();
    }
  }

  /// Store access token
  Future<void> setAccessToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_accessTokenKey, token);
  }

  /// Store refresh token
  Future<void> setRefreshToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_refreshTokenKey, token);
  }

  /// Store both tokens at once
  Future<void> updateTokens(String accessToken, String refreshToken) async {
    await _ensureInitialized();
    await _prefs!.setString(_accessTokenKey, accessToken);
    await _prefs!.setString(_refreshTokenKey, refreshToken);
  }

  /// Update only access token (typically after refresh)
  Future<void> updateAccessToken(String accessToken) async {
    await _ensureInitialized();
    await _prefs!.setString(_accessTokenKey, accessToken);
  }

  /// Get access token
  Future<String?> get token async {
    await _ensureInitialized();
    return _prefs!.getString(_accessTokenKey);
  }

  /// Get access token (alternative getter)
  Future<String?> getAccessToken() async {
    return await token;
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    return _prefs!.getString(_refreshTokenKey);
  }

  /// Store user ID
  Future<void> setUserId(String userId) async {
    await _ensureInitialized();
    await _prefs!.setString(_userIdKey, userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    await _ensureInitialized();
    return _prefs!.getString(_userIdKey);
  }

  /// Set login status
  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _ensureInitialized();
    await _prefs!.setBool(_isLoggedInKey, isLoggedIn);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    await _ensureInitialized();
    return _prefs!.getBool(_isLoggedInKey) ?? false;
  }

  /// Clear all tokens and login status
  Future<void> clearTokens() async {
    await _ensureInitialized();
    await _prefs!.remove(_accessTokenKey);
    await _prefs!.remove(_refreshTokenKey);
    await _prefs!.remove(_userIdKey);
    await _prefs!.remove(_isLoggedInKey);
  }

  /// Check if tokens exist
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  /// Get authorization header value
  Future<String?> getAuthorizationHeader() async {
    final token = await getAccessToken();
    return token != null ? 'Bearer $token' : null;
  }

  /// Check if secure storage is being used
  bool get isUsingSecureStorage => _useSecureStorage;

  /// Get storage type for debugging
  String get storageType => _useSecureStorage ? 'SecureStorage' : 'SharedPreferences';
}