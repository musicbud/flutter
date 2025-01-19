import '../../../../domain/models/common_track.dart';
import '../../../../domain/models/spotify_device.dart';
import '../../../../domain/models/common_artist.dart';
import '../../../../domain/models/common_genre.dart';
import '../../../../domain/models/common_album.dart';
import '../../../../domain/models/common_anime.dart';
import '../../../../domain/models/common_manga.dart';

/// Interface for accessing content-related data from remote sources.
/// This interface defines methods for interacting with content data from remote APIs.
abstract class ContentRemoteDataSource {
  /// Retrieves a list of recently played tracks from the remote source.
  ///
  /// Returns a [Future] that completes with a list of [CommonTrack] objects.
  Future<List<CommonTrack>> getPlayedTracks();

  /// Retrieves a list of available Spotify devices from the remote source.
  ///
  /// Returns a [Future] that completes with a list of [SpotifyDevice] objects.
  Future<List<SpotifyDevice>> getSpotifyDevices();

  /// Controls playback on a specific Spotify device.
  ///
  /// [command] can be 'play', 'pause', 'next', or 'previous'
  /// [deviceId] is the ID of the target Spotify device
  Future<void> controlSpotifyPlayback(String command, String deviceId);

  /// Sets the volume for a specific Spotify device.
  ///
  /// [deviceId] is the ID of the target Spotify device
  /// [volume] is the target volume level (0-100)
  Future<void> setSpotifyVolume(String deviceId, int volume);

  /// Saves the location where a track was played.
  ///
  /// [trackId] is the ID of the track
  /// [latitude] and [longitude] represent the geographic location
  Future<void> saveTrackLocation(
      String trackId, double latitude, double longitude);

  /// Plays a track on a specific device
  Future<void> playTrack(String trackId, String deviceId);

  /// Plays a track on a specific device with location data
  Future<void> playTrackWithLocation(
      String trackId, String deviceId, double latitude, double longitude);

  /// Saves a track as played
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
}
