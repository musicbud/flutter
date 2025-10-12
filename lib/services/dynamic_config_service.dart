import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

/// Service for managing dynamic app configuration
class DynamicConfigService {
  static DynamicConfigService? _instance;
  static DynamicConfigService get instance => _instance ??= DynamicConfigService._();

  DynamicConfigService._();

  SharedPreferences? _prefs;
  Map<String, dynamic> _config = {};
  bool _isInitialized = false;

  /// Initialize the configuration service
  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    await _loadConfiguration();
    _isInitialized = true;
  }

  /// Load configuration from local storage and remote source
  Future<void> _loadConfiguration() async {
    try {
      // Load from local storage first
      final localConfig = _prefs?.getString('app_config');
      if (localConfig != null) {
        _config = Map<String, dynamic>.from(json.decode(localConfig));
      }

      // Load default configuration
      _config = {
        ..._getDefaultConfig(),
        ..._config,
      };

      // Try to load remote configuration
      await _loadRemoteConfiguration();
    } catch (e) {
      debugPrint('Error loading configuration: $e');
      _config = _getDefaultConfig();
    }
  }

  /// Get default configuration
  Map<String, dynamic> _getDefaultConfig() {
    return {
      'theme': 'dark',
      'language': 'en',
      'api_endpoint': ApiConfig.baseUrl,
      'enable_analytics': true,
      'enable_crash_reporting': true,
      'cache_duration': 3600,
      'max_retries': 3,
      'timeout': 30,
      'features': {
        'spotify_integration': true,
        'chat_system': true,
        'bud_matching': true,
        'music_discovery': true,
        'social_features': true,
      },
      'ui': {
        'show_onboarding': true,
        'enable_animations': true,
        'compact_mode': false,
        'show_tutorials': true,
      },
      'privacy': {
        'collect_analytics': true,
        'share_usage_data': false,
        'enable_location': false,
      },
    };
  }

  /// Load configuration from remote source
  Future<void> _loadRemoteConfiguration() async {
    try {
      // TODO: Implement remote configuration loading
      // This could be from a configuration endpoint or feature flags service
      debugPrint('Remote configuration loading not implemented yet');
    } catch (e) {
      debugPrint('Failed to load remote configuration: $e');
    }
  }

  /// Save configuration to local storage
  Future<void> _saveConfiguration() async {
    if (_prefs != null) {
      await _prefs!.setString('app_config', json.encode(_config));
    }
  }

  /// Get a configuration value
  T get<T>(String key, {T? defaultValue}) {
    final keys = key.split('.');
    dynamic value = _config;

    for (final k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return defaultValue ?? (T == bool ? false as T :
                               T == int ? 0 as T :
                               T == double ? 0.0 as T :
                               T == String ? '' as T : null as T);
      }
    }

    return value as T;
  }

  /// Set a configuration value
  Future<void> set<T>(String key, T value) async {
    final keys = key.split('.');
    dynamic config = _config;

    // Navigate to the parent of the target key
    for (int i = 0; i < keys.length - 1; i++) {
      if (config is! Map<String, dynamic>) {
        config = <String, dynamic>{};
      }
      if (!config.containsKey(keys[i])) {
        config[keys[i]] = <String, dynamic>{};
      }
      config = config[keys[i]];
    }

    // Set the value
    if (config is Map<String, dynamic>) {
      config[keys.last] = value;
      await _saveConfiguration();
    }
  }

  /// Get all configuration
  Map<String, dynamic> getAll() => Map.from(_config);

  /// Update configuration with new values
  Future<void> update(Map<String, dynamic> newConfig) async {
    _config = {
      ..._config,
      ...newConfig,
    };
    await _saveConfiguration();
  }

  /// Reset configuration to defaults
  Future<void> reset() async {
    _config = _getDefaultConfig();
    await _saveConfiguration();
  }

  /// Check if a feature is enabled
  bool isFeatureEnabled(String feature) {
    return get<bool>('features.$feature', defaultValue: false);
  }

  /// Enable/disable a feature
  Future<void> setFeatureEnabled(String feature, bool enabled) async {
    await set('features.$feature', enabled);
  }

  /// Get API endpoint with fallback
  String getApiEndpoint() {
    return get<String>('api_endpoint', defaultValue: ApiConfig.baseUrl);
  }

  /// Get theme mode
  String getTheme() {
    return get<String>('theme', defaultValue: 'dark');
  }

  /// Set theme mode
  Future<void> setTheme(String theme) async {
    await set('theme', theme);
  }

  /// Get language code
  String getLanguage() {
    return get<String>('language', defaultValue: 'en');
  }

  /// Set language code
  Future<void> setLanguage(String language) async {
    await set('language', language);
  }

  /// Check if analytics is enabled
  bool isAnalyticsEnabled() {
    return get<bool>('enable_analytics', defaultValue: true);
  }

  /// Set analytics enabled/disabled
  Future<void> setAnalyticsEnabled(bool enabled) async {
    await set('enable_analytics', enabled);
  }

  /// Get cache duration in seconds
  int getCacheDuration() {
    return get<int>('cache_duration', defaultValue: 3600);
  }

  /// Set cache duration
  Future<void> setCacheDuration(int duration) async {
    await set('cache_duration', duration);
  }

  /// Get timeout in seconds
  int getTimeout() {
    return get<int>('timeout', defaultValue: 30);
  }

  /// Set timeout
  Future<void> setTimeout(int timeout) async {
    await set('timeout', timeout);
  }

  /// Get max retries
  int getMaxRetries() {
    return get<int>('max_retries', defaultValue: 3);
  }

  /// Set max retries
  Future<void> setMaxRetries(int retries) async {
    await set('max_retries', retries);
  }

  /// Get UI configuration
  Map<String, dynamic> getUiConfig() {
    return get<Map<String, dynamic>>('ui', defaultValue: {});
  }

  /// Get privacy configuration
  Map<String, dynamic> getPrivacyConfig() {
    return get<Map<String, dynamic>>('privacy', defaultValue: {});
  }

  /// Check if app is initialized
  bool get isInitialized => _isInitialized;

  /// Reload configuration
  Future<void> reload() async {
    _isInitialized = false;
    await initialize();
  }
}
