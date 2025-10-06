import '../../models/track.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/spotify_device.dart';
import '../../models/common_anime.dart';
import '../../models/common_manga.dart';

/// Interface for content-related operations
abstract class ContentRepository {
  // Spotify-related methods
  Future<List<Track>> getPlayedTracks();
  Future<List<Track>> getPlayedTracksWithLocation();
  Future<List<SpotifyDevice>> getSpotifyDevices();
  Future<void> controlSpotifyPlayback(String command, String deviceId);
  Future<void> setSpotifyVolume(String deviceId, int volume);
  Future<void> saveTrackLocation(
      String trackId, double latitude, double longitude);
  Future<void> playTrack(String trackId, String deviceId);
  Future<void> playTrackWithLocation(
      String trackId, String trackName, double latitude, double longitude);
  Future<void> savePlayedTrack(String trackId);

  // Popular items methods
  Future<List<Track>> getPopularTracks();
  Future<List<Artist>> getPopularArtists();
  Future<List<Album>> getPopularAlbums();
  Future<List<CommonAnime>> getPopularAnime();
  Future<List<CommonManga>> getPopularManga();

  // Top items methods
  Future<List<Track>> getTopTracks();
  Future<List<Artist>> getTopArtists();
  Future<List<Genre>> getTopGenres();
  Future<List<CommonAnime>> getTopAnime();
  Future<List<CommonManga>> getTopManga();

  // Liked items methods
  Future<List<Track>> getLikedTracks();
  Future<List<Artist>> getLikedArtists();
  Future<List<Album>> getLikedAlbums();
  Future<List<Genre>> getLikedGenres();

  // Like/Unlike methods
  Future<void> likeTrack(String trackId);
  Future<void> unlikeTrack(String trackId);
  Future<void> likeArtist(String artistId);
  Future<void> unlikeArtist(String artistId);
  Future<void> likeAlbum(String albumId);
  Future<void> unlikeAlbum(String albumId);
  Future<void> likeGenre(String genreId);
  Future<void> unlikeGenre(String genreId);
  Future<void> likeAnime(String animeId);
  Future<void> unlikeAnime(String animeId);
  Future<void> likeManga(String mangaId);
  Future<void> unlikeManga(String mangaId);

  // Search methods
  Future<List<Track>> searchTracks(String query);
  Future<List<Artist>> searchArtists(String query);
  Future<List<Album>> searchAlbums(String query);
  Future<List<Genre>> searchGenres(String query);
  Future<List<CommonAnime>> searchAnime(String query);
  Future<List<CommonManga>> searchManga(String query);

  // Details methods
  Future<Track> getTrackDetails(String trackId);
  Future<Artist> getArtistDetails(String artistId);
  Future<Album> getAlbumDetails(String albumId);
  Future<Genre> getGenreDetails(String genreId);
  Future<CommonAnime> getAnimeDetails(String animeId);
  Future<CommonManga> getMangaDetails(String mangaId);

  // Category methods
  Future<List<dynamic>> getTopItems(String category);
  Future<List<dynamic>> getLikedItems(String category);

  // Toggle methods
  Future<void> toggleTrackLike(String trackId);
  Future<void> toggleArtistLike(String artistId);
  Future<void> toggleAlbumLike(String albumId);
  Future<void> toggleGenreLike(String genreId);
  Future<void> toggleAnimeLike(String animeId);
  Future<void> toggleMangaLike(String mangaId);

  // Update methods
  Future<void> updateLikes(String type, String id, bool isLiked);

  // Unified toggle method
  Future<void> toggleLike(String id, String type);

  // Play track on specific service
  Future<void> playTrackOnService(String trackIdentifier, {String? service});
}
