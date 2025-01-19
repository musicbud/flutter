import '../models/bud_match.dart';
import '../models/common_track.dart';
import '../models/common_artist.dart';
import '../models/common_genre.dart';
import '../models/common_album.dart';
import '../../models/bud.dart';

/// Repository interface for managing bud-related operations.
abstract class BudRepository {
  /// Get a list of potential bud matches.
  Future<List<BudMatch>> getBudMatches();

  /// Send a bud request to a user.
  Future<void> sendBudRequest(String userId);

  /// Accept a bud request from a user.
  Future<void> acceptBudRequest(String userId);

  /// Reject a bud request from a user.
  Future<void> rejectBudRequest(String userId);

  /// Get common tracks with a bud.
  Future<List<CommonTrack>> getCommonTracks(String userId);

  /// Get common artists with a bud.
  Future<List<CommonArtist>> getCommonArtists(String userId);

  /// Get common genres with a bud.
  Future<List<CommonGenre>> getCommonGenres(String userId);

  /// Get common played tracks with a bud.
  Future<List<CommonTrack>> getCommonPlayedTracks(String userId);

  /// Remove a bud connection.
  Future<void> removeBud(String userId);

  /// Get buds by liked artists.
  Future<List<BudMatch>> getBudsByLikedArtists();

  /// Get buds by liked tracks.
  Future<List<BudMatch>> getBudsByLikedTracks();

  /// Get buds by liked genres.
  Future<List<BudMatch>> getBudsByLikedGenres();

  /// Get buds by liked albums.
  Future<List<BudMatch>> getBudsByLikedAlbums();

  /// Get buds by played tracks.
  Future<List<BudMatch>> getBudsByPlayedTracks();

  /// Get buds by top artists.
  Future<List<BudMatch>> getBudsByTopArtists();

  /// Get buds by top tracks.
  Future<List<BudMatch>> getBudsByTopTracks();

  /// Get buds by top genres.
  Future<List<BudMatch>> getBudsByTopGenres();

  /// Get buds by top anime.
  Future<List<BudMatch>> getBudsByTopAnime();

  /// Get buds by top manga.
  Future<List<BudMatch>> getBudsByTopManga();

  /// Get buds by artist.
  Future<List<BudMatch>> getBudsByArtist(String artistId);

  /// Get buds by track.
  Future<List<BudMatch>> getBudsByTrack(String trackId);

  /// Get buds by genre.
  Future<List<BudMatch>> getBudsByGenre(String genreId);

  /// Get buds by album.
  Future<List<BudMatch>> getBudsByAlbum(String albumId);

  /// Search for buds.
  Future<List<BudMatch>> searchBuds(String query);
}
