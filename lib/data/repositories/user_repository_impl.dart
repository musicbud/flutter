import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user_profile.dart';
import '../../models/track.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/anime.dart';
import '../../models/manga.dart';
import '../data_sources/remote/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({required UserRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<UserProfile> getMyProfile() {
    return _remoteDataSource.getMyProfile();
  }

  @override
  Future<UserProfile> getBudProfile(String username) {
    return _remoteDataSource.getBudProfile(username);
  }

  @override
  Future<void> updateMyProfile(UserProfile profile) {
    return _remoteDataSource.updateMyProfile(profile);
  }

  @override
  Future<void> updateMyLikes() {
    return _remoteDataSource.updateMyLikes();
  }

  @override
  Future<List<Artist>> getLikedArtists() {
    return _remoteDataSource.getLikedArtists();
  }

  @override
  Future<List<Track>> getLikedTracks() {
    return _remoteDataSource.getLikedTracks();
  }

  @override
  Future<List<Album>> getLikedAlbums() {
    return _remoteDataSource.getLikedAlbums();
  }

  @override
  Future<List<Genre>> getLikedGenres() {
    return _remoteDataSource.getLikedGenres();
  }

  @override
  Future<List<Artist>> getTopArtists() {
    return _remoteDataSource.getTopArtists();
  }

  @override
  Future<List<Track>> getTopTracks() {
    return _remoteDataSource.getTopTracks();
  }

  @override
  Future<List<Genre>> getTopGenres() {
    return _remoteDataSource.getTopGenres();
  }

  @override
  Future<List<Anime>> getTopAnime() {
    return _remoteDataSource.getTopAnime();
  }

  @override
  Future<List<Manga>> getTopManga() {
    return _remoteDataSource.getTopManga();
  }

  @override
  Future<String> getSpotifyAuthUrl() {
    return _remoteDataSource.getSpotifyAuthUrl();
  }

  @override
  Future<void> connectSpotify(String code) {
    return _remoteDataSource.connectSpotify(code);
  }

  @override
  Future<void> disconnectSpotify() {
    return _remoteDataSource.disconnectSpotify();
  }

  @override
  Future<String> getYTMusicAuthUrl() {
    return _remoteDataSource.getYTMusicAuthUrl();
  }

  @override
  Future<void> connectYTMusic(String code) {
    return _remoteDataSource.connectYTMusic(code);
  }

  @override
  Future<void> disconnectYTMusic() {
    return _remoteDataSource.disconnectYTMusic();
  }

  @override
  Future<String> getMALAuthUrl() {
    return _remoteDataSource.getMALAuthUrl();
  }

  @override
  Future<void> connectMAL(String code) {
    return _remoteDataSource.connectMAL(code);
  }

  @override
  Future<void> disconnectMAL() {
    return _remoteDataSource.disconnectMAL();
  }

  @override
  Future<String> getLastFMAuthUrl() {
    return _remoteDataSource.getLastFMAuthUrl();
  }

  @override
  Future<void> connectLastFM(String code) {
    return _remoteDataSource.connectLastFM(code);
  }

  @override
  Future<void> disconnectLastFM() {
    return _remoteDataSource.disconnectLastFM();
  }

  @override
  Future<void> saveLocation(double latitude, double longitude) {
    return _remoteDataSource.saveLocation(latitude, longitude);
  }

  @override
  Future<List<Track>> getPlayedTracks() {
    return _remoteDataSource.getPlayedTracks();
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() {
    return _remoteDataSource.getPlayedTracksWithLocation();
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() {
    return _remoteDataSource.getCurrentlyPlayedTracks();
  }
}
