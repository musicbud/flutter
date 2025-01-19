import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../domain/models/common_track.dart';
import '../../../../domain/models/common_artist.dart';
import '../../../../domain/models/common_album.dart';
import '../../../../domain/models/common_genre.dart';
import '../../../../domain/models/common_anime.dart';
import '../../../../domain/models/common_manga.dart';
import '../../../../domain/models/categorized_common_items.dart';
import '../../../network/dio_client.dart';

abstract class CommonItemsRemoteDataSource {
  Future<List<CommonTrack>> getCommonLikedTracks(String username);
  Future<List<CommonArtist>> getCommonLikedArtists(String username);
  Future<List<CommonAlbum>> getCommonLikedAlbums(String username);
  Future<List<CommonTrack>> getCommonPlayedTracks(String identifier);
  Future<List<CommonArtist>> getCommonTopArtists(String username);
  Future<List<CommonGenre>> getCommonTopGenres(String username);
  Future<List<CommonAnime>> getCommonTopAnime(String username);
  Future<List<CommonManga>> getCommonTopManga(String username);
  Future<List<CommonTrack>> getCommonTracks(String budUid);
  Future<List<CommonArtist>> getCommonArtists(String budUid);
  Future<List<CommonGenre>> getCommonGenres(String budUid);
  Future<CategorizedCommonItems> getCategorizedCommonItems(String username);
}

class CommonItemsRemoteDataSourceImpl implements CommonItemsRemoteDataSource {
  final DioClient _dioClient;

  CommonItemsRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<CommonTrack>> getCommonLikedTracks(String username) async {
    try {
      final response = await _dioClient.get('/common/tracks/liked/$username');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common liked tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonLikedArtists(String username) async {
    try {
      final response = await _dioClient.get('/common/artists/liked/$username');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common liked artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getCommonLikedAlbums(String username) async {
    try {
      final response = await _dioClient.get('/common/albums/liked/$username');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonAlbum.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common liked albums');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonPlayedTracks(String identifier) async {
    try {
      final response =
          await _dioClient.get('/common/tracks/played/$identifier');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common played tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonTopArtists(String username) async {
    try {
      final response = await _dioClient.get('/common/artists/top/$username');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common top artists');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonTopGenres(String username) async {
    try {
      final response = await _dioClient.get('/common/genres/top/$username');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonGenre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common top genres');
    }
  }

  @override
  Future<List<CommonAnime>> getCommonTopAnime(String username) async {
    try {
      final response = await _dioClient.get('/common/anime/top/$username');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonAnime.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common top anime');
    }
  }

  @override
  Future<List<CommonManga>> getCommonTopManga(String username) async {
    try {
      final response = await _dioClient.get('/common/manga/top/$username');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonManga.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common top manga');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonTracks(String budUid) async {
    try {
      final response = await _dioClient.get('/common/tracks/top/$budUid');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonArtists(String budUid) async {
    try {
      final response = await _dioClient.get('/common/artists/top/$budUid');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common artists');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonGenres(String budUid) async {
    try {
      final response = await _dioClient.get('/common/genres/top/$budUid');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonGenre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common genres');
    }
  }

  @override
  Future<CategorizedCommonItems> getCategorizedCommonItems(
      String username) async {
    try {
      final response = await _dioClient.get('/common/all/$username');
      final data = response.data['data'] ?? response.data;
      return CategorizedCommonItems.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get categorized common items');
    }
  }
}
