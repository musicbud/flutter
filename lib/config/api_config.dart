/// API Configuration
class ApiConfig {
  // Base URLs
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static const String wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'ws://84.235.170.234/',
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

  // Auth Endpoints
  static String get login => '$apiUrl/login/';
  static String get register => '$apiUrl/register/';
  static String get refreshToken => '$apiUrl/token/refresh/';
  static String get logout => '$apiUrl/logout/';
  static String get serviceLogin => '$apiUrl/auth/service';
  static String get spotifyConnect => '$apiUrl/auth/spotify/connect';
  static String get ytmusicConnect => '$apiUrl/auth/ytmusic/connect';
  static String get lastfmConnect => '$apiUrl/auth/lastfm/connect';
  static String get malConnect => '$apiUrl/auth/mal/connect';
  static String get spotifyRefreshToken => '$apiUrl/auth/spotify/refresh';
  static String get ytmusicRefreshToken => '$apiUrl/auth/ytmusic/refresh';

  // Bud Matching Endpoints
  static String get budSearch => '$apiUrl/buds/search';
  static String get budProfile => '$apiUrl/buds/profile';
  static String get budLikedArtists => '$apiUrl/buds/liked/artists';
  static String get budLikedTracks => '$apiUrl/buds/liked/tracks';
  static String get budLikedGenres => '$apiUrl/buds/liked/genres';
  static String get budLikedAlbums => '$apiUrl/buds/liked/albums';
  static String get budTopArtists => '$apiUrl/buds/top/artists';
  static String get budTopTracks => '$apiUrl/buds/top/tracks';
  static String get budTopGenres => '$apiUrl/buds/top/genres';
  static String get budTopAnime => '$apiUrl/buds/top/anime';
  static String get budTopManga => '$apiUrl/buds/top/manga';
  static String get budPlayedTracks => '$apiUrl/buds/played/tracks';
  static String get budCommonArtists => '$apiUrl/buds/common/artists';
  static String get budCommonTracks => '$apiUrl/buds/common/tracks';
  static String get budCommonGenres => '$apiUrl/buds/common/genres';
  static String get budCommonLikedArtists => '$apiUrl/buds/common/liked/artists';
  static String get budCommonLikedTracks => '$apiUrl/buds/common/liked/tracks';
  static String get budCommonLikedGenres => '$apiUrl/buds/common/liked/genres';
  static String get budCommonLikedAlbums => '$apiUrl/buds/common/liked/albums';
  static String get budCommonTopArtists => '$apiUrl/buds/common/top/artists';
  static String get budCommonTopTracks => '$apiUrl/buds/common/top/tracks';
  static String get budCommonTopGenres => '$apiUrl/buds/common/top/genres';
  static String get budCommonTopAnime => '$apiUrl/buds/common/top/anime';
  static String get budCommonTopManga => '$apiUrl/buds/common/top/manga';
  static String get budCommonPlayedTracks => '$apiUrl/buds/common/played/tracks';
  static String get budArtist => '$apiUrl/buds/artist';
  static String get budTrack => '$apiUrl/buds/track';
  static String get budGenre => '$apiUrl/buds/genre';
  static String get budAlbum => '$apiUrl/buds/album';
  static String get budMatch => '$apiUrl/buds/match';
  static String get budUnmatch => '$apiUrl/buds/unmatch';
  static String get budBlock => '$apiUrl/buds/block';
  static String get budReport => '$apiUrl/buds/report';

  // Channel Endpoints
  static String get channels => '$apiUrl/channels';
  static String channelById(String id) => '$apiUrl/channels/$id';
  static String channelMessages(String id) => '$apiUrl/channels/$id/messages';
  static String channelMembers(String id) => '$apiUrl/channels/$id/members';
  static String channelSettings(String id) => '$apiUrl/channels/$id/settings';
  static String channelStats(String id) => '$apiUrl/channels/$id/stats';

  // Chat Endpoints
  static String get chats => '$apiUrl/chats';
  static String get chatHome => '$apiUrl/chats/home';
  static String get chatUsers => '$apiUrl/chats/users';
  static String get chatChannels => '$apiUrl/channels';
  static String get chatUserChat => '$apiUrl/chats/users/';
  static String get chatAddChannelMember => '$apiUrl/chats/channels/';
  static String get chatAcceptUserInvitation => '$apiUrl/chats/channels/';
  static String get chatKickUser => '$apiUrl/chats/channels/';
  static String get chatBlockUser => '$apiUrl/chats/channels/';
  static String get chatAddModerator => '$apiUrl/chats/channels/';
  static String get chatDeleteMessage => '$apiUrl/chats/channels/';
  static String get chatHandleInvitation => '$apiUrl/chats/channels/';
  static String chatById(String id) => '$apiUrl/chats/$id';
  static String chatMessages(String id) => '$apiUrl/chats/$id/messages';
  static String chatUserChatByUsername(String username) => '$apiUrl/chats/users/$username';
  static String chatChannelChat(String channelId) => '$apiUrl/chats/channels/$channelId';
  static String get chatSendMessage => '$apiUrl/chats/send';
  static String get chatCreateChannel => '$apiUrl/chats/create';
  static String chatChannelDashboard(String channelId) => '$apiUrl/chats/channels/$channelId/dashboard';

  // Additional Chat Endpoints (matching backend)
  static String get chatGetChannels => '$apiUrl/chat/channels/';
  static String chatGetChannelMessages(String channelName) => '$apiUrl/chat/channel/$channelName/';
  static String get chatSendChannelMessage => '$apiUrl/chat/send_message/';
  static String chatSendUserMessage(String userId) => '$apiUrl/chat/user_chat/$userId/';
  static String get chatGetChannelUsers => '$apiUrl/chat/users/';
  static String chatJoinChannel(int channelId) => '$apiUrl/chat/add_channel_member/$channelId/';
  static String chatLeaveChannel(int channelId) => '$apiUrl/chat/handle_invitation/$channelId/';
  static String get chatRequestJoin => '$apiUrl/chat/create_channel/';
  static String channelDetails(String channelId) => '$apiUrl/chat/channel/$channelId/dashboard/';
  static String channelDashboard(String channelId) => '$apiUrl/chat/channel/$channelId/dashboard/';
  static String userProfile(String userId) => '$apiUrl/users/$userId';

  // Service Disconnect Endpoints
  static String get spotifyDisconnect => '$apiUrl/auth/spotify/disconnect';
  static String get lastfmDisconnect => '$apiUrl/auth/lastfm/disconnect';
  static String get ytmusicDisconnect => '$apiUrl/auth/ytmusic/disconnect';
  static String get malDisconnect => '$apiUrl/auth/mal/disconnect';

  // Content Endpoints
  static String get content => '$apiUrl/content';
  static String get tracks => '$apiUrl/content/tracks';
  static String get artists => '$apiUrl/content/artists';
  static String get albums => '$apiUrl/content/albums';
  static String get playlists => '$apiUrl/content/playlists';
  static String get genres => '$apiUrl/content/genres';

  // User Endpoints (corrected to match backend URLs)
  static String get users => '$apiUrl/users';
  static String get profile => '$apiUrl/users/profile';
  static String get myProfile => '$apiUrl/me/profile';
  static String get myLikedTracks => '$apiUrl/me/liked/tracks';
  static String get myLikedArtists => '$apiUrl/me/liked/artists';
  static String get myLikedGenres => '$apiUrl/me/liked/genres';
  static String get myLikedAlbums => '$apiUrl/me/liked/albums';
  static String get myTopTracks => '$apiUrl/me/top/tracks';
  static String get myTopArtists => '$apiUrl/me/top/artists';
  static String get myTopGenres => '$apiUrl/me/top/genres';
  static String get myTopAnime => '$apiUrl/me/top/anime';
  static String get myTopManga => '$apiUrl/me/top/manga';
  static String get myPlayedTracks => '$apiUrl/me/played/tracks';
  static String get myLikedTracksPost => '$apiUrl/me/liked/tracks';
  static String get myLikedArtistsPost => '$apiUrl/me/liked/artists';
  static String get myLikedGenresPost => '$apiUrl/me/liked/genres';
  static String get myLikedAlbumsPost => '$apiUrl/me/liked/albums';
  static String get myTopTracksPost => '$apiUrl/me/top/tracks';
  static String get myTopArtistsPost => '$apiUrl/me/top/artists';
  static String get myTopGenresPost => '$apiUrl/me/top/genres';
  static String get myPlayedTracksPost => '$apiUrl/me/played/tracks';
  static String get updateProfile => '$apiUrl/me/profile/set';
  static String get updateLikes => '$apiUrl/me/likes/update';
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

  // Admin Endpoints
  static String get admin => '$apiUrl/admin';
  static String get adminStats => '$apiUrl/admin/stats';
  static String get adminUsers => '$apiUrl/admin/users';
  static String get adminContent => '$apiUrl/admin/content';

  // Private constructor to prevent instantiation
  ApiConfig._();
}
