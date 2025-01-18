import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../models/movie.dart';
import '../../../../models/track.dart';
import '../../../../models/artist.dart';
import '../../../../models/album.dart';
import '../../../../models/anime.dart';
import '../../../../models/manga.dart';
import '../../../network/dio_client.dart';

abstract class ContentRemoteDataSource {
  // Home page
  Future<Map<String, dynamic>> getHomePageData();

  // Popular content
  Future<List<Movie>> getPopularMovies({int limit = 20});
  Future<List<Track>> getPopularTracks({int limit = 20});
  Future<List<Artist>> getPopularArtists({int limit = 20});
  Future<List<Album>> getPopularAlbums({int limit = 20});
  Future<List<Anime>> getPopularAnime({int limit = 20});
  Future<List<Manga>> getPopularManga({int limit = 20});

  // Like/Unlike operations
  Future<void> likeItem(String itemType, String itemId);
  Future<void> unlikeItem(String itemType, String itemId);

  // Playback operations
  Future<List<String>> getSpotifyDevices();
  Future<void> playTrack(String trackId, {String? deviceId});
  Future<void> playTrackWithLocation(
      String trackId, double latitude, double longitude);
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude);
  Future<List<Track>> getPlayedTracksWithLocation();
  Future<List<Track>> getCurrentlyPlayedTracks();
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final Dio _dio;

  ContentRemoteDataSourceImpl() : _dio = DioClient().dio;

  @override
  Future<Map<String, dynamic>> getHomePageData() async {
    try {
      final response = await _dio.get('/content/home');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get home page data');
    }
  }

  @override
  Future<List<Movie>> getPopularMovies({int limit = 20}) async {
    try {
      final response = await _dio
          .get('/content/popular/movies', queryParameters: {'limit': limit});
      final List<dynamic> data = response.data;
      return data.map((json) => Movie.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular movies');
    }
  }

  @override
  Future<List<Track>> getPopularTracks({int limit = 20}) async {
    try {
      final response = await _dio
          .get('/content/popular/tracks', queryParameters: {'limit': limit});
      final List<dynamic> data = response.data;
      return data.map((json) => Track.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular tracks');
    }
  }

  @override
  Future<List<Artist>> getPopularArtists({int limit = 20}) async {
    try {
      final response = await _dio
          .get('/content/popular/artists', queryParameters: {'limit': limit});
      final List<dynamic> data = response.data;
      return data.map((json) => Artist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular artists');
    }
  }

  @override
  Future<List<Album>> getPopularAlbums({int limit = 20}) async {
    try {
      final response = await _dio
          .get('/content/popular/albums', queryParameters: {'limit': limit});
      final List<dynamic> data = response.data;
      return data.map((json) => Album.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular albums');
    }
  }

  @override
  Future<List<Anime>> getPopularAnime({int limit = 20}) async {
    try {
      final response = await _dio
          .get('/content/popular/anime', queryParameters: {'limit': limit});
      final List<dynamic> data = response.data;
      return data.map((json) => Anime.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular anime');
    }
  }

  @override
  Future<List<Manga>> getPopularManga({int limit = 20}) async {
    try {
      final response = await _dio
          .get('/content/popular/manga', queryParameters: {'limit': limit});
      final List<dynamic> data = response.data;
      return data.map((json) => Manga.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular manga');
    }
  }

  @override
  Future<void> likeItem(String itemType, String itemId) async {
    try {
      await _dio.post('/content/like', data: {
        'type': itemType,
        'id': itemId,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to like item');
    }
  }

  @override
  Future<void> unlikeItem(String itemType, String itemId) async {
    try {
      await _dio.post('/content/unlike', data: {
        'type': itemType,
        'id': itemId,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unlike item');
    }
  }

  @override
  Future<List<String>> getSpotifyDevices() async {
    try {
      final response = await _dio.get('/content/spotify/devices');
      final List<dynamic> data = response.data;
      return data.map((json) => json['id'] as String).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get Spotify devices');
    }
  }

  @override
  Future<void> playTrack(String trackId, {String? deviceId}) async {
    try {
      await _dio.post('/content/spotify/play', data: {
        'track_id': trackId,
        if (deviceId != null) 'device_id': deviceId,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to play track');
    }
  }

  @override
  Future<void> playTrackWithLocation(
      String trackId, double latitude, double longitude) async {
    try {
      await _dio.post('/content/play-track-with-location', data: {
        'track_id': trackId,
        'latitude': latitude,
        'longitude': longitude,
      });
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to play track with location');
    }
  }

  @override
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude) async {
    try {
      await _dio.post('/content/save-played-track', data: {
        'track_id': trackId,
        'latitude': latitude,
        'longitude': longitude,
      });
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to save played track');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    try {
      final response = await _dio.get('/content/played-tracks-with-location');
      final List<dynamic> data = response.data;
      return data.map((json) => Track.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get played tracks with location');
    }
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    try {
      final response = await _dio.get('/content/currently-played-tracks');
      final List<dynamic> data = response.data;
      return data.map((json) => Track.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get currently played tracks');
    }
  }
}
