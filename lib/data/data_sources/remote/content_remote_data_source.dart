import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../models/track.dart';
import '../../../models/artist.dart';
import '../../../models/album.dart';
import '../../../models/genre.dart';
import '../../../config/api_config.dart';

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
  Future<List<dynamic>> getSpotifyDevices();
  Future<void> controlSpotifyPlayback(String command, String deviceId);
  Future<void> setSpotifyVolume(String deviceId, int volume);

  // Popular content
  Future<List<Track>> getPopularTracks();

  // Track management
  Future<List<Track>> getPlayedTracks();

  // Content actions
  Future<void> toggleLike(String contentId, String contentType);
  Future<void> playTrack(String trackId, String? deviceId);
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final DioClient _dioClient;

  ContentRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<Track>> getMyLikedTracks() async {
    try {
      final response = await _dioClient.post(ApiConfig.myLikedTracks, data: {});
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
      final response = await _dioClient.post(ApiConfig.myLikedArtists, data: {});
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
      final response = await _dioClient.post(ApiConfig.myLikedGenres, data: {});
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
      final response = await _dioClient.post(ApiConfig.myLikedAlbums, data: {});
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
      final response = await _dioClient.post(ApiConfig.myTopTracks, data: {});
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
      final response = await _dioClient.post(ApiConfig.myTopArtists, data: {});
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
      final response = await _dioClient.post(ApiConfig.myTopGenres, data: {});
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
      final response = await _dioClient.post(ApiConfig.myPlayedTracks, data: {});
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
      await _dioClient.post(ApiConfig.updateLikes, data: {
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
      final response = await _dioClient.post(ApiConfig.myTopAnime, data: {});
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
      final response = await _dioClient.post(ApiConfig.myTopManga, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => json).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top manga');
    }
  }

  @override
  Future<List<dynamic>> getSpotifyDevices() async {
    try {
      final response = await _dioClient.get('/spotify/devices');
      return (response.data as List).map((json) => json).toList();
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
      final response = await _dioClient.post(ApiConfig.myPlayedTracks, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => Track.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get played tracks');
    }
  }
}
