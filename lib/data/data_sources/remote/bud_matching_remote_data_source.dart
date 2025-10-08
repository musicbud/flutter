import '../../network/dio_client.dart';
import '../../../config/api_config.dart';

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

  BudMatchingRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> fetchBudProfile(String budId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.budProfile}/$budId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch bud profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTopArtists() async {
    try {
      final response = await _dioClient.get(ApiConfig.budTopArtists);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by top artists: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTopTracks() async {
    try {
      final response = await _dioClient.get(ApiConfig.budTopTracks);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by top tracks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTopGenres() async {
    try {
      final response = await _dioClient.get(ApiConfig.budTopGenres);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by top genres: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTopAnime() async {
    try {
      final response = await _dioClient.get(ApiConfig.budTopAnime);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by top anime: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTopManga() async {
    try {
      final response = await _dioClient.get(ApiConfig.budTopManga);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by top manga: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByLikedArtists() async {
    try {
      final response = await _dioClient.get(ApiConfig.budLikedArtists);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by liked artists: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByLikedTracks() async {
    try {
      final response = await _dioClient.get(ApiConfig.budLikedTracks);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by liked tracks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByLikedGenres() async {
    try {
      final response = await _dioClient.get(ApiConfig.budLikedGenres);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by liked genres: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByLikedAlbums() async {
    try {
      final response = await _dioClient.get(ApiConfig.budLikedAlbums);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by liked albums: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByLikedAio() async {
    try {
      final response = await _dioClient.get(ApiConfig.budLikedAio);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by liked aio: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByPlayedTracks() async {
    try {
      final response = await _dioClient.get(ApiConfig.budPlayedTracks);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by played tracks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByArtist(String artistId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.budArtist}/$artistId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by artist: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByTrack(String trackId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.budTrack}/$trackId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by track: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> findBudsByGenre(String genreId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.budGenre}/$genreId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to find buds by genre: $e');
    }
  }
}