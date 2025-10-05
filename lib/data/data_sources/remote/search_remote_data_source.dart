import 'package:dio/dio.dart';
import '../../../domain/models/search.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResults> performSearch({
    required String query,
    List<String>? types,
    Map<String, dynamic>? filters,
    int page = 1,
    int pageSize = 20,
  });
  
  Future<List<String>> getSearchSuggestions(String query);
  Future<List<String>> getRecentSearches({int limit = 10});
  Future<List<String>> getTrendingSearches({int limit = 10});
  Future<void> saveRecentSearch(String query);
  Future<void> clearRecentSearches();
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio client;

  SearchRemoteDataSourceImpl({required this.client});

  @override
  Future<SearchResults> performSearch({
    required String query,
    List<String>? types,
    Map<String, dynamic>? filters,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await client.get('/search', queryParameters: {
        'q': query,
        if (types != null && types.isNotEmpty) 'types': types.join(','),
        if (filters != null) ...filters,
        'page': page,
        'page_size': pageSize,
      });
      
      return SearchResults.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to perform search: $e');
    }
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final response = await client.get('/search/suggestions', queryParameters: {
        'q': query,
      });
      
      return List<String>.from(response.data['suggestions'] ?? []);
    } catch (e) {
      throw Exception('Failed to get search suggestions: $e');
    }
  }

  @override
  Future<List<String>> getRecentSearches({int limit = 10}) async {
    try {
      final response = await client.get('/search/recent', queryParameters: {
        'limit': limit,
      });
      
      return List<String>.from(response.data['searches'] ?? []);
    } catch (e) {
      throw Exception('Failed to get recent searches: $e');
    }
  }

  @override
  Future<List<String>> getTrendingSearches({int limit = 10}) async {
    try {
      final response = await client.get('/search/trending', queryParameters: {
        'limit': limit,
      });
      
      return List<String>.from(response.data['searches'] ?? []);
    } catch (e) {
      throw Exception('Failed to get trending searches: $e');
    }
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    try {
      await client.post('/search/recent', data: {
        'query': query,
      });
    } catch (e) {
      throw Exception('Failed to save recent search: $e');
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    try {
      await client.delete('/search/recent');
    } catch (e) {
      throw Exception('Failed to clear recent searches: $e');
    }
  }
}
