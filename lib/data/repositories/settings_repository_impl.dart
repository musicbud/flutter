import '../../../domain/repositories/settings_repository.dart';
import '../data_sources/remote/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;

  SettingsRepositoryImpl({required SettingsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Map<String, dynamic>> getSettings() async {
    return await _remoteDataSource.getSettings();
  }

  @override
  Future<void> updateNotificationSettings(Map<String, dynamic> settings) async {
    await _remoteDataSource.updateNotificationSettings(settings);
  }

  @override
  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    await _remoteDataSource.updatePrivacySettings(settings);
  }

  @override
  Future<void> updateTheme(String theme) async {
    await _remoteDataSource.updateTheme(theme);
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    await _remoteDataSource.updateLanguage(languageCode);
  }
}
