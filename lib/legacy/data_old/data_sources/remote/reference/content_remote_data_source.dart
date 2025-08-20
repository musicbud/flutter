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

  /// Gets a list of liked tracks
  Future<List<CommonTrack>> getLikedTracks();

  /// Gets a list of liked artists
  Future<List<CommonArtist>> getLikedArtists();

  /// Gets a list of liked albums
  Future<List<CommonAlbum>> getLikedAlbums();

  /// Gets a list of liked genres
  Future<List<CommonGenre>> getLikedGenres();

  /// Likes a track
  Future<void> likeTrack(String trackId);

  /// Unlikes a track
  Future<void> unlikeTrack(String trackId);

  /// Likes an artist
  Future<void> likeArtist(String artistId);

  /// Unlikes an artist
  Future<void> unlikeArtist(String artistId);

  /// Likes an album
  Future<void> likeAlbum(String albumId);

  /// Unlikes an album
  Future<void> unlikeAlbum(String albumId);

  /// Likes a genre
  Future<void> likeGenre(String genreId);

  /// Unlikes a genre
  Future<void> unlikeGenre(String genreId);

  /// Likes an anime
  Future<void> likeAnime(String animeId);

  /// Unlikes an anime
  Future<void> unlikeAnime(String animeId);

  /// Likes a manga
  Future<void> likeManga(String mangaId);

  /// Unlikes a manga
  Future<void> unlikeManga(String mangaId);

  // Popular content methods
  Future<List<CommonTrack>> getPopularTracks();
  Future<List<CommonArtist>> getPopularArtists();
  Future<List<CommonAlbum>> getPopularAlbums();
  Future<List<CommonAnime>> getPopularAnime();
  Future<List<CommonManga>> getPopularManga();

  // Top content methods
  Future<List<CommonTrack>> getTopTracks();
  Future<List<CommonArtist>> getTopArtists();
  Future<List<CommonGenre>> getTopGenres();
  Future<List<CommonAnime>> getTopAnime();
  Future<List<CommonManga>> getTopManga();

  // Like/Unlike methods
  Future<void> toggleTrackLike(String trackId);
  Future<void> toggleArtistLike(String artistId);
  Future<void> toggleAlbumLike(String albumId);
  Future<void> toggleGenreLike(String genreId);
  Future<void> toggleAnimeLike(String animeId);
  Future<void> toggleMangaLike(String mangaId);

  // Update methods
  Future<void> updateLikes();

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
