import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../models/bud_match.dart';
import '../../../models/common_track.dart';
import '../../../models/common_artist.dart';
import '../../../models/common_genre.dart';
import '../../../models/common_anime.dart';
import '../../../models/common_manga.dart';
import '../../../config/api_config.dart';
import '../../../services/endpoint_config_service.dart';

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

  // Get bud's top content
  Future<List<CommonAnime>> getBudTopAnime(String username);
  Future<List<CommonManga>> getBudTopManga(String username);
  Future<Map<String, dynamic>> getBudLikedAio(String username);
}

class BudRemoteDataSourceImpl implements BudRemoteDataSource {
  final DioClient _dioClient;
  final EndpointConfigService _endpointConfigService;

  BudRemoteDataSourceImpl({
    required DioClient dioClient,
    required EndpointConfigService endpointConfigService,
  }) : _dioClient = dioClient,
       _endpointConfigService = endpointConfigService;

  @override
  Future<List<BudMatch>> getBudMatches() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - search', ApiConfig.baseUrl) ?? ApiConfig.budSearch;
      final response = await _dioClient.get(url);
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get bud matches');
    }
  }

  @override
  Future<void> sendBudRequest(String userId) async {
    try {
      await _dioClient.post(ApiConfig.budSearch, data: {'userId': userId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to send bud request');
    }
  }

  @override
  Future<void> acceptBudRequest(String userId) async {
    try {
      await _dioClient.post(ApiConfig.budSearch, data: {'userId': userId, 'action': 'accept'});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to accept bud request');
    }
  }

  @override
  Future<void> rejectBudRequest(String userId) async {
    try {
      await _dioClient.post(ApiConfig.budSearch, data: {'userId': userId, 'action': 'reject'});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to reject bud request');
    }
  }

  @override
  Future<void> removeBud(String userId) async {
    try {
      await _dioClient.post(ApiConfig.budSearch, data: {'userId': userId, 'action': 'remove'});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove bud');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonTracks(String userId) async {
    try {
      final response = await _dioClient.post(ApiConfig.budCommonLikedTracks, data: {'userId': userId});
      return (response.data as List).map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get common tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonArtists(String userId) async {
    try {
      final response = await _dioClient.post(ApiConfig.budCommonLikedArtists, data: {'userId': userId});
      return (response.data as List).map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get common artists');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonGenres(String userId) async {
    try {
      final response = await _dioClient.post(ApiConfig.budCommonLikedGenres, data: {'userId': userId});
      return (response.data as List).map((json) => CommonGenre.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get common genres');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonPlayedTracks(String userId) async {
    try {
      final response = await _dioClient.post(ApiConfig.budCommonPlayedTracks, data: {'userId': userId});
      return (response.data as List).map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get common played tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedArtists() async {
    try {
      // Use POST method as per Postman collection
      final response = await _dioClient.post(ApiConfig.budLikedArtists, data: {});
      
      // Handle backend response structure from Postman collection
      if (response.data != null && response.data['data'] != null) {
        final budsData = response.data['data']['buds'] as List? ?? [];
        return budsData.map((json) => BudMatch.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by liked artists');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedTracks() async {
    try {
      // Use POST method as per Postman collection
      final response = await _dioClient.post(ApiConfig.budLikedTracks, data: {});
      
      // Handle backend response structure from Postman collection
      if (response.data != null && response.data['data'] != null) {
        final budsData = response.data['data']['buds'] as List? ?? [];
        return budsData.map((json) => BudMatch.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by liked tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedGenres() async {
    try {
      final response = await _dioClient.get(ApiConfig.budCommonLikedGenres);
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by liked genres');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByLikedAlbums() async {
    try {
      final response = await _dioClient.get(ApiConfig.budCommonLikedAlbums);
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by liked albums');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByPlayedTracks() async {
    try {
      final response = await _dioClient.get(ApiConfig.budCommonPlayedTracks);
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by played tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopArtists() async {
    try {
      // Use EndpointConfigService for URL and method
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by top artists', ApiConfig.baseUrl) ?? ApiConfig.budTopArtists;
      final method = _endpointConfigService.getEndpointMethod('buds - get buds by top artists') ?? 'POST';
      
      final response = method.toUpperCase() == 'GET'
          ? await _dioClient.get(url)
          : await _dioClient.post(url, data: {});
      
      // Handle backend response structure from Postman collection
      if (response.data != null && response.data['data'] != null) {
        final budsData = response.data['data']['buds'] as List? ?? [];
        return budsData.map((json) => BudMatch.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by top artists');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopTracks() async {
    try {
      // Use POST method as per Postman collection
      final response = await _dioClient.post(ApiConfig.budTopTracks, data: {});
      
      // Handle backend response structure from Postman collection
      if (response.data != null && response.data['data'] != null) {
        final budsData = response.data['data']['buds'] as List? ?? [];
        return budsData.map((json) => BudMatch.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by top tracks');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopGenres() async {
    try {
      final response = await _dioClient.get(ApiConfig.budCommonTopGenres);
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by top genres');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopAnime() async {
    try {
      final response = await _dioClient.get(ApiConfig.budCommonTopAnime);
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by top anime');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTopManga() async {
    try {
      final response = await _dioClient.get(ApiConfig.budCommonTopManga);
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by top manga');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByArtist(String artistId) async {
    try {
      final response = await _dioClient.get(ApiConfig.budArtist, queryParameters: {'artistId': artistId});
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by artist');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByTrack(String trackId) async {
    try {
      final response = await _dioClient.post(ApiConfig.budTrack, data: {'track_id': trackId});
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException {
      // Endpoint not implemented, return empty list
      return [];
    }
  }

  @override
  Future<List<BudMatch>> getBudsByGenre(String genreId) async {
    try {
      final response = await _dioClient.get(ApiConfig.budGenre, queryParameters: {'genreId': genreId});
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by genre');
    }
  }

  @override
  Future<List<BudMatch>> getBudsByAlbum(String albumId) async {
    try {
      final response = await _dioClient.get(ApiConfig.budAlbum, queryParameters: {'albumId': albumId});
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get buds by album');
    }
  }

  @override
  Future<List<BudMatch>> searchBuds(String query) async {
    try {
      final response = await _dioClient.get(ApiConfig.budSearch, queryParameters: {'q': query});
      return (response.data as List).map((json) => BudMatch.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search buds');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudProfile(String username) async {
    try {
      // Use EndpointConfigService for URL and method
      final url = _endpointConfigService.getEndpointUrl('buds - get bud profile', ApiConfig.baseUrl) ?? ApiConfig.budProfile;
      final method = _endpointConfigService.getEndpointMethod('buds - get bud profile') ?? 'POST';
      
      final response = method.toUpperCase() == 'GET'
          ? await _dioClient.get(url, queryParameters: {'bud_id': username})
          : await _dioClient.post(url, data: {'bud_id': username});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get bud profile');
    }
  }

  @override
  Future<List<CommonAnime>> getBudTopAnime(String username) async {
    try {
      final response = await _dioClient.get(ApiConfig.budTopAnime, queryParameters: {'username': username});
      return (response.data as List).map((json) => CommonAnime.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get bud top anime');
    }
  }

  @override
  Future<List<CommonManga>> getBudTopManga(String username) async {
    try {
      final response = await _dioClient.get(ApiConfig.budTopManga, queryParameters: {'username': username});
      return (response.data as List).map((json) => CommonManga.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get bud top manga');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudLikedAio(String username) async {
    try {
      final response = await _dioClient.get(ApiConfig.budLikedAio, queryParameters: {'username': username});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get bud liked aio');
    }
  }
}
