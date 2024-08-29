import 'package:dio/dio.dart';
import 'package:musicbud_flutter/services/api_service.dart'; // Make sure to import your ApiService

class AuthService {
  final ApiService _apiService = ApiService();

  Future<bool> login(String username, String password) async {
    try {
      // Make your login API call here
      final response = await Dio().post(
        'http://84.235.170.234/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final sessionId = response.headers['set-cookie']?.first.split(';').first.split('=').last;

        // Store the token and session ID
        await _apiService.setAuthToken(token);
        await _apiService.setSessionId(sessionId);

        print('Token set: $token');
        print('Session ID set: $sessionId');

        return true;
      } else {
        print('Login failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
}
