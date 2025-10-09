import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../models/track.dart';
import '../../../models/artist.dart';
import '../../../models/album.dart';
import '../../../models/genre.dart';
import '../../../config/api_config.dart';
import '../../../services/endpoint_config_service.dart';

abstract class ContentRemoteDataSource {
  // User's content
  Future<List<Track>> getMyLikedTracks();
  Future<List<Artist>> getMyLikedArtists();
  Future<List<Genre>> getMyLikedGenres();
  Future<List<Album>> getMyLikedAlbums();

  Future<List<Track>> getMyTopTracks();
  Future<List<Artist>> getMyTopArtists();
  Future<List<Genre>> getMyTopGenres();

  Future<List<Track>> getMyPlayedTracks();

  // Anime/Manga content
  Future<List<dynamic>> getMyTopAnime();
  Future<List<dynamic>> getMyTopManga();

  // Spotify integration
  Future<List<Map<String, dynamic>>> getSpotifyDevices();
  Future<void> controlSpotifyPlayback(String command, String deviceId);
  Future<void> setSpotifyVolume(String deviceId, int volume);

  // Popular content
  Future<List<Track>> getPopularTracks();

  // Track management
  Future<List<Track>> getPlayedTracks();
  Future<List<Map<String, dynamic>>> getPlayedTracksWithLocation();

  // Content actions
  Future<void> toggleLike(String contentId, String contentType);
  Future<void> playTrack(String trackId, String? deviceId);
  Future<void> playTrackOnService(String trackIdentifier, {String? service});
  Future<void> playTrackWithLocation(String trackUid, String trackName, double latitude, double longitude, [String? deviceId]);

  // Discover content
  Future<List<Map<String, dynamic>>> getFeaturedArtists();
  Future<List<Map<String, dynamic>>> getTrendingTracks();
  Future<List<Map<String, dynamic>>> getNewReleases();
  Future<List<Map<String, dynamic>>> getDiscoverActions();
  Future<List<String>> getDiscoverCategories();
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final DioClient _dioClient;
  final EndpointConfigService _endpointConfigService;

  ContentRemoteDataSourceImpl({
    required DioClient dioClient,
    required EndpointConfigService endpointConfigService,
  }) : _dioClient = dioClient,
       _endpointConfigService = endpointConfigService;

  @override
  Future<List<Track>> getMyLikedTracks() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - liked tracks', ApiConfig.baseUrl) ?? ApiConfig.myLikedTracks;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => Track.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked tracks');
    }
  }

  @override
  Future<List<Artist>> getMyLikedArtists() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - liked artists', ApiConfig.baseUrl) ?? ApiConfig.myLikedArtists;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => Artist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked artists');
    }
  }

  @override
  Future<List<Genre>> getMyLikedGenres() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - liked genres', ApiConfig.baseUrl) ?? ApiConfig.myLikedGenres;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => Genre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked genres');
    }
  }

  @override
  Future<List<Album>> getMyLikedAlbums() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - liked albums', ApiConfig.baseUrl) ?? ApiConfig.myLikedAlbums;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => Album.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked albums');
    }
  }

  @override
  Future<List<Track>> getMyTopTracks() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - top tracks', ApiConfig.baseUrl) ?? ApiConfig.myTopTracks;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => Track.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top tracks');
    }
  }

  @override
  Future<List<Artist>> getMyTopArtists() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - top artists', ApiConfig.baseUrl) ?? ApiConfig.myTopArtists;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => Artist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top artists');
    }
  }

  @override
  Future<List<Genre>> getMyTopGenres() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - top genres', ApiConfig.baseUrl) ?? ApiConfig.myTopGenres;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => Genre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top genres');
    }
  }

  @override
  Future<List<Track>> getMyPlayedTracks() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - played tracks', ApiConfig.baseUrl) ?? ApiConfig.myPlayedTracks;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => Track.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get played tracks');
    }
  }

  @override
  Future<void> toggleLike(String contentId, String contentType) async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - update my likes', ApiConfig.baseUrl) ?? ApiConfig.updateLikes;
      await _dioClient.post(url, data: {
        'contentId': contentId,
        'contentType': contentType,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to toggle like');
    }
  }

  @override
  Future<void> playTrack(String trackId, String? deviceId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Play track not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to play track');
    }
  }

  @override
  Future<List<dynamic>> getMyTopAnime() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - top anime', ApiConfig.baseUrl) ?? ApiConfig.myTopAnime;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => json).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top anime');
    }
  }

  @override
  Future<List<dynamic>> getMyTopManga() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - top manga', ApiConfig.baseUrl) ?? ApiConfig.myTopManga;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => json).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top manga');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSpotifyDevices() async {
    try {
      final response = await _dioClient.get('/spotify/devices');
      return (response.data['devices'] as List).map((json) => json as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get Spotify devices');
    }
  }

  @override
  Future<void> controlSpotifyPlayback(String command, String deviceId) async {
    try {
      await _dioClient.post('/spotify/control', data: {
        'command': command,
        'deviceId': deviceId,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to control Spotify playback');
    }
  }

  @override
  Future<void> setSpotifyVolume(String deviceId, int volume) async {
    try {
      await _dioClient.put('/spotify/volume', data: {
        'deviceId': deviceId,
        'volume': volume,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to set Spotify volume');
    }
  }

  @override
  Future<List<Track>> getPopularTracks() async {
    try {
      final response = await _dioClient.get('/content/popular/tracks');
      return (response.data as List).map((json) => Track.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get popular tracks');
    }
  }

  @override
  Future<List<Track>> getPlayedTracks() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('me - played tracks', ApiConfig.baseUrl) ?? ApiConfig.myPlayedTracks;
      final response = await _dioClient.post(url, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => Track.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get played tracks');
    }
  }

  @override
  Future<void> playTrackOnService(String trackIdentifier, {String? service}) async {
    try {
      final data = {'track_id': trackIdentifier};
      if (service != null) {
        data['service'] = service;
      }
      // Note: No "play" endpoint defined in endpoints_map.json, using fallback
      await _dioClient.post(ApiConfig.play, data: data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to play track on service');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPlayedTracksWithLocation() async {
    try {
      final response = await _dioClient.get('/spotify/played-tracks-with-location');
      return (response.data['data'] as List).map((json) => json as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get played tracks with location');
    }
  }

  @override
  Future<void> playTrackWithLocation(String trackUid, String trackName, double latitude, double longitude, [String? deviceId]) async {
    try {
      final data = {
        'track_id': trackUid,
        'track_name': trackName,
        'latitude': latitude,
        'longitude': longitude,
      };
      if (deviceId != null) {
        data['device_id'] = deviceId;
      }
      await _dioClient.post('/me/play-track-with-location', data: data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to play track with location');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFeaturedArtists() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('discover - featured artists', ApiConfig.baseUrl) ?? ApiConfig.featuredArtists;
      final response = await _dioClient.get(url);
      return (response.data as List).map((json) => json as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get featured artists');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTrendingTracks() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('discover - trending tracks', ApiConfig.baseUrl) ?? ApiConfig.trendingTracks;
      final response = await _dioClient.get(url);
      return (response.data as List).map((json) => json as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get trending tracks');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getNewReleases() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('discover - new releases', ApiConfig.baseUrl) ?? ApiConfig.newReleases;
      final response = await _dioClient.get(url);
      return (response.data as List).map((json) => json as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get new releases');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getDiscoverActions() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('discover - actions', ApiConfig.baseUrl) ?? ApiConfig.discoverActions;
      final response = await _dioClient.get(url);
      return (response.data as List).map((json) => json as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get discover actions');
    }
  }

  @override
  Future<List<String>> getDiscoverCategories() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('discover - categories', ApiConfig.baseUrl) ?? ApiConfig.discoverCategories;
      final response = await _dioClient.get(url);
      return (response.data as List).map((item) => item as String).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get discover categories');
    }
  }
}
