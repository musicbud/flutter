import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_album.dart';
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
      return (response.data as List).map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getMyLikedArtists() async {
    try {
      final response = await _dioClient.post(ApiConfig.myLikedArtists, data: {});
      return (response.data as List).map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked artists');
    }
  }

  @override
  Future<List<CommonGenre>> getMyLikedGenres() async {
    try {
      final response = await _dioClient.post(ApiConfig.myLikedGenres, data: {});
      return (response.data as List).map((json) => CommonGenre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked genres');
    }
  }

  @override
  Future<List<CommonAlbum>> getMyLikedAlbums() async {
    try {
      final response = await _dioClient.post(ApiConfig.myLikedAlbums, data: {});
      return (response.data as List).map((json) => CommonAlbum.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked albums');
    }
  }

  @override
  Future<List<CommonTrack>> getMyTopTracks() async {
    try {
      final response = await _dioClient.post(ApiConfig.myTopTracks, data: {});
      return (response.data as List).map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getMyTopArtists() async {
    try {
      final response = await _dioClient.post(ApiConfig.myTopArtists, data: {});
      return (response.data as List).map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top artists');
    }
  }

  @override
  Future<List<CommonGenre>> getMyTopGenres() async {
    try {
      final response = await _dioClient.post(ApiConfig.myTopGenres, data: {});
      return (response.data as List).map((json) => CommonGenre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top genres');
    }
  }

  @override
  Future<List<CommonTrack>> getMyPlayedTracks() async {
    try {
      final response = await _dioClient.post(ApiConfig.myPlayedTracks, data: {});
      return (response.data as List).map((json) => CommonTrack.fromJson(json)).toList();
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
}
