import 'package:dio/dio.dart';
import 'package:musicbud_flutter/services/api_service.dart'; // Make sure to import your ApiService

class AuthService {
  final ApiService _apiService = ApiService();

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiService.dio.post(
        '/login',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
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
        final data = response.data['data'];
        final accessToken = data['access_token'];
        final refreshToken = data['refresh_token'];

        if (accessToken != null && refreshToken != null) {
          await _apiService.setAuthToken(accessToken);
          await _apiService.setRefreshToken(refreshToken);
          print('Access token set: $accessToken');
          print('Refresh token set: $refreshToken');
          return true;
        }
      }

      print('Login failed: ${response.statusCode}');
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
}