import '../models/track.dart';
import '../models/common_artist.dart';
import '../models/common_album.dart';
import '../models/common_genre.dart';
import '../models/common_anime.dart';
import '../models/common_manga.dart';
import '../models/user_profile.dart';

abstract class UserRepository {
  // Profile operations
  Future<UserProfile> getUserProfile();
  Future<UserProfile> getBudProfile(String username);
  Future<void> updateMyProfile(UserProfile profile);
  Future<void> updateMyLikes();

  // Liked items
  Future<List<CommonArtist>> getLikedArtists();
  Future<List<Track>> getLikedTracks();
  Future<List<CommonAlbum>> getLikedAlbums();
  Future<List<CommonGenre>> getLikedGenres();

  // Top items
  Future<List<CommonArtist>> getTopArtists();
  Future<List<Track>> getTopTracks();
  Future<List<CommonGenre>> getTopGenres();
  Future<List<CommonAnime>> getTopAnime();
  Future<List<CommonManga>> getTopManga();

  // Service connections
  Future<String> getSpotifyAuthUrl();
  Future<void> connectSpotify(String code);
  Future<void> disconnectSpotify();

  Future<String> getYTMusicAuthUrl();
  Future<void> connectYTMusic(String code);
  Future<void> disconnectYTMusic();

  Future<String> getMALAuthUrl();
  Future<void> connectMAL(String code);
  Future<void> disconnectMAL();

  Future<String> getLastFMAuthUrl();
  Future<void> connectLastFM(String code);
  Future<void> disconnectLastFM();

  // Location
  Future<void> saveLocation(double latitude, double longitude);
  Future<List<Track>> getPlayedTracks();
  Future<List<Track>> getPlayedTracksWithLocation();
  Future<List<Track>> getCurrentlyPlayedTracks();

  // Track operations
  Future<void> likeSong(String songId);
  Future<void> unlikeSong(String songId);

  // Token management
  void updateToken(String token);
}
