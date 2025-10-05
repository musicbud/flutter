abstract class SettingsRepository {
  Future<Map<String, dynamic>> getSettings();
  Future<void> updateNotificationSettings(Map<String, dynamic> settings);
  Future<void> updatePrivacySettings(Map<String, dynamic> settings);
  Future<void> updateTheme(String theme);
  Future<void> updateLanguage(String languageCode);
}
