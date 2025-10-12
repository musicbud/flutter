import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Manages authentication state and token lifecycle
class AuthManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  
  final FlutterSecureStorage _storage;
  
  AuthManager({FlutterSecureStorage? storage}) 
    : _storage = storage ?? const FlutterSecureStorage();

  /// Store authentication tokens
  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    if (userId != null) {
      await _storage.write(key: _userIdKey, value: userId);
    }
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;
    
    // Check if token is expired
    return !isTokenExpired(accessToken);
  }

  /// Check if token is expired
  bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      // If we can't decode the token, consider it expired
      return true;
    }
  }

  /// Check if token needs refresh (expires in next 5 minutes)
  bool shouldRefreshToken(String token) {
    try {
      final expiryDate = JwtDecoder.getExpirationDate(token);
      final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
      return expiryDate.isBefore(fiveMinutesFromNow);
    } catch (e) {
      return true;
    }
  }

  /// Get token payload
  Map<String, dynamic>? getTokenPayload(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }

  /// Clear all stored tokens
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
  }

  /// Update access token (typically after refresh)
  Future<void> updateAccessToken(String newAccessToken) async {
    await _storage.write(key: _accessTokenKey, value: newAccessToken);
  }

  /// Get user ID from token if available
  Future<String?> getUserIdFromToken() async {
    final token = await getAccessToken();
    if (token == null) return null;
    
    final payload = getTokenPayload(token);
    return payload?['user_id'] ?? payload?['sub'];
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
}