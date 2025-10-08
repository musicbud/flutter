/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:8000/';
  static const String apiVersion = 'v1';
  
  // App Information
  static const String appName = 'MusicBud';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Timeouts (in seconds)
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  
  // Cache
  static const int cacheMaxAge = 3600; // 1 hour in seconds
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';
  
  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  
  // Social Media
  static const String twitterHandle = '@musicbud';
  static const String instagramHandle = '@musicbud';
  
  // Support
  static const String supportEmail = 'support@musicbud.com';
  static const String privacyPolicyUrl = 'https://musicbud.com/privacy';
  static const String termsOfServiceUrl = 'https://musicbud.com/terms';
  
  // Limits
  static const int maxBioLength = 500;
  static const int maxUsernameLength = 30;
  static const int minPasswordLength = 8;
  
  // File Upload
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];

  // Channel Types
  static const String channelTypePublic = 'public';
  static const String channelTypePrivate = 'private';
  static const String channelTypeDirect = 'direct';

  // Channel Roles (hierarchical: owner > admin > moderator > member)
  static const String channelRoleOwner = 'owner';
  static const String channelRoleAdmin = 'admin';
  static const String channelRoleModerator = 'moderator';
  static const String channelRoleMember = 'member';

  // Private constructor to prevent instantiation
  AppConstants._();
}
