import '../models/common_track.dart';
import '../models/common_artist.dart';
import '../models/common_album.dart';
import '../models/common_genre.dart';
import '../models/common_anime.dart';
import '../models/common_manga.dart';

abstract class ContentRepository {
  // Home page
  Future<Map<String, dynamic>> getHomePageData();

  // Popular content
  Future<List<CommonTrack>> getPopularTracks({int limit = 20});
  Future<List<CommonArtist>> getPopularArtists({int limit = 20});
  Future<List<CommonAlbum>> getPopularAlbums({int limit = 20});
  Future<List<CommonAnime>> getPopularAnime({int limit = 20});
  Future<List<CommonManga>> getPopularManga({int limit = 20});

  // Top content
  Future<List<CommonTrack>> getTopTracks();
  Future<List<CommonArtist>> getTopArtists();
  Future<List<CommonGenre>> getTopGenres();
  Future<List<CommonAnime>> getTopAnime();
  Future<List<CommonManga>> getTopManga();

  // Liked content
  Future<List<CommonTrack>> getLikedTracks();
  Future<List<CommonArtist>> getLikedArtists();
  Future<List<CommonAlbum>> getLikedAlbums();
  Future<List<CommonGenre>> getLikedGenres();

  // Played content
  Future<List<CommonTrack>> getPlayedTracks();
  Future<List<CommonTrack>> getPlayedTracksWithLocation();
  Future<List<CommonTrack>> getCurrentlyPlayedTracks();

  // Like/Unlike operations
  Future<bool> likeTrack(String id);
  Future<bool> likeArtist(String id);
  Future<bool> likeAlbum(String id);
  Future<bool> likeGenre(String id);
  Future<bool> likeAnime(String id);
  Future<bool> likeManga(String id);
  Future<bool> unlikeTrack(String id);
  Future<bool> unlikeArtist(String id);
  Future<bool> unlikeAlbum(String id);
  Future<bool> unlikeGenre(String id);
  Future<bool> unlikeAnime(String id);
  Future<bool> unlikeManga(String id);

  // Search operations
  Future<List<CommonTrack>> searchTracks(String query);
  Future<List<CommonArtist>> searchArtists(String query);
  Future<List<CommonAlbum>> searchAlbums(String query);
  Future<List<CommonGenre>> searchGenres(String query);
  Future<List<CommonAnime>> searchAnime(String query);
  Future<List<CommonManga>> searchManga(String query);

  // Playback operations
  Future<List<String>> getSpotifyDevices();
  Future<void> playTrack(String trackId, {String? deviceId});
  Future<void> playTrackWithLocation(
      String trackId, double latitude, double longitude);
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude);
}
