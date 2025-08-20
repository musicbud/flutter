import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../models/bud.dart';
import '../../../domain/models/bud_match.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_genre.dart';

abstract class BudRemoteDataSource {
  // Bud management
  Future<List<BudMatch>> getBudMatches();
  Future<void> sendBudRequest(String userId);
  Future<void> acceptBudRequest(String userId);
  Future<void> rejectBudRequest(String userId);
  Future<void> removeBud(String userId);

  // Common content
  Future<List<CommonTrack>> getCommonTracks(String userId);
  Future<List<CommonArtist>> getCommonArtists(String userId);
  Future<List<CommonGenre>> getCommonGenres(String userId);
  Future<List<CommonTrack>> getCommonPlayedTracks(String userId);

  // Common liked content
  Future<List<BudMatch>> getBudsByLikedArtists();
  Future<List<BudMatch>> getBudsByLikedTracks();
  Future<List<BudMatch>> getBudsByLikedGenres();
  Future<List<BudMatch>> getBudsByLikedAlbums();
  Future<List<BudMatch>> getBudsByPlayedTracks();

  // Common top content
  Future<List<BudMatch>> getBudsByTopArtists();
  Future<List<BudMatch>> getBudsByTopTracks();
  Future<List<BudMatch>> getBudsByTopGenres();
  Future<List<BudMatch>> getBudsByTopAnime();
  Future<List<BudMatch>> getBudsByTopManga();

  // Get buds by specific content
  Future<List<BudMatch>> getBudsByArtist(String artistId);
  Future<List<BudMatch>> getBudsByTrack(String trackId);
  Future<List<BudMatch>> getBudsByGenre(String genreId);
  Future<List<BudMatch>> getBudsByAlbum(String albumId);

  // Search
  Future<List<BudMatch>> searchBuds(String query);
  Future<Map<String, dynamic>> getBudProfile(String username);
}

class BudRemoteDataSourceImpl implements BudRemoteDataSource {
  final DioClient _dioClient;

  BudRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<BudMatch>> getBudMatches() async {
    try {
      final response = await _dioClient.get('/bud/matches');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get bud matches');
    }
  }

  @override
  Future<void> sendBudRequest(String userId) async {
    try {
      await _dioClient.post('/bud/request', data: {'userId': userId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to send bud request');
    }
  }

  @override
  Future<void> acceptBudRequest(String userId) async {
    try {
      await _dioClient.post('/bud/accept', data: {'userId': userId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to accept bud request');
    }
  }

  @override
  Future<void> rejectBudRequest(String userId) async {
    try {
      await _dioClient.post('/bud/reject', data: {'userId': userId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to reject bud request');
    }
  }

  @override
  Future<void> removeBud(String userId) async {
    try {
      await _dioClient.delete('/bud/remove', queryParameters: {'userId': userId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove bud');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonTracks(String userId) async {
    try {
      final response = await _dioClient.get('/bud/common/tracks', queryParameters: {'userId': userId});
      return (response.data as List).map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get common tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonArtists(String userId) async {
    try {
      final response = await _dioClient.get('/bud/common/artists', queryParameters: {'userId': userId});
      return (response.data as List).map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get common artists');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonGenres(String userId) async {
    try {
      final response = await _dioClient.get('/bud/common/genres', queryParameters: {'userId': userId});
      return (response.data as List).map((json) => CommonGenre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get common genres');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonPlayedTracks(String userId) async {
    try {
      final response = await _dioClient.get('/bud/common/played/tracks', queryParameters: {'userId': userId});
      return (response.data as List).map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get common played tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedArtists() async {
    try {
      final response = await _dioClient.get('/bud/common/liked/artists');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked artists');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedTracks() async {
    try {
      final response = await _dioClient.get('/bud/common/liked/tracks');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedGenres() async {
    try {
      final response = await _dioClient.get('/bud/common/liked/genres');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked genres');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedAlbums() async {
    try {
      final response = await _dioClient.get('/bud/common/liked/albums');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked albums');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByPlayedTracks() async {
    try {
      final response = await _dioClient.get('/bud/common/played/tracks');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by played tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopArtists() async {
    try {
      final response = await _dioClient.get('/bud/common/top/artists');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top artists');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopTracks() async {
    try {
      final response = await _dioClient.get('/bud/common/top/tracks');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopGenres() async {
    try {
      final response = await _dioClient.get('/bud/common/top/genres');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top genres');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopAnime() async {
    try {
      final response = await _dioClient.get('/bud/common/top/anime');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top anime');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopManga() async {
    try {
      final response = await _dioClient.get('/bud/common/top/manga');
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top manga');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByArtist(String artistId) async {
    try {
      final response = await _dioClient.get('/bud/common/artist', queryParameters: {'artistId': artistId});
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by artist');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTrack(String trackId) async {
    try {
      final response = await _dioClient.get('/bud/common/track', queryParameters: {'trackId': trackId});
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by track');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByGenre(String genreId) async {
    try {
      final response = await _dioClient.get('/bud/common/genre', queryParameters: {'genreId': genreId});
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by genre');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByAlbum(String albumId) async {
    try {
      final response = await _dioClient.get('/bud/common/album', queryParameters: {'albumId': albumId});
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by album');
    }
  }

  @override
  Future<List<BudMatch>> searchBuds(String query) async {
    try {
      final response =
          await _dioClient.get('/bud/search', queryParameters: {'q': query});
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search buds');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudProfile(String username) async {
    try {
      final response = await _dioClient
          .get('/bud/profile', queryParameters: {'username': username});
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get bud profile');
    }
  }
}
