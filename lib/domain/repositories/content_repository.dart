import '../models/common_track.dart';
import '../models/common_artist.dart';
import '../models/common_genre.dart';
import '../models/common_album.dart';
import '../models/common_anime.dart';
import '../models/common_manga.dart';

abstract class ContentRepository {
  Future<List<CommonTrack>> getPlayedTracks();
  Future<List<Map<String, dynamic>>> getSpotifyDevices();
  Future<void> controlSpotifyPlayback(String command, String deviceId);
  Future<void> setSpotifyVolume(String deviceId, int volume);
  Future<void> saveTrackLocation(
      String trackId, double latitude, double longitude);
  Future<List<CommonTrack>> getPopularTracks();
  Future<List<CommonArtist>> getPopularArtists();
  Future<List<CommonGenre>> getPopularGenres();
  Future<List<CommonAnime>> getPopularAnime();
  Future<List<CommonManga>> getPopularManga();
  Future<CommonTrack> getTrackDetails(String id);
  Future<CommonArtist> getArtistDetails(String id);
  Future<CommonAlbum> getAlbumDetails(String id);
  Future<CommonGenre> getGenreDetails(String id);
  Future<CommonAnime> getAnimeDetails(String id);
  Future<CommonManga> getMangaDetails(String id);
  Future<void> likeTrack(String id);
  Future<void> unlikeTrack(String id);
  Future<void> likeArtist(String id);
  Future<void> unlikeArtist(String id);
  Future<void> likeAlbum(String id);
  Future<void> unlikeAlbum(String id);
  Future<void> likeGenre(String id);
  Future<void> unlikeGenre(String id);
  Future<void> likeAnime(String id);
  Future<void> unlikeAnime(String id);
  Future<void> likeManga(String id);
  Future<void> unlikeManga(String id);
  Future<List<CommonTrack>> getTopItems(String type);
  Future<List<CommonTrack>> getLikedItems(String type);
}
