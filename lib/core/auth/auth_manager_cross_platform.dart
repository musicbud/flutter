import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Cross-platform auth manager that uses SharedPreferences instead of SecureStorage
/// This is useful for environments where libsecret-1 or similar system libraries are not available
class AuthManagerCrossPlatform {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  
  SharedPreferences? _prefs;
  
  AuthManagerCrossPlatform();

  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Store authentication tokens
  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    await _ensureInitialized();
    await _prefs!.setString(_accessTokenKey, accessToken);
    await _prefs!.setString(_refreshTokenKey, refreshToken);
    if (userId != null) {
      await _prefs!.setString(_userIdKey, userId);
    }
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    await _ensureInitialized();
    return _prefs!.getString(_accessTokenKey);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    return _prefs!.getString(_refreshTokenKey);
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    await _ensureInitialized();
    return _prefs!.getString(_userIdKey);
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
    await _ensureInitialized();
    await _prefs!.remove(_accessTokenKey);
    await _prefs!.remove(_refreshTokenKey);
    await _prefs!.remove(_userIdKey);
  }

  /// Update access token (typically after refresh)
  Future<void> updateAccessToken(String newAccessToken) async {
    await _ensureInitialized();
    await _prefs!.setString(_accessTokenKey, newAccessToken);
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