/// Centralized application information and metadata
class AppInfo {
  // Private constructor to prevent instantiation
  AppInfo._();

  // Application Details
  static const String name = 'MusicBud';
  static const String description = 'Connect through music';
  static const String version = '1.0.0';
  static const String buildNumber = '1';
  static const String packageName = 'com.musicbud.app';
  static const String bundleId = 'com.musicbud.app';

  // Development Information
  static const String developerName = 'MusicBud Team';
  static const String developerEmail = 'dev@musicbud.com';
  static const String developerWebsite = 'https://musicbud.com';
  static const String supportEmail = 'support@musicbud.com';

  // Legal Information
  static const String privacyPolicyUrl = 'https://musicbud.com/privacy';
  static const String termsOfServiceUrl = 'https://musicbud.com/terms';
  static const String licenseUrl = 'https://musicbud.com/license';

  // Social Media
  static const String twitterHandle = '@musicbud';
  static const String instagramHandle = '@musicbud';
  static const String facebookPage = 'musicbud';

  // Technical Information
  static const String minFlutterVersion = '3.0.0';
  static const String targetFlutterVersion = '3.16.0';
  static const String minAndroidVersion = '21';
  static const String minIOSVersion = '12.0';
  static const String targetAndroidVersion = '33';
  static const String targetIOSVersion = '16.0';

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableRemoteConfig = true;
  static const bool enableABTesting = true;

  // API Configuration
  static const String apiBaseUrl = 'https://api.musicbud.com';
  static const String apiVersion = 'v1';
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;

  // Cache Configuration
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration cacheExpiration = Duration(days: 7);
  static const Duration imageCacheExpiration = Duration(days: 30);

  // UI Configuration
  static const double defaultAnimationDuration = 300.0;
  static const double defaultDebounceDelay = 500.0;
  static const int maxImageSize = 1024 * 1024; // 1MB
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  /// Get full application version string
  static String get fullVersion => '$version+$buildNumber';

  /// Get application identifier
  static String get identifier => '$packageName.$version';

  /// Get API endpoint URL
  static String get apiEndpoint => '$apiBaseUrl/$apiVersion';

  /// Check if running in development mode
  static bool get isDevelopment => const bool.fromEnvironment('dart.vm.product') == false;

  /// Check if running in production mode
  static bool get isProduction => !isDevelopment;

  /// Get application display name
  static String get displayName => name;

  /// Get application subtitle
  static String get subtitle => description;

  /// Get copyright information
  static String get copyright => '© ${DateTime.now().year} $developerName. All rights reserved.';

  /// Get application metadata as map
  static Map<String, dynamic> get metadata => {
    'name': name,
    'description': description,
    'version': version,
    'buildNumber': buildNumber,
    'packageName': packageName,
    'bundleId': bundleId,
    'developerName': developerName,
    'developerEmail': developerEmail,
    'developerWebsite': developerWebsite,
    'supportEmail': supportEmail,
    'privacyPolicyUrl': privacyPolicyUrl,
    'termsOfServiceUrl': termsOfServiceUrl,
    'licenseUrl': licenseUrl,
    'twitterHandle': twitterHandle,
    'instagramHandle': instagramHandle,
    'facebookPage': facebookPage,
    'minFlutterVersion': minFlutterVersion,
    'targetFlutterVersion': targetFlutterVersion,
    'minAndroidVersion': minAndroidVersion,
    'minIOSVersion': minIOSVersion,
    'targetAndroidVersion': targetAndroidVersion,
    'targetIOSVersion': targetIOSVersion,
    'enableAnalytics': enableAnalytics,
    'enableCrashReporting': enableCrashReporting,
    'enablePerformanceMonitoring': enablePerformanceMonitoring,
    'enableRemoteConfig': enableRemoteConfig,
    'enableABTesting': enableABTesting,
    'apiBaseUrl': apiBaseUrl,
    'apiVersion': apiVersion,
    'apiTimeoutSeconds': apiTimeoutSeconds,
    'maxRetryAttempts': maxRetryAttempts,
    'maxCacheSize': maxCacheSize,
    'cacheExpiration': cacheExpiration.inDays,
    'imageCacheExpiration': imageCacheExpiration.inDays,
    'defaultAnimationDuration': defaultAnimationDuration,
    'defaultDebounceDelay': defaultDebounceDelay,
    'maxImageSize': maxImageSize,
    'maxFileSize': maxFileSize,
    'isDevelopment': isDevelopment,
    'isProduction': isProduction,
    'fullVersion': fullVersion,
    'identifier': identifier,
    'apiEndpoint': apiEndpoint,
    'displayName': displayName,
    'subtitle': subtitle,
    'copyright': copyright,
  };

  /// Get application information as formatted string
  static String get infoString => '''
$name v$version (Build $buildNumber)
$description

Developer: $developerName
Contact: $developerEmail
Website: $developerWebsite
Support: $supportEmail

Platform Requirements:
- Flutter: $minFlutterVersion+
- Android: API $minAndroidVersion+
- iOS: $minIOSVersion+

API Configuration:
- Base URL: $apiBaseUrl
- Version: $apiVersion
- Timeout: ${apiTimeoutSeconds}s
- Max Retries: $maxRetryAttempts

Cache Configuration:
- Max Size: ${(maxCacheSize / (1024 * 1024)).toStringAsFixed(1)}MB
- Expiration: ${cacheExpiration.inDays} days
- Image Cache: ${imageCacheExpiration.inDays} days

UI Configuration:
- Animation Duration: ${defaultAnimationDuration}ms
- Debounce Delay: ${defaultDebounceDelay}ms
- Max Image Size: ${(maxImageSize / (1024 * 1024)).toStringAsFixed(1)}MB
- Max File Size: ${(maxFileSize / (1024 * 1024)).toStringAsFixed(1)}MB

Legal:
- Privacy Policy: $privacyPolicyUrl
- Terms of Service: $termsOfServiceUrl
- License: $licenseUrl

Social Media:
- Twitter: $twitterHandle
- Instagram: $instagramHandle
- Facebook: $facebookPage

$copyright
''';
}