import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../models/common_track.dart';
import '../../../../models/common_artist.dart';
import '../../../../models/common_album.dart';
import '../../../../models/common_genre.dart';
import '../../../../models/common_anime.dart';
import '../../../../models/common_manga.dart';
import '../../../../models/categorized_common_items.dart';
import '../../../network/dio_client.dart';

abstract class CommonItemsRemoteDataSource {
  Future<List<CommonTrack>> getCommonLikedTracks(String username);
  Future<List<CommonArtist>> getCommonLikedArtists(String username);
  Future<List<CommonAlbum>> getCommonLikedAlbums(String username);
  Future<List<CommonTrack>> getCommonPlayedTracks(String identifier,
      {int page = 1});
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
  final Dio _dio;

  CommonItemsRemoteDataSourceImpl() : _dio = DioClient().dio;

  @override
  Future<List<CommonTrack>> getCommonLikedTracks(String username) async {
    try {
      final response = await _dio
          .post('/bud/common/liked/tracks', data: {'username': username});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common liked tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonLikedArtists(String username) async {
    try {
      final response = await _dio
          .post('/bud/common/liked/artists', data: {'username': username});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common liked artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getCommonLikedAlbums(String username) async {
    try {
      final response = await _dio
          .post('/bud/common/liked/albums', data: {'username': username});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CommonAlbum.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common liked albums');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonPlayedTracks(String identifier,
      {int page = 1}) async {
    try {
      final data = identifier.contains('@')
          ? {'username': identifier}
          : {'bud_id': identifier, 'page': page};

      final response = await _dio.post('/bud/common/played/tracks', data: data);
      final List<dynamic> responseData = response.data['data'];
      return responseData.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common played tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonTopArtists(String username) async {
    try {
      final response = await _dio
          .post('/bud/common/top/artists', data: {'username': username});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common top artists');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonTopGenres(String username) async {
    try {
      final response = await _dio
          .post('/bud/common/top/genres', data: {'username': username});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CommonGenre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common top genres');
    }
  }

  @override
  Future<List<CommonAnime>> getCommonTopAnime(String username) async {
    try {
      final response = await _dio
          .post('/bud/common/top/anime', data: {'username': username});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CommonAnime.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common top anime');
    }
  }

  @override
  Future<List<CommonManga>> getCommonTopManga(String username) async {
    try {
      final response = await _dio
          .post('/bud/common/top/manga', data: {'username': username});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CommonManga.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common top manga');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonTracks(String budUid) async {
    try {
      final response =
          await _dio.post('/bud/common/top/tracks', data: {'bud_id': budUid});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonArtists(String budUid) async {
    try {
      final response =
          await _dio.post('/bud/common/top/artists', data: {'bud_id': budUid});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common artists');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonGenres(String budUid) async {
    try {
      final response =
          await _dio.post('/bud/common/top/genres', data: {'bud_id': budUid});
      final List<dynamic> data = response.data['data'];
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
      final response =
          await _dio.post('/bud/common/all', data: {'username': username});
      return CategorizedCommonItems.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get categorized common items');
    }
  }
}
