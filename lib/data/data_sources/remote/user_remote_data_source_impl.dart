import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/error/exceptions.dart';
import '../../../models/track.dart';
import '../../../models/user_profile.dart';
import '../../../models/artist.dart';
import '../../../models/album.dart';
import '../../../models/genre.dart';
import '../../../models/parent_user.dart';
import '../../../models/common_anime.dart';
import '../../../models/common_manga.dart';
import 'user_remote_data_source.dart';
import '../../providers/token_provider.dart';
import '../../network/dio_client.dart';
import '../../../config/api_config.dart';
import '../../../services/endpoint_config_service.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _dioClient;
  final TokenProvider _tokenProvider;
  final EndpointConfigService _endpointConfigService;

  UserRemoteDataSourceImpl({
    required DioClient dioClient,
    required TokenProvider tokenProvider,
    required EndpointConfigService endpointConfigService,
  })  : _dioClient = dioClient,
        _tokenProvider = tokenProvider,
        _endpointConfigService = endpointConfigService;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${_tokenProvider.token}',
  };

  @override
  Future<UserProfile> getUserProfile() async {
    debugPrint('Getting profile with token: ${_tokenProvider.token}');
    final url = _endpointConfigService.getEndpointUrl('me - get profile', ApiConfig.baseUrl) ?? ApiConfig.myProfile;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      // The backend returns a direct JSON object, not wrapped in pagination
      return UserProfile.fromJson(response.data);
    } else {
      debugPrint('Failed to get profile. Status: ${response.statusCode}');
      debugPrint('Response body: ${response.data}');
      debugPrint('Headers sent: $_headers');
      throw ServerException(message: 'Failed to get user profile');
    }
  }

  @override
  Future<ParentUser> getParentUser() async {
    debugPrint('Getting parent user with token: ${_tokenProvider.token}');
    final url = _endpointConfigService.getEndpointUrl('me - get profile', ApiConfig.baseUrl) ?? ApiConfig.myProfile;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      // Assuming the response contains parent user data
      return ParentUser.fromJson(response.data);
    } else {
      debugPrint('Failed to get parent user. Status: ${response.statusCode}');
      debugPrint('Response body: ${response.data}');
      debugPrint('Headers sent: $_headers');
      throw ServerException(message: 'Failed to get parent user');
    }
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    final url = _endpointConfigService.getEndpointUrl('me - liked tracks', ApiConfig.baseUrl) ?? ApiConfig.myLikedTracks;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      // Backend returns paginated response with 'results' field
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
        final List<dynamic> tracksJson = responseData['results'];
        return tracksJson.map((json) => Track.fromJson(json)).toList();
      } else if (responseData is List) {
        // Fallback for direct array response
        return responseData.map((json) => Track.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw ServerException(message: 'Failed to get liked tracks');
    }
  }

  @override
  Future<void> likeSong(String songId) async {
    final url = _endpointConfigService.getEndpointUrl('me - update my likes', ApiConfig.baseUrl) ?? ApiConfig.updateLikes;
    final response = await _dioClient.post(url, data: {
      'contentId': songId,
      'contentType': 'track',
    });

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to like song');
    }
  }

  @override
  Future<void> unlikeSong(String songId) async {
    final url = _endpointConfigService.getEndpointUrl('me - update my likes', ApiConfig.baseUrl) ?? ApiConfig.updateLikes;
    final response = await _dioClient.post(url, data: {
      'contentId': songId,
      'contentType': 'track',
      'action': 'unlike',
    });

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to unlike song');
    }
  }

  @override
  void updateToken(String newToken) {
    _tokenProvider.updateToken(newToken);
  }

  @override
  Future<UserProfile> getMyProfile() async {
    debugPrint('Getting profile with token: ${_tokenProvider.token}');
    final url = _endpointConfigService.getEndpointUrl('me - get profile', ApiConfig.baseUrl) ?? ApiConfig.myProfile;
    final response = await _dioClient.post(url, data: {}); // Fixed to POST
    if (response.statusCode == 200) {
      return UserProfile.fromJson(response.data);
    } else {
      debugPrint('Failed to get profile. Status: ${response.statusCode}');
      debugPrint('Response body: ${response.data}');
      debugPrint('Headers sent: $_headers');
      throw ServerException(message: 'Failed to get user profile');
    }
  }

  @override
  Future<UserProfile> getBudProfile(String username) async {
    final url = _endpointConfigService.getEndpointUrl('buds - get bud profile', ApiConfig.baseUrl) ?? ApiConfig.budProfile;
    final response = await _dioClient.post(url, data: {
      'username': username,
    });

    if (response.statusCode == 200) {
      return UserProfile.fromJson(response.data);
    } else {
      throw ServerException(message: 'Failed to get bud profile');
    }
  }

  @override
  Future<void> updateMyProfile(UserProfile profile) async {
    final url = _endpointConfigService.getEndpointUrl('me - set profile', ApiConfig.baseUrl) ?? ApiConfig.updateProfile;
    final response = await _dioClient.post(
      url,
      data: profile.toJson(),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update profile');
    }
  }

  @override
  Future<void> updateMyLikes() async {
    final url = _endpointConfigService.getEndpointUrl('me - update my likes', ApiConfig.baseUrl) ?? ApiConfig.updateLikes;
    final response = await _dioClient.post(url);

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update likes');
    }
  }

  @override
  Future<List<Artist>> getLikedArtists() async {
    final url = _endpointConfigService.getEndpointUrl('me - liked artists', ApiConfig.baseUrl) ?? ApiConfig.myLikedArtists;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      final List<dynamic> artistsJson = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return artistsJson.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked artists');
    }
  }

  @override
  Future<List<Album>> getLikedAlbums() async {
    final url = _endpointConfigService.getEndpointUrl('me - liked albums', ApiConfig.baseUrl) ?? ApiConfig.myLikedAlbums;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      final List<dynamic> albumsJson = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return albumsJson.map((json) => Album.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked albums');
    }
  }

  @override
  Future<List<Genre>> getLikedGenres() async {
    final url = _endpointConfigService.getEndpointUrl('me - liked genres', ApiConfig.baseUrl) ?? ApiConfig.myLikedGenres;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      final List<dynamic> genresJson = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return genresJson.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked genres');
    }
  }

  @override
  Future<List<Artist>> getTopArtists() async {
    final url = _endpointConfigService.getEndpointUrl('me - top artists', ApiConfig.baseUrl) ?? ApiConfig.myTopArtists;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      final List<dynamic> artistsJson = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return artistsJson.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top artists');
    }
  }

  @override
  Future<List<Track>> getTopTracks() async {
    final url = _endpointConfigService.getEndpointUrl('me - top tracks', ApiConfig.baseUrl) ?? ApiConfig.myTopTracks;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      // Backend returns paginated response with 'results' field
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
        final List<dynamic> tracksJson = responseData['results'];
        return tracksJson.map((json) => Track.fromJson(json)).toList();
      } else if (responseData is List) {
        // Fallback for direct array response
        return responseData.map((json) => Track.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw ServerException(message: 'Failed to get top tracks');
    }
  }

  @override
  Future<List<Genre>> getTopGenres() async {
    final url = _endpointConfigService.getEndpointUrl('me - top genres', ApiConfig.baseUrl) ?? ApiConfig.myTopGenres;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      final List<dynamic> genresJson = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return genresJson.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top genres');
    }
  }

  @override
  Future<List<CommonAnime>> getTopAnime() async {
    final url = _endpointConfigService.getEndpointUrl('me - top anime', ApiConfig.baseUrl) ?? ApiConfig.myTopAnime;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      final List<dynamic> animeJson = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return animeJson.map((json) => CommonAnime.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top anime');
    }
  }

  @override
  Future<List<CommonManga>> getTopManga() async {
    final url = _endpointConfigService.getEndpointUrl('me - top manga', ApiConfig.baseUrl) ?? ApiConfig.myTopManga;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      final List<dynamic> mangaJson = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return mangaJson.map((json) => CommonManga.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top manga');
    }
  }

  @override
  Future<String> getSpotifyAuthUrl() async {
    final url = _endpointConfigService.getEndpointUrl('auth - service login', ApiConfig.baseUrl) ?? ApiConfig.serviceLogin;
    final response = await _dioClient.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get Spotify auth URL');
    }
  }

  @override
  Future<void> connectSpotify(String code) async {
    final url = _endpointConfigService.getEndpointUrl('auth - connect service - spotify connect', ApiConfig.baseUrl) ?? ApiConfig.spotifyConnect;
    final response = await _dioClient.post(
      url,
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect Spotify');
    }
  }

  @override
  Future<void> disconnectSpotify() async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Disconnect Spotify not supported by API');
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    final url = _endpointConfigService.getEndpointUrl('auth - service login', ApiConfig.baseUrl) ?? ApiConfig.serviceLogin;
    final response = await _dioClient.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get YouTube Music auth URL');
    }
  }

  @override
  Future<void> connectYTMusic(String code) async {
    final url = _endpointConfigService.getEndpointUrl('auth - connect service - ytmusic connect', ApiConfig.baseUrl) ?? ApiConfig.ytmusicConnect;
    final response = await _dioClient.post(
      url,
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect YouTube Music');
    }
  }

  @override
  Future<void> disconnectYTMusic() async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Disconnect YouTube Music not supported by API');
  }

  @override
  Future<String> getMALAuthUrl() async {
    final url = _endpointConfigService.getEndpointUrl('auth - service login', ApiConfig.baseUrl) ?? ApiConfig.serviceLogin;
    final response = await _dioClient.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get MyAnimeList auth URL');
    }
  }

  @override
  Future<void> connectMAL(String code) async {
    final url = _endpointConfigService.getEndpointUrl('auth - connect service - mal connect', ApiConfig.baseUrl) ?? ApiConfig.malConnect;
    final response = await _dioClient.post(
      url,
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect MyAnimeList');
    }
  }

  @override
  Future<void> disconnectMAL() async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Disconnect MyAnimeList not supported by API');
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    final url = _endpointConfigService.getEndpointUrl('auth - service login', ApiConfig.baseUrl) ?? ApiConfig.serviceLogin;
    final response = await _dioClient.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get Last.fm auth URL');
    }
  }

  @override
  Future<void> connectLastFM(String code) async {
    final url = _endpointConfigService.getEndpointUrl('auth - connect service - lastfm connect', ApiConfig.baseUrl) ?? ApiConfig.lastfmConnect;
    final response = await _dioClient.post(
      url,
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect Last.fm');
    }
  }

  @override
  Future<void> disconnectLastFM() async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Disconnect Last.fm not supported by API');
  }

  @override
  Future<void> saveLocation(double latitude, double longitude) async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Save location not supported by API');
  }

  @override
  Future<List<Track>> getPlayedTracks() async {
    final url = _endpointConfigService.getEndpointUrl('me - played tracks', ApiConfig.baseUrl) ?? ApiConfig.myPlayedTracks;
    final response = await _dioClient.post(url);

    if (response.statusCode == 200) {
      // Backend returns paginated response with 'results' field
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
        final List<dynamic> tracksJson = responseData['results'];
        return tracksJson.map((json) => Track.fromJson(json)).toList();
      } else if (responseData is List) {
        // Fallback for direct array response
        return responseData.map((json) => Track.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw ServerException(message: 'Failed to get played tracks');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    // This endpoint is not in the requirements, so we'll use the regular played tracks
    return getPlayedTracks();
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Currently played tracks not supported by API');
  }

  @override
  Future<void> updateUserProfile(String userId, Map<String, dynamic> profileData) async {
    final response = await _dioClient.post(
      '${ApiConfig.usersWeb}/$userId/profile',
      data: profileData,
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update user profile');
    }
  }

  @override
  Future<void> banUser(String userId) async {
    final response = await _dioClient.post(
      '${ApiConfig.usersWeb}/$userId/ban',
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to ban user');
    }
  }

  @override
  Future<void> unbanUser(String userId) async {
    final response = await _dioClient.post(
      '${ApiConfig.usersWeb}/$userId/unban',
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to unban user');
    }
  }

  @override
  Future<List<UserProfile>> getBannedUsers() async {
    final response = await _dioClient.get('${ApiConfig.usersWeb}/banned');

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = json.decode(json.encode(response.data)); // Added json.encode to ensure string
      return usersJson.map((json) => UserProfile.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get banned users');
    }
  }
}