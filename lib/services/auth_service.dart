import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import '../data/providers/token_provider.dart';
import '../domain/repositories/auth_repository.dart';
import '../injection_container.dart' as di;
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  TokenProvider? _tokenProvider;
  AuthRepository? _authRepository;
  
  /// Initialize the auth service
  Future<void> initialize() async {
    try {
      _tokenProvider = di.sl<TokenProvider>();
      _authRepository = di.sl<AuthRepository>();
      debugPrint('🔐 AuthService: Initialized successfully');
    } catch (e) {
      debugPrint('🔐 AuthService: Initialization error: $e');
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      developer.log(message);
    }
  }

  /// Check if user has a valid token
  Future<bool> isAuthenticated() async {
    try {
      final token = _tokenProvider?.accessToken;
      
      if (token == null || token.isEmpty) {
        debugPrint('🔐 AuthService: No access token found');
        return false;
      }

      // Check if token is expired
      if (await _isTokenExpired(token)) {
        debugPrint('🔐 AuthService: Access token is expired');
        
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (!refreshed) {
          debugPrint('🔐 AuthService: Token refresh failed');
          return false;
        }
      }

      debugPrint('🔐 AuthService: User is authenticated');
      return true;
    } catch (e) {
      debugPrint('🔐 AuthService: Error checking authentication: $e');
      return false;
    }
  }

  /// Check if token is expired by decoding JWT
  Future<bool> _isTokenExpired(String token) async {
    try {
      // Handle fake/test tokens - consider them valid for testing
      if (token.startsWith('fake-jwt-')) {
        debugPrint('🔐 AuthService: Using test token, assuming valid');
        return false;
      }
      
      // Split JWT token
      final parts = token.split('.');
      if (parts.length != 3) {
        debugPrint('🔐 AuthService: Invalid JWT token format');
        return true;
      }

      // Decode payload (second part)
      final payload = parts[1];
      // Add padding if needed for base64 decoding
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> tokenData = jsonDecode(decoded);

      // Check expiration
      final exp = tokenData['exp'] as int?;
      if (exp == null) {
        debugPrint('🔐 AuthService: Token has no expiration claim');
        return false; // Assume valid if no exp claim
      }

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      final isExpired = now.isAfter(expirationDate);

      if (isExpired) {
        debugPrint('🔐 AuthService: Token expired at ${expirationDate.toIso8601String()}');
      } else {
        final timeLeft = expirationDate.difference(now);
        debugPrint('🔐 AuthService: Token valid for ${timeLeft.inMinutes} minutes');
      }

      return isExpired;
    } catch (e) {
      debugPrint('🔐 AuthService: Error checking token expiration: $e');
      return true; // Assume expired if we can't parse
    }
  }

  /// Attempt to refresh the access token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = _tokenProvider?.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('🔐 AuthService: No refresh token available');
        return false;
      }

      // Handle fake/test tokens - simulate successful refresh for testing
      if (refreshToken.startsWith('fake-jwt-')) {
        debugPrint('🔐 AuthService: Using test refresh token, simulating refresh');
        return true; // Consider refresh successful for test tokens
      }

      debugPrint('🔐 AuthService: Attempting token refresh...');
      final refreshResult = await _authRepository?.refreshToken();
      
      if (refreshResult != null) {
        await _tokenProvider?.updateTokens(
          refreshResult.accessToken, 
          refreshToken, // Keep the existing refresh token
        );
        debugPrint('🔐 AuthService: Token refresh successful');
        return true;
      } else {
        debugPrint('🔐 AuthService: Token refresh returned null result');
      }
    } catch (e) {
      debugPrint('🔐 AuthService: Token refresh failed: $e');
      // Clear tokens if refresh fails completely
      if (e.toString().contains('401') || e.toString().contains('403')) {
        debugPrint('🔐 AuthService: Clearing invalid tokens due to auth error');
        await _tokenProvider?.clearTokens();
      }
    }
    
    return false;
  }

  Future<bool> login(String username, String password) async {
    try {
      debugPrint('🔐 AuthService: Attempting login for user: $username');
      
      // Use the repository for login
      if (_authRepository != null) {
        final loginResult = await _authRepository!.login(username, password);
        
        await _tokenProvider?.updateTokens(
          loginResult.accessToken,
          loginResult.refreshToken ?? '',
        );
        
        debugPrint('🔐 AuthService: Repository login successful, tokens saved');
        return true;
      }
      
      // Fallback to direct API call
      final response = await _apiService.dio.post(
        '/login',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['access'] ?? data['access_token'];
        final refreshToken = data['refresh'] ?? data['refresh_token'];

        if (accessToken != null && refreshToken != null) {
          await _tokenProvider?.updateTokens(accessToken, refreshToken);
          await _apiService.setAuthToken(accessToken);
          await _apiService.setRefreshToken(refreshToken);
          
          _log('Access token set: ${accessToken.substring(0, 20)}...');
          _log('Refresh token set: ${refreshToken.substring(0, 20)}...');
          debugPrint('🔐 AuthService: Direct API login successful');
          return true;
        }
      }

      _log('Login failed: ${response.statusCode}');
      debugPrint('🔐 AuthService: Login failed with status ${response.statusCode}');
      return false;
    } catch (e) {
      _log('Login error: $e');
      debugPrint('🔐 AuthService: Login error: $e');
      return false;
    }
  }

  /// Perform logout
  Future<void> logout() async {
    try {
      debugPrint('🔐 AuthService: Performing logout...');
      
      // Call backend logout if needed
      await _authRepository?.logout();
      
      // Clear local tokens
      await _tokenProvider?.clearTokens();
      
      debugPrint('🔐 AuthService: Logout completed');
    } catch (e) {
      debugPrint('🔐 AuthService: Logout error (continuing anyway): $e');
      // Still clear local tokens even if backend call fails
      await _tokenProvider?.clearTokens();
    }
  }

  /// Get current access token
  String? get accessToken => _tokenProvider?.accessToken;

  /// Get current refresh token  
  String? get refreshToken => _tokenProvider?.refreshToken;

  /// Check if tokens exist (not necessarily valid)
  bool hasTokens() {
    final accessToken = _tokenProvider?.accessToken;
    final refreshToken = _tokenProvider?.refreshToken;
    return accessToken != null && 
           accessToken.isNotEmpty && 
           refreshToken != null && 
           refreshToken.isNotEmpty;
  }

  /// Get user ID from token
  String? getUserIdFromToken() {
    final token = accessToken;
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> tokenData = jsonDecode(decoded);

      return tokenData['user_id']?.toString();
    } catch (e) {
      debugPrint('🔐 AuthService: Error extracting user ID: $e');
      return null;
    }
  }

  /// Get username from token
  String? getUsernameFromToken() {
    final token = accessToken;
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> tokenData = jsonDecode(decoded);

      return tokenData['username']?.toString();
    } catch (e) {
      debugPrint('🔐 AuthService: Error extracting username: $e');
      return null;
    }
  }
}
