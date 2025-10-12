import '../../network/dio_client.dart';
import '../../../config/api_config.dart';
import '../../../services/endpoint_config_service.dart';

abstract class BudMatchingRemoteDataSource {
  Future<Map<String, dynamic>> fetchBudProfile(String budId);
  Future<Map<String, dynamic>> findBudsByTopArtists();
  Future<Map<String, dynamic>> findBudsByTopTracks();
  Future<Map<String, dynamic>> findBudsByTopGenres();
  Future<Map<String, dynamic>> findBudsByTopAnime();
  Future<Map<String, dynamic>> findBudsByTopManga();
  Future<Map<String, dynamic>> findBudsByLikedArtists();
  Future<Map<String, dynamic>> findBudsByLikedTracks();
  Future<Map<String, dynamic>> findBudsByLikedGenres();
  Future<Map<String, dynamic>> findBudsByLikedAlbums();
  Future<Map<String, dynamic>> findBudsByLikedAio();
  Future<Map<String, dynamic>> findBudsByPlayedTracks();
  Future<Map<String, dynamic>> findBudsByArtist(String artistId);
  Future<Map<String, dynamic>> findBudsByTrack(String trackId);
  Future<Map<String, dynamic>> findBudsByGenre(String genreId);
}

class BudMatchingRemoteDataSourceImpl implements BudMatchingRemoteDataSource {
  final DioClient _dioClient;
  final EndpointConfigService _endpointConfigService;

  BudMatchingRemoteDataSourceImpl({
    required DioClient dioClient,
    required EndpointConfigService endpointConfigService,
  }) : _dioClient = dioClient,
       _endpointConfigService = endpointConfigService;

  @override
  Future<Map<String, dynamic>> fetchBudProfile(String budId) async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get bud profile', ApiConfig.baseUrl) ?? ApiConfig.budProfile;
      // Backend expects POST with bud_id in body
      final response = await _dioClient.post(url, data: { 'bud_id': budId });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch bud profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTopArtists() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by top artists', ApiConfig.baseUrl) ?? ApiConfig.budTopArtists;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by top artists: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTopTracks() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by top tracks', ApiConfig.baseUrl) ?? ApiConfig.budTopTracks;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by top tracks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTopGenres() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by top genres', ApiConfig.baseUrl) ?? ApiConfig.budTopGenres;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by top genres: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTopAnime() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by top anime', ApiConfig.baseUrl) ?? ApiConfig.budTopAnime;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by top anime: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTopManga() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by top manga', ApiConfig.baseUrl) ?? ApiConfig.budTopManga;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by top manga: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByLikedArtists() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by liked artists', ApiConfig.baseUrl) ?? ApiConfig.budLikedArtists;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by liked artists: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByLikedTracks() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by liked tracks', ApiConfig.baseUrl) ?? ApiConfig.budLikedTracks;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by liked tracks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByLikedGenres() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by liked genres', ApiConfig.baseUrl) ?? ApiConfig.budLikedGenres;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by liked genres: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByLikedAlbums() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by liked albums', ApiConfig.baseUrl) ?? ApiConfig.budLikedAlbums;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by liked albums: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByLikedAio() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by liked aio', ApiConfig.baseUrl) ?? ApiConfig.budLikedAio;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by liked aio: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByPlayedTracks() async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by played tracks', ApiConfig.baseUrl) ?? ApiConfig.budPlayedTracks;
      final response = await _dioClient.post(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by played tracks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByArtist(String artistId) async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by artist', ApiConfig.baseUrl) ?? ApiConfig.budArtist;
      final response = await _dioClient.post(url, data: { 'artist_id': artistId });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by artist: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTrack(String trackId) async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by track', ApiConfig.baseUrl) ?? ApiConfig.budTrack;
      final response = await _dioClient.post(url, data: { 'track_id': trackId });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      // Endpoint not implemented, return empty result
      return {'buds': [], 'message': 'Endpoint not implemented'};
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByGenre(String genreId) async {
    try {
      final url = _endpointConfigService.getEndpointUrl('buds - get buds by genre', ApiConfig.baseUrl) ?? ApiConfig.budGenre;
      final response = await _dioClient.post(url, data: { 'genre_id': genreId });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by genre: $e');
    }
  }
}