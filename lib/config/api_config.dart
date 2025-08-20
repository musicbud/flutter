class ApiConfig {
  // Base URL - matches the backend repository structure
  static const String baseUrl = 'http://84.235.170.234';

  // API version - backend uses v1
  static const String apiVersion = 'v1';

  // Full API base URL
  static const String fullBaseUrl = '$baseUrl/$apiVersion';

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
  static const String refreshToken = '/chat/refresh-token/';
  static const String logout = '/logout/';

  // Profile endpoints
  static const String myProfile = '/me/profile';
  static const String budProfile = '/bud/profile';
  static const String updateProfile = '/me/profile/set';
  static const String updateLikes = '/me/likes/update';
  static const String profileServices = '/profile/services';
  static const String profileAvatar = '/profile/avatar';
  static const String topItems = '/profile/top-items';

  // Bud matching endpoints
  static const String budCommon = '/bud/common';
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

  // Chat endpoints
  static const String chatLogin = '/chat/login/';
  static const String chatGetChannels = '/chat/get_channels/';
  static const String chatCreateChannel = '/chat/create_channel/';
  static const String chatGetChannelUsers = '/chat/get_channel_users';
  static const String chatGetChannelMessages = '/chat/get_channel_messages';
  static const String chatSendMessage = '/chat/send_message/';
  static const String chatSendChannelMessage = '/chat/send_channel_message/';
  static const String chatSendUserMessage = '/chat/send_user_message/';
  static const String chatDeleteMessage = '/chat/channel';
  static const String chatJoinChannel = '/chat/join_channel/';
  static const String chatLeaveChannel = '/chat/leave_channel/';
  static const String chatRequestJoin = '/chat/request_join/';

  // Service connection endpoints
  static const String spotifyAuth = '/service/spotify/auth';
  static const String spotifyConnect = '/service/spotify/connect';
  static const String spotifyDisconnect = '/service/spotify/disconnect';
  static const String lastfmAuth = '/service/lastfm/auth';
  static const String lastfmConnect = '/service/lastfm/connect';
  static const String lastfmDisconnect = '/service/lastfm/disconnect';
  static const String ytmusicAuth = '/service/ytmusic/auth';
  static const String ytmusicConnect = '/service/ytmusic/connect';
  static const String ytmusicDisconnect = '/service/ytmusic/disconnect';
  static const String malAuth = '/service/mal/auth';
  static const String malConnect = '/service/mal/connect';
  static const String malDisconnect = '/service/mal/disconnect';

  // User endpoints
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String userMessages = '/users/messages';

  // Channel endpoints
  static const String channels = '/channels';
  static const String channelDetails = '/channels/details';
  static const String channelMessages = '/channels/messages';
  static const String channelUsers = '/channels/users';
  static const String channelRoles = '/channels/roles';
  static const String channelDashboard = '/channels/dashboard';
  static const String channelAdmin = '/channels/admin';
}
