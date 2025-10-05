import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/error/exceptions.dart';
import '../../domain/models/search.dart';
import '../../config/constants.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResults> search({
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

  Future<void> saveRecentSearch(String query);
  Future<List<String>> getRecentSearches({int? limit});
  Future<void> clearRecentSearches();
  Future<List<String>> getTrendingSearches({int? limit});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final http.Client client;

  SearchRemoteDataSourceImpl({required this.client});

  @override
  Future<SearchResults> search({
    required String query,
    List<String>? types,
    Map<String, dynamic>? filters,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = {
      'q': query,
      if (types != null) 'types': types.join(','),
      if (filters != null) ...filters,
      if (page != null) 'page': page.toString(),
      if (pageSize != null) 'page_size': pageSize.toString(),
    };

    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/search')
          .replace(queryParameters: queryParams),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return SearchResults.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to perform search: ${response.statusCode}');
    }
  }

  @override
  Future<List<String>> getSuggestions({
    required String query,
    int? limit,
  }) async {
    final queryParams = {
      'q': query,
      if (limit != null) 'limit': limit.toString(),
    };

    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/search/suggestions')
          .replace(queryParameters: queryParams),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> suggestions = json.decode(response.body);
      return suggestions.cast<String>();
    } else {
      throw ServerException(message: 'Failed to get search suggestions: ${response.statusCode}');
    }
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/search/recent'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'query': query}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to save recent search: ${response.statusCode}');
    }
  }

  @override
  Future<List<String>> getRecentSearches({int? limit}) async {
    final queryParams = {
      if (limit != null) 'limit': limit.toString(),
    };

    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/search/recent')
          .replace(queryParameters: queryParams),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> searches = json.decode(response.body);
      return searches.cast<String>();
    } else {
      throw ServerException(message: 'Failed to get recent searches: ${response.statusCode}');
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}/search/recent'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to clear recent searches: ${response.statusCode}');
    }
  }

  @override
  Future<List<String>> getTrendingSearches({int? limit}) async {
    final queryParams = {
      if (limit != null) 'limit': limit.toString(),
    };

    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/search/trending')
          .replace(queryParameters: queryParams),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> searches = json.decode(response.body);
      return searches.cast<String>();
    } else {
      throw ServerException(message: 'Failed to get trending searches: ${response.statusCode}');
    }
  }
}
