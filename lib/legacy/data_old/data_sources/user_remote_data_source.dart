import '../../models/track.dart';
import '../../domain/models/user_profile.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/anime.dart';
import '../../models/manga.dart';

abstract class UserRemoteDataSource {
  Future<UserProfile> getUserProfile();
  Future<List<Track>> getLikedTracks();
  Future<void> likeSong(String songId);
  Future<void> unlikeSong(String songId);
  void updateToken(String token);

  Future<UserProfile> getMyProfile();
  Future<UserProfile> getBudProfile(String username);
  Future<void> updateMyProfile(UserProfile profile);
  Future<void> updateMyLikes();
  Future<List<Artist>> getLikedArtists();
  Future<List<Album>> getLikedAlbums();
  Future<List<Genre>> getLikedGenres();
  Future<List<Artist>> getTopArtists();
  Future<List<Track>> getTopTracks();
  Future<List<Genre>> getTopGenres();
  Future<List<Anime>> getTopAnime();
  Future<List<Manga>> getTopManga();

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

  Future<void> saveLocation(double latitude, double longitude);
  Future<List<Track>> getPlayedTracks();
  Future<List<Track>> getPlayedTracksWithLocation();
  Future<List<Track>> getCurrentlyPlayedTracks();
}
