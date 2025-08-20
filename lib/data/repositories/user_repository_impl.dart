import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/track.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_album.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/common_anime.dart';
import '../../domain/models/common_manga.dart';
import '../data_sources/remote/user_remote_data_source.dart';
import '../data_sources/remote/user_remote_data_source_impl.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

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
  Future<List<CommonArtist>> getLikedArtists() async {
    return await _remoteDataSource.getLikedArtists();
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    try {
      final tracks = await _remoteDataSource.getLikedTracks();
      return tracks;
    } catch (e) {
      throw Exception('Failed to get liked tracks: $e');
    }
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() async {
    return await _remoteDataSource.getLikedAlbums();
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() async {
    return await _remoteDataSource.getLikedGenres();
  }

  @override
  Future<List<CommonArtist>> getTopArtists() async {
    return await _remoteDataSource.getTopArtists();
  }

  @override
  Future<List<Track>> getTopTracks() async {
    try {
      final tracks = await _remoteDataSource.getTopTracks();
      return tracks;
    } catch (e) {
      throw Exception('Failed to get top tracks: $e');
    }
  }

  @override
  Future<List<CommonGenre>> getTopGenres() async {
    return await _remoteDataSource.getTopGenres();
  }

  @override
  Future<List<CommonAnime>> getTopAnime() async {
    return await _remoteDataSource.getTopAnime();
  }

  @override
  Future<List<CommonManga>> getTopManga() async {
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
    try {
      final tracks = await _remoteDataSource.getPlayedTracks();
      return tracks;
    } catch (e) {
      throw Exception('Failed to get played tracks: $e');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    try {
      final tracks = await _remoteDataSource.getPlayedTracksWithLocation();
      return tracks;
    } catch (e) {
      throw Exception('Failed to get played tracks with location: $e');
    }
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    try {
      final tracks = await _remoteDataSource.getCurrentlyPlayedTracks();
      return tracks;
    } catch (e) {
      throw Exception('Failed to get currently played tracks: $e');
    }
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
