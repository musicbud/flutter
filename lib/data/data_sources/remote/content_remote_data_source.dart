import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';

abstract class ContentRemoteDataSource {
  // Home page
  Future<Map<String, dynamic>> getHomePageData();

  // Popular content
  Future<List<CommonTrack>> getPopularMusic({int limit = 20});
  Future<List<CommonAnime>> getPopularAnime({int limit = 20});
  Future<List<CommonManga>> getPopularManga({int limit = 20});

  // Top content
  Future<List<CommonTrack>> getTopTracks();
  Future<List<CommonArtist>> getTopArtists();
  Future<List<CommonGenre>> getTopGenres();

  // Liked content
  Future<List<CommonTrack>> getLikedTracks();
  Future<List<CommonArtist>> getLikedArtists();
  Future<List<CommonAlbum>> getLikedAlbums();
  Future<List<CommonGenre>> getLikedGenres();

  // Played content
  Future<List<CommonTrack>> getPlayedTracks();
  Future<List<CommonTrack>> getPlayedTracksWithLocation();
  Future<List<CommonTrack>> getCurrentlyPlayedTracks();

  // Like/Unlike operations
  Future<void> like(String type, String id);
  Future<void> unlike(String type, String id);

  // Search operations
  Future<List<CommonTrack>> searchTracks(String query);
  Future<List<CommonArtist>> searchArtists(String query);
  Future<List<CommonAlbum>> searchAlbums(String query);
  Future<List<CommonGenre>> searchGenres(String query);
  Future<List<CommonAnime>> searchAnime(String query);
  Future<List<CommonManga>> searchManga(String query);

  // Playback operations
  Future<List<Map<String, dynamic>>> getSpotifyDevices();
  Future<void> playTrackOnSpotify(String trackId, String deviceId);
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude);
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final DioClient _dioClient;

  ContentRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> getHomePageData() async {
    try {
      final response = await _dioClient.get('/home');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get home page data');
    }
  }

  @override
  Future<List<CommonTrack>> getPopularMusic({int limit = 20}) async {
    try {
      final response = await _dioClient
          .get('/popular/music', queryParameters: {'limit': limit});
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular music');
    }
  }

  @override
  Future<List<CommonAnime>> getPopularAnime({int limit = 20}) async {
    try {
      final response = await _dioClient
          .get('/popular/anime', queryParameters: {'limit': limit});
      return (response.data as List)
          .map((anime) => CommonAnime.fromJson(anime))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular anime');
    }
  }

  @override
  Future<List<CommonManga>> getPopularManga({int limit = 20}) async {
    try {
      final response = await _dioClient
          .get('/popular/manga', queryParameters: {'limit': limit});
      return (response.data as List)
          .map((manga) => CommonManga.fromJson(manga))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular manga');
    }
  }

  @override
  Future<List<CommonTrack>> getTopTracks() async {
    try {
      final response = await _dioClient.get('/top/tracks');
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getTopArtists() async {
    try {
      final response = await _dioClient.get('/top/artists');
      return (response.data as List)
          .map((artist) => CommonArtist.fromJson(artist))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top artists');
    }
  }

  @override
  Future<List<CommonGenre>> getTopGenres() async {
    try {
      final response = await _dioClient.get('/top/genres');
      return (response.data as List)
          .map((genre) => CommonGenre.fromJson(genre))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top genres');
    }
  }

  @override
  Future<List<CommonTrack>> getLikedTracks() async {
    try {
      final response = await _dioClient.get('/liked/tracks');
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getLikedArtists() async {
    try {
      final response = await _dioClient.get('/liked/artists');
      return (response.data as List)
          .map((artist) => CommonArtist.fromJson(artist))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get liked artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() async {
    try {
      final response = await _dioClient.get('/liked/albums');
      return (response.data as List)
          .map((album) => CommonAlbum.fromJson(album))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked albums');
    }
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() async {
    try {
      final response = await _dioClient.get('/liked/genres');
      return (response.data as List)
          .map((genre) => CommonGenre.fromJson(genre))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked genres');
    }
  }

  @override
  Future<List<CommonTrack>> getPlayedTracks() async {
    try {
      final response = await _dioClient.get('/played/tracks');
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get played tracks');
    }
  }

  @override
  Future<List<CommonTrack>> getPlayedTracksWithLocation() async {
    try {
      final response =
          await _dioClient.get('/spotify/played-tracks-with-location');
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get played tracks with location');
    }
  }

  @override
  Future<List<CommonTrack>> getCurrentlyPlayedTracks() async {
    try {
      final response = await _dioClient.get('/played/tracks/current');
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get currently played tracks');
    }
  }

  @override
  Future<void> like(String type, String id) async {
    try {
      await _dioClient.post('/like', data: {
        'type': type,
        'id': id,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to like item');
    }
  }

  @override
  Future<void> unlike(String type, String id) async {
    try {
      await _dioClient.post('/unlike', data: {
        'type': type,
        'id': id,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unlike item');
    }
  }

  @override
  Future<List<CommonTrack>> searchTracks(String query) async {
    try {
      final response =
          await _dioClient.get('/search/tracks', queryParameters: {'q': query});
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search tracks');
    }
  }

  @override
  Future<List<CommonArtist>> searchArtists(String query) async {
    try {
      final response = await _dioClient
          .get('/search/artists', queryParameters: {'q': query});
      return (response.data as List)
          .map((artist) => CommonArtist.fromJson(artist))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search artists');
    }
  }

  @override
  Future<List<CommonAlbum>> searchAlbums(String query) async {
    try {
      final response =
          await _dioClient.get('/search/albums', queryParameters: {'q': query});
      return (response.data as List)
          .map((album) => CommonAlbum.fromJson(album))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search albums');
    }
  }

  @override
  Future<List<CommonGenre>> searchGenres(String query) async {
    try {
      final response =
          await _dioClient.get('/search/genres', queryParameters: {'q': query});
      return (response.data as List)
          .map((genre) => CommonGenre.fromJson(genre))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search genres');
    }
  }

  @override
  Future<List<CommonAnime>> searchAnime(String query) async {
    try {
      final response =
          await _dioClient.get('/search/anime', queryParameters: {'q': query});
      return (response.data as List)
          .map((anime) => CommonAnime.fromJson(anime))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search anime');
    }
  }

  @override
  Future<List<CommonManga>> searchManga(String query) async {
    try {
      final response =
          await _dioClient.get('/search/manga', queryParameters: {'q': query});
      return (response.data as List)
          .map((manga) => CommonManga.fromJson(manga))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search manga');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSpotifyDevices() async {
    try {
      final response = await _dioClient.get('/spotify/devices');
      return List<Map<String, dynamic>>.from(response.data['devices']);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get Spotify devices');
    }
  }

  @override
  Future<void> playTrackOnSpotify(String trackId, String deviceId) async {
    try {
      await _dioClient.post('/spotify/play', data: {
        'track_id': trackId,
        'device_id': deviceId,
      });
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to play track on Spotify');
    }
  }

  @override
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude) async {
    try {
      await _dioClient.post('/played/tracks', data: {
        'track_id': trackId,
        'latitude': latitude,
        'longitude': longitude,
      });
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to save played track');
    }
  }
}
