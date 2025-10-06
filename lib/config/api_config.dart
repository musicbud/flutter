/// API Configuration
import 'package:flutter/foundation.dart';

class ApiConfig {
  // Base URLs
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://84.235.170.234:8000',
  );

  static const String wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'ws://84.235.170.234',
  );

  // API Version
  static const String apiVersion = 'v1';

  // Full API URL
  static String get apiUrl => baseUrl;

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

  // API Endpoints

  // Auth Endpoints (working from commit 6cac314)
  static String get login => '$apiUrl/login/';
  static String get register => '$apiUrl/register/';
  static String get refreshToken => '$apiUrl/token/refresh/';
  static String get logout => '$apiUrl/logout/';
  static String get serviceLogin => '$apiUrl/service/login';
  static String get spotifyConnect => '$apiUrl/spotify/connect';
  static String get spotifyCallback => '$apiUrl/spotify/callback';
  static String get ytmusicConnect => '$apiUrl/ytmusic/connect';
  static String get ytmusicCallback => '$apiUrl/ytmusic/callback';
  static String get lastfmConnect => '$apiUrl/lastfm/connect';
  static String get lastfmCallback => '$apiUrl/lastfm/callback';
  static String get malConnect => '$apiUrl/mal/connect';
  static String get malCallback => '$apiUrl/mal/callback';
  static String get spotifyRefreshToken => '$apiUrl/spotify/token/refresh';
  static String get ytmusicRefreshToken => '$apiUrl/ytmusic/token/refresh';

  // Bud matching endpoints (working from commit 6cac314)
  static String get budLikedArtists => '$apiUrl/bud/liked/artists';
  static String get budLikedTracks => '$apiUrl/bud/liked/tracks';
  static String get budLikedGenres => '$apiUrl/bud/liked/genres';
  static String get budLikedAlbums => '$apiUrl/bud/liked/albums';
  static String get budLikedAio => '$apiUrl/bud/liked/aio';
  static String get budTopArtists => '$apiUrl/bud/top/artists';
  static String get budTopTracks => '$apiUrl/bud/top/tracks';
  static String get budTopGenres => '$apiUrl/bud/top/genres';
  static String get budTopAnime => '$apiUrl/bud/top/anime';
  static String get budTopManga => '$apiUrl/bud/top/manga';
  static String get budPlayedTracks => '$apiUrl/bud/played/tracks';
  static String get budArtist => '$apiUrl/bud/artist';
  static String get budTrack => '$apiUrl/bud/track';
  static String get budGenre => '$apiUrl/bud/genre';
  static String get budAlbum => '$apiUrl/bud/album';
  static String get budSearch => '$apiUrl/bud/search';
  static String get budCommonLikedArtists => '$apiUrl/bud/common/liked/artists';
  static String get budCommonLikedTracks => '$apiUrl/bud/common/liked/tracks';
  static String get budCommonLikedGenres => '$apiUrl/bud/common/liked/genres';
  static String get budCommonLikedAlbums => '$apiUrl/bud/common/liked/albums';
  static String get budCommonPlayedTracks => '$apiUrl/bud/common/played/tracks';
  static String get budCommonTopArtists => '$apiUrl/bud/common/top/artists';
  static String get budCommonTopTracks => '$apiUrl/bud/common/top/tracks';
  static String get budCommonTopGenres => '$apiUrl/bud/common/top/genres';
  static String get budCommonTopAnime => '$apiUrl/bud/common/top/anime';
  static String get budCommonTopManga => '$apiUrl/bud/common/top/manga';

  // Channel Endpoints
  static String get channels => '$apiUrl/channels';
  static String channelById(String id) => '$apiUrl/channels/$id';
  static String channelMessages(String id) => '$apiUrl/channels/$id/messages';
  static String channelMembers(String id) => '$apiUrl/channels/$id/members';
  static String channelSettings(String id) => '$apiUrl/channels/$id/settings';
  static String channelStats(String id) => '$apiUrl/channels/$id/stats';

  // Chat endpoints (working from commit 6cac314)
  static String get chatHome => '$apiUrl/chat/';
  static String get chatUsers => '$apiUrl/chat/users/';
  static String get chatChannels => '$apiUrl/chat/channels/';
  static String get chatUserChat => '$apiUrl/chat/user_chat/';
  static String chatUserChatByUsername(String username) => '$apiUrl/chat/chat/';
  static String chatChannelChat(String channelId) => '$apiUrl/chat/channel/';
  static String get chatSendMessage => '$apiUrl/chat/send_message/';
  static String get chatCreateChannel => '$apiUrl/chat/create_channel/';
  static String chatChannelDashboard(String channelId) => '$apiUrl/chat/channel/';
  static String get chatAddChannelMember => '$apiUrl/chat/add_channel_member/';
  static String get chatAcceptUserInvitation => '$apiUrl/chat/channel/';
  static String get chatKickUser => '$apiUrl/chat/channel/';
  static String get chatBlockUser => '$apiUrl/chat/channel/';
  static String get chatAddModerator => '$apiUrl/chat/channel/';
  static String get chatDeleteMessage => '$apiUrl/chat/delete_message/';
  static String get chatHandleInvitation => '$apiUrl/chat/handle_invitation/';

  // Additional chat endpoints for comprehensive chat (working from commit 6cac314)
  static String get chatGetChannels => '$apiUrl/chat/channels/';
  static String get chatGetChannelMessages => '$apiUrl/chat/channel/messages/';
  static String get chatSendChannelMessage => '$apiUrl/chat/channel/send_message/';
  static String get chatSendUserMessage => '$apiUrl/chat/user/send_message/';
  static String get chatGetChannelUsers => '$apiUrl/chat/channel/users/';
  static String get chatJoinChannel => '$apiUrl/chat/channel/join/';
  static String get chatLeaveChannel => '$apiUrl/chat/channel/leave/';
  static String get chatRequestJoin => '$apiUrl/chat/channel/request_join/';
  static String channelDetails(String channelId) => '$apiUrl/chat/channel/details/';


  // Service disconnect endpoints (working from commit 6cac314)
  static String get spotifyDisconnect => '$apiUrl/spotify/disconnect/';
  static String get lastfmDisconnect => '$apiUrl/lastfm/disconnect/';
  static String get ytmusicDisconnect => '$apiUrl/ytmusic/disconnect/';
  static String get malDisconnect => '$apiUrl/mal/disconnect/';

  // Content Endpoints
  static String get content => '$apiUrl/content';
  static String get tracks => '$apiUrl/content/tracks';
  static String get artists => '$apiUrl/content/artists';
  static String get albums => '$apiUrl/content/albums';
  static String get playlists => '$apiUrl/content/playlists';
  static String get genres => '$apiUrl/content/genres';

  // User Endpoints (working from commit 6cac314)
  static String get myProfile => '$apiUrl/me/profile';
  static String get budProfile => '$apiUrl/bud/profile';
  static String get updateProfile => '$apiUrl/me/profile/set';
  static String get updateLikes => '$apiUrl/me/likes/update';
  static String get myLikedArtists => '$apiUrl/me/liked/artists';
  static String get myLikedTracks => '$apiUrl/me/liked/tracks';
  static String get myLikedGenres => '$apiUrl/me/liked/genres';
  static String get myLikedAlbums => '$apiUrl/me/liked/albums';
  static String get myTopArtists => '$apiUrl/me/top/artists';
  static String get myTopTracks => '$apiUrl/me/top/tracks';
  static String get myTopGenres => '$apiUrl/me/top/genres';
  static String get myTopAnime => '$apiUrl/me/top/anime';
  static String get myTopManga => '$apiUrl/me/top/manga';
  static String get myPlayedTracks => '$apiUrl/me/played/tracks';
  static String userById(String id) => '$apiUrl/users/$id';

  // Search Endpoints
  static String get search => '$apiUrl/search';
  static String get searchSuggestions => '$apiUrl/search/suggestions';
  static String get searchRecent => '$apiUrl/search/recent';
  static String get searchTrending => '$apiUrl/search/trending';

  // Library Endpoints
  static String get library => '$apiUrl/library';
  static String get libraryPlaylists => '$apiUrl/library/playlists';
  static String get libraryLiked => '$apiUrl/library/liked';
  static String get libraryDownloads => '$apiUrl/library/downloads';
  static String get libraryRecent => '$apiUrl/library/recent';

  // Event Endpoints
  static String get events => '$apiUrl/events';
  static String eventById(String id) => '$apiUrl/events/$id';

  // Analytics Endpoints
  static String get analytics => '$apiUrl/analytics';
  static String get analyticsStats => '$apiUrl/analytics/stats';

  // Admin & Utility endpoints (working from commit 6cac314)
  static String get admin => '$apiUrl/admin/';
  static String get spotifySeedUserCreate => '$apiUrl/spotify/seed/user/create';
  static String get mergeSimilars => '$apiUrl/merge-similars';
  static String get usersWeb => '$apiUrl/users/';
  static String get channelsWeb => '$apiUrl/channels/';

  // Private constructor to prevent instantiation
  ApiConfig._();

  // Debug method to validate configuration
  static void logConfiguration() {
    debugPrint('🔧 API Configuration Debug Info:');
    debugPrint('Base URL: $baseUrl');
    debugPrint('WS URL: $wsUrl');
    debugPrint('Configuration loaded successfully');
  }
}
