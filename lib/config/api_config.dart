import 'package:flutter/foundation.dart';
import '../services/endpoint_config_service.dart';

/// API Configuration
class ApiConfig {
  // Base URLs - Updated to match backend
  static const String baseUrl = 'http://localhost:8000';

  static const String wsBaseUrl = 'ws://localhost:8000';

  // API Version
  static const String apiVersion = 'v1';

  // Full API URL
  static String get apiUrl => '$baseUrl/v1';

  // WebSocket URL
  static String get wsUrl => '$wsBaseUrl/ws/$apiVersion';

  // Timeouts (in seconds)
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // Retry Configuration
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // milliseconds

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const int cacheMaxAge = 3600; // 1 hour in seconds
  static const int cacheMaxSize = 50 * 1024 * 1024; // 50 MB

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5 MB

  // Rate Limiting
  static const int maxRequestsPerMinute = 60;

  // Feature Flags
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_API_LOGGING',
    defaultValue: true,
  );

  static const bool enableCaching = bool.fromEnvironment(
    'ENABLE_API_CACHING',
    defaultValue: true,
  );

  // Headers
  static const String authHeaderKey = 'Authorization';
  static const String contentTypeKey = 'Content-Type';
  static const String acceptKey = 'Accept';
  static const String userAgentKey = 'User-Agent';

  // Content Types
  static const String jsonContentType = 'application/json';
  static const String formDataContentType = 'multipart/form-data';

  // API Endpoints - Updated to match FastAPI v1 structure

  // Auth Endpoints
  static String get login => '$apiUrl/auth/login/json';
  static String get register => '$apiUrl/auth/register';
  static String get refreshToken => '$apiUrl/auth/refresh';
  static String get logout => '$apiUrl/auth/logout';
  static String get serviceLogin => '$apiUrl/service/login/';
  static String get spotifyConnect => '$apiUrl/spotify/connect/';
  static String get spotifyCallback => '$apiUrl/spotify/callback/';
  static String get ytmusicConnect => '$apiUrl/ytmusic/connect/';
  static String get ytmusicCallback => '$apiUrl/ytmusic/callback/';
  static String get lastfmConnect => '$apiUrl/lastfm/connect/';
  static String get lastfmCallback => '$apiUrl/lastfm/callback/';
  static String get malConnect => '$apiUrl/mal/connect/';
  static String get malCallback => '$apiUrl/mal/callback/';
  static String get spotifyRefreshToken => '$apiUrl/spotify/token/refresh/';
  static String get ytmusicRefreshToken => '$apiUrl/ytmusic/token/refresh/';

  // Bud matching endpoints (from Postman collection)
  static String get budProfile => '$apiUrl/bud/profile/';
  static String get budLikedArtists => '$apiUrl/bud/liked/artists/';
  static String get budLikedTracks => '$apiUrl/bud/liked/tracks/';
  static String get budLikedGenres => '$apiUrl/bud/liked/genres/';
  static String get budLikedAlbums => '$apiUrl/bud/liked/albums/';
  static String get budLikedAio => '$apiUrl/bud/liked/aio/';
  static String get budTopArtists => '$apiUrl/bud/top/artists/';
  static String get budTopTracks => '$apiUrl/bud/top/tracks/';
  static String get budTopGenres => '$apiUrl/bud/top/genres/';
  static String get budTopAnime => '$apiUrl/bud/top/anime/';
  static String get budTopManga => '$apiUrl/bud/top/manga/';
  static String get budPlayedTracks => '$apiUrl/bud/played/tracks/';
  static String get budArtist => '$apiUrl/bud/artist/';
  static String get budTrack => '$apiUrl/bud/track/';
  static String get budGenre => '$apiUrl/bud/genre/';
  static String get budAlbum => '$apiUrl/bud/album/';
  static String get budSearch => '$apiUrl/bud/search/';
  static String get play => '$apiUrl/play/';
  static String get budCommonLikedArtists =>
      '$apiUrl/bud/common/liked/artists/';
  static String get budCommonLikedTracks => '$apiUrl/bud/common/liked/tracks/';
  static String get budCommonLikedGenres => '$apiUrl/bud/common/liked/genres/';
  static String get budCommonLikedAlbums => '$apiUrl/bud/common/liked/albums/';
  static String get budCommonPlayedTracks =>
      '$apiUrl/bud/common/played/tracks/';
  static String get budCommonTopArtists => '$apiUrl/bud/common/top/artists/';
  static String get budCommonTopTracks => '$apiUrl/bud/common/top/tracks/';
  static String get budCommonTopGenres => '$apiUrl/bud/common/top/genres/';
  static String get budCommonTopAnime => '$apiUrl/bud/common/top/anime/';
  static String get budCommonTopManga => '$apiUrl/bud/common/top/manga/';

  // Channel Endpoints
  static String get channels => '$apiUrl/channels/';
  static String channelById(String id) => '$apiUrl/channels/$id/';
  static String channelMessages(String id) => '$apiUrl/channels/$id/messages/';
  static String channelMembers(String id) => '$apiUrl/channels/$id/members/';
  static String channelSettings(String id) => '$apiUrl/channels/$id/settings/';
  static String channelStats(String id) => '$apiUrl/channels/$id/stats/';

  // Chat endpoints - Updated to FastAPI v1
  static String get chatHome => '$apiUrl/chat';
  static String get chatUsers => '$apiUrl/chat/users';
  static String get chatChannels => '$apiUrl/chat/channels';
  static String get chatMessages => '$apiUrl/chat/messages';
  static String chatUserMessages(String userId) =>
      '$apiUrl/chat/users/$userId/messages';
  static String chatChannelMessages(String channelId) =>
      '$apiUrl/chat/channels/$channelId/messages';
  static String get chatSendMessage => '$apiUrl/chat/messages';
  static String get chatCreateChannel => '$apiUrl/chat/channels';
  static String chatChannelById(String channelId) =>
      '$apiUrl/chat/channels/$channelId';
  static String chatChannelMembers(String channelId) =>
      '$apiUrl/chat/channels/$channelId/members';

  // Legacy chat endpoints (for compatibility)
  static String get chatUserChat =>
      '$apiUrl/chat/messages'; // Will be deprecated
  static String chatUserChatByUsername(String username) =>
      '$apiUrl/chat/messages'; // Will be deprecated
  static String chatChannelChat(String channelId) =>
      '$apiUrl/chat/channels/$channelId/messages'; // Will be deprecated
  static String chatChannelDashboard(String channelId) =>
      '$apiUrl/chat/channels/$channelId'; // Will be deprecated
  static String get chatAddChannelMember =>
      '$apiUrl/chat/channels/members'; // Will be deprecated
  static String get chatAcceptUserInvitation =>
      '$apiUrl/chat/channels/members'; // Will be deprecated
  static String get chatKickUser =>
      '$apiUrl/chat/channels/members'; // Will be deprecated
  static String get chatBlockUser =>
      '$apiUrl/chat/channels/members'; // Will be deprecated
  static String get chatAddModerator =>
      '$apiUrl/chat/channels/members'; // Will be deprecated
  static String get chatDeleteMessage =>
      '$apiUrl/chat/messages'; // Will be deprecated
  static String get chatHandleInvitation =>
      '$apiUrl/chat/channels/members'; // Will be deprecated

  // Additional chat endpoints for comprehensive chat (working from commit 6cac314)
  static String get chatGetChannels => '$apiUrl/chat/channels/';
  static String get chatGetChannelMessages => '$apiUrl/chat/channel/messages/';
  static String get chatSendChannelMessage =>
      '$apiUrl/chat/channel/send_message/';
  static String get chatSendUserMessage => '$apiUrl/chat/user/send_message/';
  static String get chatGetChannelUsers => '$apiUrl/chat/channel/users/';
  static String get chatJoinChannel => '$apiUrl/chat/channel/join/';
  static String get chatLeaveChannel => '$apiUrl/chat/channel/leave/';
  static String get chatRequestJoin => '$apiUrl/chat/channel/request_join/';
  static String channelDetails(String channelId) =>
      '$apiUrl/chat/channel/details/';

  // Service disconnect endpoints (working from commit 6cac314)
  static String get spotifyDisconnect => '$apiUrl/spotify/disconnect/';
  static String get lastfmDisconnect => '$apiUrl/lastfm/disconnect/';
  static String get ytmusicDisconnect => '$apiUrl/ytmusic/disconnect/';
  static String get malDisconnect => '$apiUrl/mal/disconnect/';

  // Content Endpoints
  static String get content => '$apiUrl/content/';
  static String get tracks => '$apiUrl/content/tracks/';
  static String get artists => '$apiUrl/content/artists/';
  static String get albums => '$apiUrl/content/albums/';
  static String get playlists => '$apiUrl/content/playlists/';
  static String get genres => '$apiUrl/content/genres/';

  // Public Discovery Endpoints - Updated to FastAPI v1
  static String get discoverGenres => '$apiUrl/public/discover/genres';
  static String get discoverArtists => '$apiUrl/public/discover/artists';
  static String get discoverTracks => '$apiUrl/public/discover/tracks';
  static String get discoverMovies => '$apiUrl/public/discover/movies';
  static String get discoverAnime => '$apiUrl/public/discover/anime';
  static String get discoverManga => '$apiUrl/public/discover/manga';
  static String get publicHealth => '$apiUrl/public/health';

  // Legacy discovery endpoints (for compatibility)
  static String get featuredArtists =>
      '$apiUrl/public/discover/artists'; // Will be deprecated
  static String get trendingTracks =>
      '$apiUrl/public/discover/tracks'; // Will be deprecated
  static String get newReleases =>
      '$apiUrl/public/discover/tracks'; // Will be deprecated
  static String get discoverActions =>
      '$apiUrl/public/discover/tracks'; // Will be deprecated
  static String get discoverCategories =>
      '$apiUrl/public/discover/genres'; // Will be deprecated

  // User Endpoints - Updated to FastAPI v1 structure
  static String get myProfile => '$apiUrl/users/profile';
  static String get updateProfile => '$apiUrl/users/profile';
  static String get myPreferences => '$apiUrl/users/preferences';
  static String get updatePreferences => '$apiUrl/users/preferences';
  static String get myMatchingPreferences =>
      '$apiUrl/users/matching/preferences';
  static String get updateMatchingPreferences =>
      '$apiUrl/users/matching/preferences';

  // Settings Endpoints
  static String get privacySettings => '$apiUrl/users/settings/privacy';
  static String get notificationSettings =>
      '$apiUrl/users/settings/notifications';
  static String get appSettings => '$apiUrl/users/settings/app';

  // User Stats and Activity
  static String get userStats => '$apiUrl/users/stats';
  static String get recentActivity => '$apiUrl/users/activity/recent';

  // Legacy compatibility (for gradual migration)
  static String get updateLikes =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String get myLikedArtists =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String get myLikedTracks =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String get myLikedGenres =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String get myLikedAlbums =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String get myTopArtists =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String get myTopTracks =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String get myTopGenres =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String get myTopAnime =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String get myTopManga =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String get myPlayedTracks =>
      '$apiUrl/users/preferences'; // Will be deprecated
  static String userById(String id) => '$apiUrl/users/profile/$id';

  // Search Endpoints
  static String get search => '$apiUrl/search/';
  static String get searchSuggestions => '$apiUrl/search/suggestions/';
  static String get searchRecent => '$apiUrl/search/recent/';
  static String get searchTrending => '$apiUrl/search/trending/';

  // Library Endpoints
  static String get library => '$apiUrl/library/';
  static String get libraryPlaylists => '$apiUrl/library/playlists/';
  static String get libraryLiked => '$apiUrl/library/liked/';
  static String get libraryDownloads => '$apiUrl/library/downloads/';
  static String get libraryRecent => '$apiUrl/library/recent/';

  // Event Endpoints
  static String get events => '$apiUrl/events/';
  static String eventById(String id) => '$apiUrl/events/$id/';

  // Analytics Endpoints
  static String get analytics => '$apiUrl/analytics/';
  static String get analyticsStats => '$apiUrl/analytics/stats/';

  // Admin & Utility endpoints (working from commit 6cac314)
  static String get admin => '$apiUrl/admin/';
  static String get spotifySeedUserCreate =>
      '$apiUrl/spotify/seed/user/create/';
  static String get mergeSimilars => '$apiUrl/merge-similars/';
  static String get usersWeb => '$apiUrl/users/';
  static String get channelsWeb => '$apiUrl/channels/';

  // Health endpoint
  static String get health => '$apiUrl/health/';

  // Private constructor to prevent instantiation
  ApiConfig._();

  // Debug method to validate configuration
  static void logConfiguration() {
    debugPrint('🔧 API Configuration Debug Info:');
    debugPrint('Base URL: $baseUrl');
    debugPrint('WS URL: $wsUrl');
    debugPrint('Configuration loaded successfully');
  }

  /// Gets a dynamic endpoint URL by name using the provided service
  static String? getDynamicEndpointUrl(
    EndpointConfigService service,
    String endpointName,
  ) {
    return service.getEndpointUrl(endpointName, baseUrl);
  }

  /// Gets dynamic endpoint information (method and URL) by name
  static Map<String, String>? getDynamicEndpointInfo(
    EndpointConfigService service,
    String endpointName,
  ) {
    return service.getEndpointInfo(endpointName, baseUrl);
  }
}
