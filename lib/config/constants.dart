class ApiConstants {
  static const String baseUrl = 'http://localhost:8000/v1';
  
  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String userPreferences = '/user/preferences';
  
  // Music endpoints
  static const String tracks = '/music/tracks';
  static const String playlists = '/music/playlists';
  static const String artists = '/music/artists';
  static const String albums = '/music/albums';
  
  // Social endpoints
  static const String friends = '/social/friends';
  static const String recommendations = '/social/recommendations';
  static const String chat = '/social/chat';
  static const String messages = '/social/messages';
  
  // Channel endpoints
  static const String channels = '/channels';
  static const String channelSettings = '/channels/settings';
  static const String channelStats = '/channels/stats';
  
  // Analytics endpoints
  static const String analytics = '/analytics';
  static const String userStats = '/analytics/user';
  static const String systemStats = '/analytics/system';
  
  // Search endpoints
  static const String search = '/search';
  static const String searchUsers = '/search/users';
  static const String searchMusic = '/search/music';
  static const String searchPlaylists = '/search/playlists';
  
  // Admin endpoints
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminStats = '/admin/stats';
}
