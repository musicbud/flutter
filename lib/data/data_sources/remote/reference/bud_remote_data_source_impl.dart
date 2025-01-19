import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../domain/models/bud_match.dart';
import '../../../../domain/models/common_track.dart';
import '../../../../domain/models/common_artist.dart';
import '../../../../domain/models/common_genre.dart';
import '../../../network/dio_client.dart';
import 'bud_remote_data_source.dart';

/// Implementation of the BudRemoteDataSource interface.
class BudRemoteDataSourceImpl implements BudRemoteDataSource {
  final DioClient _dioClient;

  BudRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<BudMatch>> getBudMatches() async {
    try {
      final response = await _dioClient.get('/buds/matches');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get bud matches');
    }
  }

  @override
  Future<void> sendBudRequest(String userId) async {
    try {
      await _dioClient.post('/buds/requests/$userId/send');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to send bud request');
    }
  }

  @override
  Future<void> acceptBudRequest(String userId) async {
    try {
      await _dioClient.post('/buds/requests/$userId/accept');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to accept bud request');
    }
  }

  @override
  Future<void> rejectBudRequest(String userId) async {
    try {
      await _dioClient.post('/buds/requests/$userId/reject');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to reject bud request');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonTracks(String userId) async {
    try {
      final response = await _dioClient.get('/buds/$userId/common/tracks');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonArtists(String userId) async {
    try {
      final response = await _dioClient.get('/buds/$userId/common/artists');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common artists');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonGenres(String userId) async {
    try {
      final response = await _dioClient.get('/buds/$userId/common/genres');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonGenre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common genres');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonPlayedTracks(String userId) async {
    try {
      final response = await _dioClient.get('/buds/$userId/common/played');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get common played tracks');
    }
  }

  @override
  Future<void> removeBud(String userId) async {
    try {
      await _dioClient.delete('/buds/$userId');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove bud');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedArtists() async {
    try {
      final response = await _dioClient.get('/buds/liked/artists');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked artists');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedTracks() async {
    try {
      final response = await _dioClient.get('/buds/liked/tracks');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedGenres() async {
    try {
      final response = await _dioClient.get('/buds/liked/genres');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked genres');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedAlbums() async {
    try {
      final response = await _dioClient.get('/buds/liked/albums');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked albums');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByPlayedTracks() async {
    try {
      final response = await _dioClient.get('/buds/played/tracks');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by played tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopArtists() async {
    try {
      final response = await _dioClient.get('/buds/top/artists');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top artists');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopTracks() async {
    try {
      final response = await _dioClient.get('/buds/top/tracks');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopGenres() async {
    try {
      final response = await _dioClient.get('/buds/top/genres');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top genres');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopAnime() async {
    try {
      final response = await _dioClient.get('/buds/top/anime');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top anime');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopManga() async {
    try {
      final response = await _dioClient.get('/buds/top/manga');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top manga');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByArtist(String artistId) async {
    try {
      final response = await _dioClient.get('/buds/artists/$artistId');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by artist');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTrack(String trackId) async {
    try {
      final response = await _dioClient.get('/buds/tracks/$trackId');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by track');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByGenre(String genreId) async {
    try {
      final response = await _dioClient.get('/buds/genres/$genreId');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by genre');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByAlbum(String albumId) async {
    try {
      final response = await _dioClient.get('/buds/albums/$albumId');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by album');
    }
  }

  @override
  Future<List<BudMatch>> searchBuds(String query) async {
    try {
      final response =
          await _dioClient.get('/buds/search', queryParameters: {'q': query});
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search buds');
    }
  }
}
