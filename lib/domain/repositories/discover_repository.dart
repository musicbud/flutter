import '../../../models/discover_item.dart';
import '../../../models/track.dart';
import '../../../models/artist.dart';
import '../../../models/album.dart';
import '../../../models/genre.dart';
import '../../../models/common_anime.dart';
import '../../../models/common_manga.dart';

abstract class DiscoverRepository {
  /// Get available discovery categories
  Future<List<String>> getCategories();

  /// Get discover items for a specific category
  Future<List<DiscoverItem>> getDiscoverItems(String category);

  /// Track user interaction with discover items
  Future<void> trackInteraction({
    required String itemId,
    required String type,
    required String action,
  });

  /// Get user's top tracks
  Future<List<Track>> getTopTracks();

  /// Get user's top artists
  Future<List<Artist>> getTopArtists();

  /// Get user's top genres
  Future<List<Genre>> getTopGenres();

  /// Get user's top anime
  Future<List<CommonAnime>> getTopAnime();

  /// Get user's top manga
  Future<List<CommonManga>> getTopManga();

  /// Get user's liked tracks
  Future<List<Track>> getLikedTracks();

  /// Get user's liked artists
  Future<List<Artist>> getLikedArtists();

  /// Get user's liked genres
  Future<List<Genre>> getLikedGenres();

  /// Get user's liked albums
  Future<List<Album>> getLikedAlbums();

  /// Get user's played tracks
  Future<List<Track>> getPlayedTracks();
}
