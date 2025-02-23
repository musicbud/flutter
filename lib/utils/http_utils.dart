import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../core/error/exceptions.dart';
import '../data/providers/token_provider.dart';
import '../injection.dart';

class HttpUtils {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  static Future<Map<String, String>> getAuthHeaders() async {
    try {
      // final token = await getToken();
      final token = sl<TokenProvider>().token;
      final headers = Map<String, String>.from(ApiConfig.defaultHeaders);

      if (token != null) {
        if (await _isTokenExpired()) {
          throw AuthenticationException(message: 'Token expired');
        }
        headers['Authorization'] = 'Bearer $token';
      }

      return headers;
    } catch (e) {
      throw AuthenticationException(message: 'Failed to get auth headers: $e');
    }
  }

  static Future<void> saveToken(String token,
      {String? refreshToken, int? expiresIn}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);

      if (refreshToken != null) {
        await prefs.setString(_refreshTokenKey, refreshToken);
      }

      if (expiresIn != null) {
        final expiryTime = DateTime.now()
            .add(Duration(seconds: expiresIn))
            .millisecondsSinceEpoch;
        await prefs.setInt(_tokenExpiryKey, expiryTime);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save token: $e');
    }
  }

  static Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove(_tokenKey),
        prefs.remove(_refreshTokenKey),
        prefs.remove(_tokenExpiryKey),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to clear token: $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get token: $e');
    }
  }

  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get refresh token: $e');
    }
  }

  static Future<bool> _isTokenExpired() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expiryTime = prefs.getInt(_tokenExpiryKey);

      if (expiryTime == null) return false;

      return DateTime.now().millisecondsSinceEpoch > expiryTime;
    } catch (e) {
      throw CacheException(message: 'Failed to check token expiry: $e');
    }
  }
}
