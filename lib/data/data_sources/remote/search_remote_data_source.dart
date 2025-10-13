import '../../network/dio_client.dart';
import '../../../models/search.dart';
import '../../../models/common_track.dart';
import '../../../models/common_artist.dart';
import '../../../models/common_album.dart';

/// Remote data source for search operations
abstract class SearchRemoteDataSource {
  Future<SearchResults> performSearch({
    required String query,
    List<String>? types,
    Map<String, dynamic>? filters,
    int? page,
    int? pageSize,
  });

  Future<List<String>> getSuggestions({
    required String query,
    int? limit,
  });

  Future<List<String>> getRecentSearches({int? limit});

  Future<List<String>> getTrendingSearches({int? limit});
  Future<List<String>> getSearchSuggestions(String query);
  Future<void> saveRecentSearch(String query);
  Future<void> clearRecentSearches();

  Future<SearchResult> search(
    String query, {
    String? type,
    int? limit,
    int? offset,
  });

  Future<List<CommonTrack>> searchTracks(
    String query, {
    int? limit,
    int? offset,
  });

  Future<List<CommonArtist>> searchArtists(
    String query, {
    int? limit,
    int? offset,
  });

  Future<List<CommonAlbum>> searchAlbums(
    String query, {
    int? limit,
    int? offset,
  });
}

/// Implementation of SearchRemoteDataSource
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient dioClient;

  SearchRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<SearchResults> performSearch({
    required String query,
    List<String>? types,
    Map<String, dynamic>? filters,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await dioClient.get('/v1/search', queryParameters: {
        'q': query,
        if (types != null) 'types': types.join(','),
        if (filters != null) ...filters,
        'page': page ?? 1,
        'limit': pageSize ?? 20,
      });
      return SearchResults.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to perform search: $e');
    }
  }

  @override
  Future<List<String>> getSuggestions({
    required String query,
    int? limit,
  }) async {
    try {
      final response =
          await dioClient.get('/v1/search/suggestions', queryParameters: {
        'q': query,
        if (limit != null) 'limit': limit,
      });
      return (response.data['suggestions'] as List).cast<String>();
    } catch (e) {
      throw Exception('Failed to get search suggestions: $e');
    }
  }

  @override
  Future<List<String>> getRecentSearches({int? limit}) async {
    try {
      final response =
          await dioClient.get('/v1/search/recent', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      return (response.data['recent'] as List).cast<String>();
    } catch (e) {
      throw Exception('Failed to get recent searches: $e');
    }
  }

  @override
  Future<List<String>> getTrendingSearches({int? limit}) async {
    try {
      final response =
          await dioClient.get('/v1/search/trending', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      return (response.data['trending'] as List).cast<String>();
    } catch (e) {
      throw Exception('Failed to get trending searches: $e');
    }
  }

  @override
  Future<SearchResult> search(
    String query, {
    String? type,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await dioClient.get('/v1/search', queryParameters: {
        'q': query,
        if (type != null) 'type': type,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      });
      return SearchResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }

  @override
  Future<List<CommonTrack>> searchTracks(
    String query, {
    int? limit,
    int? offset,
  }) async {
    try {
      final response =
          await dioClient.get('/v1/search/tracks', queryParameters: {
        'q': query,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      });
      return (response.data['items'] as List)
          .map((json) => CommonTrack.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search tracks: $e');
    }
  }

  @override
  Future<List<CommonArtist>> searchArtists(
    String query, {
    int? limit,
    int? offset,
  }) async {
    try {
      final response =
          await dioClient.get('/v1/search/artists', queryParameters: {
        'q': query,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      });
      return (response.data['items'] as List)
          .map((json) => CommonArtist.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search artists: $e');
    }
  }

  @override
  Future<List<CommonAlbum>> searchAlbums(
    String query, {
    int? limit,
    int? offset,
  }) async {
    try {
      final response =
          await dioClient.get('/v1/search/albums', queryParameters: {
        'q': query,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      });
      return (response.data['items'] as List)
          .map((json) => CommonAlbum.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search albums: $e');
    }
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final response =
          await dioClient.get('/v1/search/suggestions', queryParameters: {
        'q': query,
      });
      return List<String>.from(response.data);
    } catch (e) {
      throw Exception('Failed to get search suggestions: $e');
    }
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    try {
      await dioClient.post('/v1/search/recent', data: {
        'query': query,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to save recent search: $e');
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    try {
      await dioClient.delete('/v1/search/recent');
    } catch (e) {
      throw Exception('Failed to clear recent searches: $e');
    }
  }
}
