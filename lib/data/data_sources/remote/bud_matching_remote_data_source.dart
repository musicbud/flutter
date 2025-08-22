import '../../network/dio_client.dart';
import '../../../config/api_config.dart';

abstract class BudMatchingRemoteDataSource {
  Future<Map<String, dynamic>> searchBuds(String query, Map<String, dynamic>? filters);
  Future<Map<String, dynamic>> getBudProfile(String budId);
  Future<Map<String, dynamic>> getBudLikedContent(String contentType, String budId);
  Future<Map<String, dynamic>> getBudTopContent(String contentType, String budId);
  Future<Map<String, dynamic>> getBudPlayedTracks(String budId);
  Future<Map<String, dynamic>> getBudCommonLikedContent(String contentType, String budId);
  Future<Map<String, dynamic>> getBudCommonTopContent(String contentType, String budId);
  Future<Map<String, dynamic>> getBudCommonPlayedTracks(String budId);
  Future<Map<String, dynamic>> getBudSpecificContent(String contentType, String contentId, String budId);
}

class BudMatchingRemoteDataSourceImpl implements BudMatchingRemoteDataSource {
  final DioClient _dioClient;

  BudMatchingRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> searchBuds(String query, Map<String, dynamic>? filters) async {
    try {
      final Map<String, dynamic> queryParams = {'q': query};
      if (filters != null) {
        queryParams.addAll(filters);
      }

      final response = await _dioClient.get(ApiConfig.budSearch, queryParameters: queryParams);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to search buds: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudProfile(String budId) async {
    try {
      final response = await _dioClient.get(ApiConfig.budProfile);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get bud profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudLikedContent(String contentType, String budId) async {
    try {
      String endpoint;
      switch (contentType) {
        case 'artists':
          endpoint = ApiConfig.budLikedArtists;
          break;
        case 'tracks':
          endpoint = ApiConfig.budLikedTracks;
          break;
        case 'genres':
          endpoint = ApiConfig.budLikedGenres;
          break;
        case 'albums':
          endpoint = ApiConfig.budLikedAlbums;
          break;
        default:
          throw Exception('Unsupported content type: $contentType');
      }

      final response = await _dioClient.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get bud liked $contentType: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudTopContent(String contentType, String budId) async {
    try {
      String endpoint;
      switch (contentType) {
        case 'artists':
          endpoint = ApiConfig.budTopArtists;
          break;
        case 'tracks':
          endpoint = ApiConfig.budTopTracks;
          break;
        case 'genres':
          endpoint = ApiConfig.budTopGenres;
          break;
        case 'anime':
          endpoint = ApiConfig.budTopAnime;
          break;
        case 'manga':
          endpoint = ApiConfig.budTopManga;
          break;
        default:
          throw Exception('Unsupported content type: $contentType');
      }

      final response = await _dioClient.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get bud top $contentType: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudPlayedTracks(String budId) async {
    try {
      final response = await _dioClient.get(ApiConfig.budPlayedTracks);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get bud played tracks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudCommonLikedContent(String contentType, String budId) async {
    try {
      String endpoint;
      switch (contentType) {
        case 'artists':
          endpoint = ApiConfig.budCommonLikedArtists;
          break;
        case 'tracks':
          endpoint = ApiConfig.budCommonLikedTracks;
          break;
        case 'genres':
          endpoint = ApiConfig.budCommonLikedGenres;
          break;
        case 'albums':
          endpoint = ApiConfig.budCommonLikedAlbums;
          break;
        default:
          throw Exception('Unsupported content type: $contentType');
      }

      final response = await _dioClient.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get bud common liked $contentType: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudCommonTopContent(String contentType, String budId) async {
    try {
      String endpoint;
      switch (contentType) {
        case 'artists':
          endpoint = ApiConfig.budCommonTopArtists;
          break;
        case 'tracks':
          endpoint = ApiConfig.budCommonTopTracks;
          break;
        case 'genres':
          endpoint = ApiConfig.budCommonTopGenres;
          break;
        case 'anime':
          endpoint = ApiConfig.budCommonTopAnime;
          break;
        case 'manga':
          endpoint = ApiConfig.budCommonTopManga;
          break;
        default:
          throw Exception('Unsupported content type: $contentType');
      }

      final response = await _dioClient.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get bud common top $contentType: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudCommonPlayedTracks(String budId) async {
    try {
      final response = await _dioClient.get(ApiConfig.budCommonPlayedTracks);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get bud common played tracks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudSpecificContent(String contentType, String contentId, String budId) async {
    try {
      String endpoint;
      switch (contentType) {
        case 'artist':
          endpoint = ApiConfig.budArtist;
          break;
        case 'track':
          endpoint = ApiConfig.budTrack;
          break;
        case 'genre':
          endpoint = ApiConfig.budGenre;
          break;
        case 'album':
          endpoint = ApiConfig.budAlbum;
          break;
        default:
          throw Exception('Unsupported content type: $contentType');
      }

      final response = await _dioClient.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get bud specific $contentType: $e');
    }
  }
}