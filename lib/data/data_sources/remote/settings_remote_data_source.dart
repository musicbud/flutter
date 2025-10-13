import 'package:dio/dio.dart';

abstract class SettingsRemoteDataSource {
  Future<Map<String, dynamic>> getSettings();
  Future<void> updateNotificationSettings(Map<String, dynamic> settings);
  Future<void> updatePrivacySettings(Map<String, dynamic> settings);
  Future<void> updateTheme(String theme);
  Future<void> updateLanguage(String languageCode);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final Dio _dioClient;
  static const String _baseUrl = '/v1/users/settings';

  SettingsRemoteDataSourceImpl({required Dio dioClient})
      : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await _dioClient.get(_baseUrl);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get settings: ${e.message}');
    }
  }

  @override
  Future<void> updateNotificationSettings(Map<String, dynamic> settings) async {
    try {
      await _dioClient.put(
        '$_baseUrl/notifications',
        data: settings,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update notification settings: ${e.message}');
    }
  }

  @override
  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    try {
      await _dioClient.put(
        '$_baseUrl/privacy',
        data: settings,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update privacy settings: ${e.message}');
    }
  }

  @override
  Future<void> updateTheme(String theme) async {
    try {
      await _dioClient.put(
        '$_baseUrl/theme',
        data: {'theme': theme},
      );
    } on DioException catch (e) {
      throw Exception('Failed to update theme: ${e.message}');
    }
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    try {
      await _dioClient.put(
        '$_baseUrl/language',
        data: {'language_code': languageCode},
      );
    } on DioException catch (e) {
      throw Exception('Failed to update language: ${e.message}');
    }
  }
}
