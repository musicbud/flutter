import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../models/search.dart';
import '../../domain/repositories/search_repository.dart';
import '../data_sources/remote/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SearchResults>> search({
    required String query,
    List<String>? types,
    Map<String, dynamic>? filters,
    int? page,
    int? pageSize,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.performSearch(
          query: query,
          types: types,
          filters: filters,
          page: page ?? 1,
          pageSize: pageSize ?? 20,
        );
        return Right(results);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSuggestions({
    required String query,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final suggestions = await remoteDataSource.getSearchSuggestions(query);
        // Apply limit if specified
        final limitedSuggestions = limit != null ? suggestions.take(limit).toList() : suggestions;
        return Right(limitedSuggestions);
        return Right(suggestions);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> saveRecentSearch(String query) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.saveRecentSearch(query);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSearches({int? limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final searches = await remoteDataSource.getRecentSearches(limit: limit ?? 10);
        return Right(searches);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> clearRecentSearches() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.clearRecentSearches();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getTrendingSearches({int? limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final searches = await remoteDataSource.getTrendingSearches(limit: limit ?? 10);
        return Right(searches);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
