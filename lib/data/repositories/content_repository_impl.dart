import '../../domain/models/common_track.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/common_album.dart';
import '../../domain/models/common_anime.dart';
import '../../domain/models/common_manga.dart';
import '../../domain/repositories/content_repository.dart';
import '../network/dio_client.dart';

class ContentRepositoryImpl implements ContentRepository {
  final DioClient _dioClient;

  ContentRepositoryImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<CommonTrack>> getPlayedTracks() async {
    final response = await _dioClient.get('/tracks/played');
    return (response.data as List)
        .map((json) => CommonTrack.fromJson(json))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getSpotifyDevices() async {
    final response = await _dioClient.get('/spotify/devices');
    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Future<void> controlSpotifyPlayback(String command,
      {String? deviceId}) async {
    await _dioClient.post('/spotify/playback/$command', data: {
      if (deviceId != null) 'device_id': deviceId,
    });
  }

  @override
  Future<void> setSpotifyVolume(int volume, {String? deviceId}) async {
    await _dioClient.put('/spotify/volume', data: {
      'volume': volume,
      if (deviceId != null) 'device_id': deviceId,
    });
  }

  @override
  Future<void> saveTrackLocation(
    CommonTrack track,
    double latitude,
    double longitude,
  ) async {
    await _dioClient.post('/tracks/location', data: {
      'track_id': track.id,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  @override
  Future<List<CommonTrack>> getTopTracks() async {
    final response = await _dioClient.get('/tracks/top');
    return (response.data as List)
        .map((json) => CommonTrack.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonArtist>> getTopArtists() async {
    final response = await _dioClient.get('/artists/top');
    return (response.data as List)
        .map((json) => CommonArtist.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonGenre>> getTopGenres() async {
    final response = await _dioClient.get('/genres/top');
    return (response.data as List)
        .map((json) => CommonGenre.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() async {
    final response = await _dioClient.get('/albums/liked');
    return (response.data as List)
        .map((json) => CommonAlbum.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonTrack>> getLikedTracks() async {
    final response = await _dioClient.get('/tracks/liked');
    return (response.data as List)
        .map((json) => CommonTrack.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonArtist>> getLikedArtists() async {
    final response = await _dioClient.get('/artists/liked');
    return (response.data as List)
        .map((json) => CommonArtist.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() async {
    final response = await _dioClient.get('/genres/liked');
    return (response.data as List)
        .map((json) => CommonGenre.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonAnime>> getTopAnime() async {
    final response = await _dioClient.get('/anime/top');
    return (response.data as List)
        .map((json) => CommonAnime.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonManga>> getTopManga() async {
    final response = await _dioClient.get('/manga/top');
    return (response.data as List)
        .map((json) => CommonManga.fromJson(json))
        .toList();
  }
}
