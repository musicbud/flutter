import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/common_items_repository.dart';
import '../../domain/models/common_track.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_album.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/common_anime.dart';
import '../../domain/models/common_manga.dart';
import '../../domain/models/categorized_common_items.dart';
import '../data_sources/remote/common_items_remote_data_source.dart';

class CommonItemsRepositoryImpl implements CommonItemsRepository {
  final CommonItemsRemoteDataSource _remoteDataSource;

  CommonItemsRepositoryImpl(
      {required CommonItemsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<CommonTrack>>> getCommonLikedTracks(
      String username) async {
    try {
      final tracks = await _remoteDataSource.getCommonLikedTracks(username);
      return Right(tracks);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommonArtist>>> getCommonLikedArtists(
      String username) async {
    try {
      final artists = await _remoteDataSource.getCommonLikedArtists(username);
      return Right(artists);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommonAlbum>>> getCommonLikedAlbums(
      String username) async {
    try {
      final albums = await _remoteDataSource.getCommonLikedAlbums(username);
      return Right(albums);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommonTrack>>> getCommonPlayedTracks(
      String identifier,
      {int page = 1}) async {
    try {
      final tracks =
          await _remoteDataSource.getCommonPlayedTracks(identifier, page: page);
      return Right(tracks);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommonArtist>>> getCommonTopArtists(
      String username) async {
    try {
      final artists = await _remoteDataSource.getCommonTopArtists(username);
      return Right(artists);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommonGenre>>> getCommonTopGenres(
      String username) async {
    try {
      final genres = await _remoteDataSource.getCommonTopGenres(username);
      return Right(genres);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommonAnime>>> getCommonTopAnime(
      String username) async {
    try {
      final anime = await _remoteDataSource.getCommonTopAnime(username);
      return Right(anime);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommonManga>>> getCommonTopManga(
      String username) async {
    try {
      final manga = await _remoteDataSource.getCommonTopManga(username);
      return Right(manga);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommonTrack>>> getCommonTracks(
      String budUid) async {
    try {
      final tracks = await _remoteDataSource.getCommonTracks(budUid);
      return Right(tracks);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommonArtist>>> getCommonArtists(
      String budUid) async {
    try {
      final artists = await _remoteDataSource.getCommonArtists(budUid);
      return Right(artists);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommonGenre>>> getCommonGenres(
      String budUid) async {
    try {
      final genres = await _remoteDataSource.getCommonGenres(budUid);
      return Right(genres);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, CategorizedCommonItems>> getCategorizedCommonItems(
      String username) async {
    try {
      final items = await _remoteDataSource.getCategorizedCommonItems(username);
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
