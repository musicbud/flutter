import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../models/search.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResults>> search({
    required String query,
    List<String>? types,
    Map<String, dynamic>? filters,
    int? page,
    int? pageSize,
  });

  Future<Either<Failure, List<String>>> getSuggestions({
    required String query,
    int? limit,
  });

  Future<Either<Failure, void>> saveRecentSearch(String query);
  
  Future<Either<Failure, List<String>>> getRecentSearches({int? limit});
  
  Future<Either<Failure, void>> clearRecentSearches();
  
  Future<Either<Failure, List<String>>> getTrendingSearches({int? limit});
}
