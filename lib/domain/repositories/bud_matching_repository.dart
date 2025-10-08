import '../../models/bud_profile.dart';
import '../../models/bud_search_result.dart';

abstract class BudMatchingRepository {
  /// Fetch detailed bud profile with common content
  Future<BudProfile> fetchBudProfile(String budId);

  /// Find buds by top artists
  Future<BudSearchResult> findBudsByTopArtists();

  /// Find buds by top tracks
  Future<BudSearchResult> findBudsByTopTracks();

  /// Find buds by top genres
  Future<BudSearchResult> findBudsByTopGenres();

  /// Find buds by top anime
  Future<BudSearchResult> findBudsByTopAnime();

  /// Find buds by top manga
  Future<BudSearchResult> findBudsByTopManga();

  /// Find buds by liked artists
  Future<BudSearchResult> findBudsByLikedArtists();

  /// Find buds by liked tracks
  Future<BudSearchResult> findBudsByLikedTracks();

  /// Find buds by liked genres
  Future<BudSearchResult> findBudsByLikedGenres();

  /// Find buds by liked albums
  Future<BudSearchResult> findBudsByLikedAlbums();

  /// Find buds by liked all-in-one
  Future<BudSearchResult> findBudsByLikedAio();

  /// Find buds by played tracks
  Future<BudSearchResult> findBudsByPlayedTracks();

  /// Find buds by specific artist
  Future<BudSearchResult> findBudsByArtist(String artistId);

  /// Find buds by specific track
  Future<BudSearchResult> findBudsByTrack(String trackId);

  /// Find buds by specific genre
  Future<BudSearchResult> findBudsByGenre(String genreId);
}