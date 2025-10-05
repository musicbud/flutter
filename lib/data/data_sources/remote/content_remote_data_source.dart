import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/track.dart';
import '../../../config/api_config.dart';

abstract class ContentRemoteDataSource {
  // User's content
  Future<List<CommonTrack>> getMyLikedTracks();
  Future<List<CommonArtist>> getMyLikedArtists();
  Future<List<CommonGenre>> getMyLikedGenres();
  Future<List<CommonAlbum>> getMyLikedAlbums();

  Future<List<CommonTrack>> getMyTopTracks();
  Future<List<CommonArtist>> getMyTopArtists();
  Future<List<CommonGenre>> getMyTopGenres();

  Future<List<CommonTrack>> getMyPlayedTracks();

  // Anime/Manga content
  Future<List<dynamic>> getMyTopAnime();
  Future<List<dynamic>> getMyTopManga();

  // Spotify integration
  Future<List<dynamic>> getSpotifyDevices();
  Future<void> controlSpotifyPlayback(String command, String deviceId);
  Future<void> setSpotifyVolume(String deviceId, int volume);

  // Popular content
  Future<List<CommonTrack>> getPopularTracks();

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
  Future<List<CommonTrack>> getMyLikedTracks() async {
    try {
      final response = await _dioClient.post(ApiConfig.myLikedTracks, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getMyLikedArtists() async {
    try {
      final response = await _dioClient.post(ApiConfig.myLikedArtists, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked artists');
    }
  }

  @override
  Future<List<CommonGenre>> getMyLikedGenres() async {
    try {
      final response = await _dioClient.post(ApiConfig.myLikedGenres, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => CommonGenre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked genres');
    }
  }

  @override
  Future<List<CommonAlbum>> getMyLikedAlbums() async {
    try {
      final response = await _dioClient.post(ApiConfig.myLikedAlbums, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => CommonAlbum.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked albums');
    }
  }

  @override
  Future<List<CommonTrack>> getMyTopTracks() async {
    try {
      final response = await _dioClient.post(ApiConfig.myTopTracks, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getMyTopArtists() async {
    try {
      final response = await _dioClient.post(ApiConfig.myTopArtists, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top artists');
    }
  }

  @override
  Future<List<CommonGenre>> getMyTopGenres() async {
    try {
      final response = await _dioClient.post(ApiConfig.myTopGenres, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => CommonGenre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top genres');
    }
  }

  @override
  Future<List<CommonTrack>> getMyPlayedTracks() async {
    try {
      final response = await _dioClient.post(ApiConfig.myPlayedTracks, data: {});
      final responseData = response.data as Map<String, dynamic>;
      final results = responseData['results'] as List? ?? [];
      return results.map((json) => CommonTrack.fromJson(json)).toList();
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
  Future<List<CommonTrack>> getPopularTracks() async {
    try {
      final response = await _dioClient.get('/content/popular/tracks');
      return (response.data as List).map((json) => CommonTrack.fromJson(json)).toList();
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
