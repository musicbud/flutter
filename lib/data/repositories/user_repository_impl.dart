import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user_profile.dart';
import '../../models/track.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/anime.dart';
import '../../models/manga.dart';
import '../datasources/user_remote_data_source.dart';
import '../datasources/user_remote_data_source_impl.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({required UserRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<UserProfile> getUserProfile() async {
    return await _remoteDataSource.getUserProfile();
  }

  @override
  Future<UserProfile> getBudProfile(String username) async {
    return await _remoteDataSource.getBudProfile(username);
  }

  @override
  Future<void> updateMyProfile(UserProfile profile) async {
    await _remoteDataSource.updateMyProfile(profile);
  }

  @override
  Future<void> updateMyLikes() async {
    await _remoteDataSource.updateMyLikes();
  }

  @override
  Future<List<Artist>> getLikedArtists() async {
    return await _remoteDataSource.getLikedArtists();
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    return await _remoteDataSource.getLikedTracks();
  }

  @override
  Future<List<Album>> getLikedAlbums() async {
    return await _remoteDataSource.getLikedAlbums();
  }

  @override
  Future<List<Genre>> getLikedGenres() async {
    return await _remoteDataSource.getLikedGenres();
  }

  @override
  Future<List<Artist>> getTopArtists() async {
    return await _remoteDataSource.getTopArtists();
  }

  @override
  Future<List<Track>> getTopTracks() async {
    return await _remoteDataSource.getTopTracks();
  }

  @override
  Future<List<Genre>> getTopGenres() async {
    return await _remoteDataSource.getTopGenres();
  }

  @override
  Future<List<Anime>> getTopAnime() async {
    return await _remoteDataSource.getTopAnime();
  }

  @override
  Future<List<Manga>> getTopManga() async {
    return await _remoteDataSource.getTopManga();
  }

  @override
  Future<String> getSpotifyAuthUrl() async {
    return await _remoteDataSource.getSpotifyAuthUrl();
  }

  @override
  Future<void> connectSpotify(String code) async {
    await _remoteDataSource.connectSpotify(code);
  }

  @override
  Future<void> disconnectSpotify() async {
    await _remoteDataSource.disconnectSpotify();
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    return await _remoteDataSource.getYTMusicAuthUrl();
  }

  @override
  Future<void> connectYTMusic(String code) async {
    await _remoteDataSource.connectYTMusic(code);
  }

  @override
  Future<void> disconnectYTMusic() async {
    await _remoteDataSource.disconnectYTMusic();
  }

  @override
  Future<String> getMALAuthUrl() async {
    return await _remoteDataSource.getMALAuthUrl();
  }

  @override
  Future<void> connectMAL(String code) async {
    await _remoteDataSource.connectMAL(code);
  }

  @override
  Future<void> disconnectMAL() async {
    await _remoteDataSource.disconnectMAL();
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    return await _remoteDataSource.getLastFMAuthUrl();
  }

  @override
  Future<void> connectLastFM(String code) async {
    await _remoteDataSource.connectLastFM(code);
  }

  @override
  Future<void> disconnectLastFM() async {
    await _remoteDataSource.disconnectLastFM();
  }

  @override
  Future<void> saveLocation(double latitude, double longitude) async {
    await _remoteDataSource.saveLocation(latitude, longitude);
  }

  @override
  Future<List<Track>> getPlayedTracks() async {
    return await _remoteDataSource.getPlayedTracks();
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    return await _remoteDataSource.getPlayedTracksWithLocation();
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    return await _remoteDataSource.getCurrentlyPlayedTracks();
  }

  @override
  Future<void> likeSong(String songId) async {
    await _remoteDataSource.likeSong(songId);
  }

  @override
  Future<void> unlikeSong(String songId) async {
    await _remoteDataSource.unlikeSong(songId);
  }

  @override
  void updateToken(String token) {
    if (_remoteDataSource is UserRemoteDataSourceImpl) {
      (_remoteDataSource as UserRemoteDataSourceImpl).updateToken(token);
    }
  }
}
