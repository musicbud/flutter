import '../models/common_track.dart';
import '../models/spotify_device.dart';
import '../models/common_artist.dart';
import '../models/common_genre.dart';
import '../models/common_album.dart';
import '../models/common_anime.dart';
import '../models/common_manga.dart';
import '../models/track.dart';

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
      String trackId, String deviceId, double latitude, double longitude);
  Future<void> savePlayedTrack(String trackId);

  // Top items methods
  Future<List<CommonTrack>> getTopTracks();
  Future<List<CommonArtist>> getTopArtists();
  Future<List<CommonGenre>> getTopGenres();
  Future<List<CommonAnime>> getTopAnime();
  Future<List<CommonManga>> getTopManga();

  // Liked items methods
  Future<List<CommonTrack>> getLikedTracks();
  Future<List<CommonArtist>> getLikedArtists();
  Future<List<CommonAlbum>> getLikedAlbums();
  Future<List<CommonGenre>> getLikedGenres();

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
  Future<List<CommonTrack>> searchTracks(String query);
  Future<List<CommonArtist>> searchArtists(String query);
  Future<List<CommonAlbum>> searchAlbums(String query);
  Future<List<CommonGenre>> searchGenres(String query);
  Future<List<CommonAnime>> searchAnime(String query);
  Future<List<CommonManga>> searchManga(String query);

  // Details methods
  Future<CommonTrack> getTrackDetails(String trackId);
  Future<CommonArtist> getArtistDetails(String artistId);
  Future<CommonAlbum> getAlbumDetails(String albumId);
  Future<CommonGenre> getGenreDetails(String genreId);
  Future<CommonAnime> getAnimeDetails(String animeId);
  Future<CommonManga> getMangaDetails(String mangaId);

  // Category methods
  Future<List<dynamic>> getTopItems(String category);
  Future<List<dynamic>> getLikedItems(String category);
}
