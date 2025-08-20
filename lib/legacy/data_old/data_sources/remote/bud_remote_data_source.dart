import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../models/bud.dart';

abstract class BudRemoteDataSource {
  // Search
  Future<List<Bud>> searchBuds(String query);
  Future<Map<String, dynamic>> getBudProfile(String username);

  // Common liked content
  Future<List<Bud>> getBudsByLikedArtists();
  Future<List<Bud>> getBudsByLikedTracks();
  Future<List<Bud>> getBudsByLikedGenres();
  Future<List<Bud>> getBudsByLikedAlbums();
  Future<List<Bud>> getBudsByPlayedTracks();

  // Common top content
  Future<List<Bud>> getBudsByTopArtists();
  Future<List<Bud>> getBudsByTopTracks();
  Future<List<Bud>> getBudsByTopGenres();
  Future<List<Bud>> getBudsByTopAnime();
  Future<List<Bud>> getBudsByTopManga();
}

class BudRemoteDataSourceImpl implements BudRemoteDataSource {
  final DioClient _dioClient;

  BudRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<Bud>> searchBuds(String query) async {
    try {
      final response =
          await _dioClient.get('/bud/search', queryParameters: {'q': query});
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
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

  @override
  Future<List<Bud>> getBudsByLikedArtists() async {
    try {
      final response = await _dioClient.get('/bud/common/liked/artists');
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked artists');
    }
  }

  @override
  Future<List<Bud>> getBudsByLikedTracks() async {
    try {
      final response = await _dioClient.get('/bud/common/liked/tracks');
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked tracks');
    }
  }

  @override
  Future<List<Bud>> getBudsByLikedGenres() async {
    try {
      final response = await _dioClient.get('/bud/common/liked/genres');
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked genres');
    }
  }

  @override
  Future<List<Bud>> getBudsByLikedAlbums() async {
    try {
      final response = await _dioClient.get('/bud/common/liked/albums');
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by liked albums');
    }
  }

  @override
  Future<List<Bud>> getBudsByPlayedTracks() async {
    try {
      final response = await _dioClient.get('/bud/common/played/tracks');
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by played tracks');
    }
  }

  @override
  Future<List<Bud>> getBudsByTopArtists() async {
    try {
      final response = await _dioClient.get('/bud/common/top/artists');
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top artists');
    }
  }

  @override
  Future<List<Bud>> getBudsByTopTracks() async {
    try {
      final response = await _dioClient.get('/bud/common/top/tracks');
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top tracks');
    }
  }

  @override
  Future<List<Bud>> getBudsByTopGenres() async {
    try {
      final response = await _dioClient.get('/bud/common/top/genres');
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top genres');
    }
  }

  @override
  Future<List<Bud>> getBudsByTopAnime() async {
    try {
      final response = await _dioClient.get('/bud/common/top/anime');
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top anime');
    }
  }

  @override
  Future<List<Bud>> getBudsByTopManga() async {
    try {
      final response = await _dioClient.get('/bud/common/top/manga');
      return (response.data as List).map((json) => Bud.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get buds by top manga');
    }
  }
}
