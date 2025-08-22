class ApiConfig {
  // Base URL - matches the backend repository structure
  static const String baseUrl = 'http://84.235.170.234';

  // Full API base URL (no versioning based on backend logs)
  static const String fullBaseUrl = baseUrl;

  // API Version (kept for compatibility)
  static const String apiVersion = 'v1';

  // Timeouts
  static const int connectTimeout = 5000; // milliseconds
  static const int receiveTimeout = 3000; // milliseconds

  // Default headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Authentication endpoints
  static const String login = '/login/';
  static const String register = '/register/';
  static const String refreshToken = '/token/refresh/';
  static const String logout = '/logout/';

  // Profile endpoints
  static const String myProfile = '/me/profile';
  static const String budProfile = '/bud/profile';
  static const String updateProfile = '/me/profile/set';
  static const String updateLikes = '/me/likes/update';

  // User's content endpoints (all require JWT authentication)
  static const String myLikedArtists = '/me/liked/artists';
  static const String myLikedTracks = '/me/liked/tracks';
  static const String myLikedGenres = '/me/liked/genres';
  static const String myLikedAlbums = '/me/liked/albums';
  static const String myTopArtists = '/me/top/artists';
  static const String myTopTracks = '/me/top/tracks';
  static const String myTopGenres = '/me/top/genres';
  static const String myTopAnime = '/me/top/anime';
  static const String myTopManga = '/me/top/manga';
  static const String myPlayedTracks = '/me/played/tracks';

  // Service connection endpoints (all require JWT authentication)
  static const String serviceLogin = '/service/login';
  static const String spotifyConnect = '/spotify/connect';
  static const String spotifyCallback = '/spotify/callback';
  static const String ytmusicConnect = '/ytmusic/connect';
  static const String ytmusicCallback = '/ytmusic/callback';
  static const String lastfmConnect = '/lastfm/connect';
  static const String lastfmCallback = '/lastfm/callback';
  static const String malConnect = '/mal/connect';
  static const String malCallback = '/mal/callback';
  static const String spotifyRefreshToken = '/spotify/token/refresh';
  static const String ytmusicRefreshToken = '/ytmusic/token/refresh';

  // Bud matching endpoints (all require JWT authentication)
  static const String budLikedArtists = '/bud/liked/artists';
  static const String budLikedTracks = '/bud/liked/tracks';
  static const String budLikedGenres = '/bud/liked/genres';
  static const String budLikedAlbums = '/bud/liked/albums';
  static const String budLikedAio = '/bud/liked/aio';
  static const String budTopArtists = '/bud/top/artists';
  static const String budTopTracks = '/bud/top/tracks';
  static const String budTopGenres = '/bud/top/genres';
  static const String budTopAnime = '/bud/top/anime';
  static const String budTopManga = '/bud/top/manga';
  static const String budPlayedTracks = '/bud/played/tracks';
  static const String budArtist = '/bud/artist';
  static const String budTrack = '/bud/track';
  static const String budGenre = '/bud/genre';
  static const String budAlbum = '/bud/album';
  static const String budSearch = '/bud/search';

  // Bud common content endpoints (all require JWT authentication)
  static const String budCommonLikedArtists = '/bud/common/liked/artists';
  static const String budCommonLikedTracks = '/bud/common/liked/tracks';
  static const String budCommonLikedGenres = '/bud/common/liked/genres';
  static const String budCommonLikedAlbums = '/bud/common/liked/albums';
  static const String budCommonPlayedTracks = '/bud/common/played/tracks';
  static const String budCommonTopArtists = '/bud/common/top/artists';
  static const String budCommonTopTracks = '/bud/common/top/tracks';
  static const String budCommonTopGenres = '/bud/common/top/genres';
  static const String budCommonTopAnime = '/bud/common/top/anime';
  static const String budCommonTopManga = '/bud/common/top/manga';

  // Chat endpoints (all require login authentication)
  static const String chatHome = '/chat/';
  static const String chatUsers = '/chat/users/';
  static const String chatChannels = '/chat/channels/';
  static const String chatUserChat = '/chat/user_chat/';
  static const String chatUserChatByUsername = '/chat/chat/';
  static const String chatChannelChat = '/chat/channel/';
  static const String chatSendMessage = '/chat/send_message/';
  static const String chatCreateChannel = '/chat/create_channel/';
  static const String chatChannelDashboard = '/chat/channel/';
  static const String chatAddChannelMember = '/chat/add_channel_member/';
  static const String chatAcceptUserInvitation = '/chat/channel/';
  static const String chatKickUser = '/chat/channel/';
  static const String chatBlockUser = '/chat/channel/';
  static const String chatAddModerator = '/chat/channel/';
  static const String chatDeleteMessage = '/chat/delete_message/';
  static const String chatHandleInvitation = '/chat/handle_invitation/';

  // Additional chat endpoints for comprehensive chat
  static const String chatGetChannels = '/chat/channels/';
  static const String chatGetChannelMessages = '/chat/channel/messages/';
  static const String chatSendChannelMessage = '/chat/channel/send_message/';
  static const String chatSendUserMessage = '/chat/user/send_message/';
  static const String chatGetChannelUsers = '/chat/channel/users/';
  static const String chatJoinChannel = '/chat/channel/join/';
  static const String chatLeaveChannel = '/chat/channel/leave/';
  static const String chatRequestJoin = '/chat/channel/request_join/';
  static const String channelDetails = '/chat/channel/details/';

  // Additional endpoints for comprehensive chat
  static const String channelDashboard = '/chat/channel/dashboard/';
  static const String users = '/users/';
  static const String userProfile = '/users/profile/';
  static const String spotifyDisconnect = '/spotify/disconnect/';
  static const String lastfmDisconnect = '/lastfm/disconnect/';
  static const String ytmusicDisconnect = '/ytmusic/disconnect/';
  static const String malDisconnect = '/mal/disconnect/';

  // Admin & Utility endpoints
  static const String admin = '/admin/';
  static const String spotifySeedUserCreate = '/spotify/seed/user/create';
  static const String mergeSimilars = '/merge-similars';
  static const String usersWeb = '/users/';
  static const String channelsWeb = '/channels/';

  // Error handling endpoints
  static const String notFound = '/404';
  static const String serverError = '/500';

  // Legacy endpoints for compatibility (to be removed)
  static const String topItems = '/top/items';


}
