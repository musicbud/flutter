import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../models/common_track.dart';
import '../../models/common_artist.dart';
import '../../models/common_album.dart';
import '../../models/common_genre.dart';
import '../../models/common_anime.dart';
import '../../models/common_manga.dart';
import '../../models/categorized_common_items.dart';

abstract class CommonItemsRepository {
  Future<Either<Failure, List<CommonTrack>>> getCommonLikedTracks(
      String username);
  Future<Either<Failure, List<CommonArtist>>> getCommonLikedArtists(
      String username);
  Future<Either<Failure, List<CommonAlbum>>> getCommonLikedAlbums(
      String username);
  Future<Either<Failure, List<CommonTrack>>> getCommonPlayedTracks(
      String identifier,
      {int page = 1});
  Future<Either<Failure, List<CommonArtist>>> getCommonTopArtists(
      String username);
  Future<Either<Failure, List<CommonGenre>>> getCommonTopGenres(
      String username);
  Future<Either<Failure, List<CommonAnime>>> getCommonTopAnime(String username);
  Future<Either<Failure, List<CommonManga>>> getCommonTopManga(String username);
  Future<Either<Failure, List<CommonTrack>>> getCommonTracks(String budUid);
  Future<Either<Failure, List<CommonArtist>>> getCommonArtists(String budUid);
  Future<Either<Failure, List<CommonGenre>>> getCommonGenres(String budUid);
  Future<Either<Failure, CategorizedCommonItems>> getCategorizedCommonItems(
      String username);
}
