import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../domain/models/common_track.dart';
import '../../../../domain/models/spotify_device.dart';
import '../../../../domain/models/common_artist.dart';
import '../../../../domain/models/common_genre.dart';
import '../../../../domain/models/common_album.dart';
import '../../../../domain/models/common_anime.dart';
import '../../../../domain/models/common_manga.dart';
import '../../../network/dio_client.dart';
import 'content_remote_data_source.dart';

/// Implementation of [ContentRemoteDataSource] that uses HTTP requests to interact with the remote API.
class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final DioClient _dioClient;

  /// Creates a new instance of [ContentRemoteDataSourceImpl].
  ///
  /// Requires a [DioClient] instance for making HTTP requests.
  ContentRemoteDataSourceImpl(this._dioClient);

  /// Retrieves a list of recently played tracks
  @override
  Future<List<CommonTrack>> getPlayedTracks() async {
    try {
      final response = await _dioClient.post('/tracks/played');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonTrack.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get played tracks: $e');
    }
  }

  /// Retrieves a list of available Spotify devices
  @override
  Future<List<SpotifyDevice>> getSpotifyDevices() async {
    try {
      final response = await _dioClient.post('/spotify/devices');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => SpotifyDevice.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get Spotify devices: $e');
    }
  }

  /// Controls playback on a specific Spotify device
  ///
  /// [command] can be 'play', 'pause', 'next', or 'previous'
  /// [deviceId] is the ID of the target Spotify device
  @override
  Future<void> controlSpotifyPlayback(String command, String deviceId) async {
    try {
      await _dioClient.post('/spotify/playback/control', data: {
        'command': command,
        'device_id': deviceId,
      });
    } catch (e) {
      throw Exception('Failed to control Spotify playback: $e');
    }
  }

  /// Sets the volume for a specific Spotify device
  ///
  /// [deviceId] is the ID of the target Spotify device
  /// [volume] is the target volume level (0-100)
  @override
  Future<void> setSpotifyVolume(String deviceId, int volume) async {
    try {
      await _dioClient.post('/spotify/playback/volume', data: {
        'device_id': deviceId,
        'volume': volume,
      });
    } catch (e) {
      throw Exception('Failed to set Spotify volume: $e');
    }
  }

  /// Saves the location where a track was played
  ///
  /// [trackId] is the ID of the track
  /// [latitude] and [longitude] represent the geographic location
  @override
  Future<void> saveTrackLocation(
      String trackId, double latitude, double longitude) async {
    try {
      await _dioClient.post('/tracks/$trackId/location', data: {
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (e) {
      throw Exception('Failed to save track location: $e');
    }
  }

  @override
  Future<void> playTrack(String trackId, String deviceId) async {
    try {
      await _dioClient.post('/tracks/play', data: {
        'track_id': trackId,
        'device_id': deviceId,
      });
    } catch (e) {
      throw Exception('Failed to play track: $e');
    }
  }

  @override
  Future<void> playTrackWithLocation(String trackId, String deviceId,
      double latitude, double longitude) async {
    try {
      await _dioClient.post('/tracks/play', data: {
        'track_id': trackId,
        'device_id': deviceId,
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (e) {
      throw Exception('Failed to play track with location: $e');
    }
  }

  @override
  Future<void> savePlayedTrack(String trackId) async {
    try {
      await _dioClient.post('/tracks/$trackId/played');
    } catch (e) {
      throw Exception('Failed to save played track: $e');
    }
  }

  @override
  Future<List<CommonTrack>> getTopTracks() async {
    try {
      final response = await _dioClient.post('/tracks/top');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonTrack.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get top tracks: $e');
    }
  }

  @override
  Future<List<CommonArtist>> getTopArtists() async {
    try {
      final response = await _dioClient.post('/artists/top');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonArtist.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get top artists: $e');
    }
  }

  @override
  Future<List<CommonGenre>> getTopGenres() async {
    try {
      final response = await _dioClient.post('/genres/top');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonGenre.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get top genres: $e');
    }
  }

  @override
  Future<List<CommonAnime>> getTopAnime() async {
    try {
      final response = await _dioClient.post('/anime/top');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonAnime.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get top anime: $e');
    }
  }

  @override
  Future<List<CommonManga>> getTopManga() async {
    try {
      final response = await _dioClient.post('/manga/top');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonManga.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get top manga: $e');
    }
  }

  @override
  Future<List<CommonTrack>> getLikedTracks() async {
    try {
      final response = await _dioClient.post('/tracks/liked');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonTrack.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get liked tracks: $e');
    }
  }

  @override
  Future<List<CommonArtist>> getLikedArtists() async {
    try {
      final response = await _dioClient.post('/artists/liked');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonArtist.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get liked artists: $e');
    }
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() async {
    try {
      final response = await _dioClient.post('/albums/liked');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonAlbum.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get liked albums: $e');
    }
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() async {
    try {
      final response = await _dioClient.post('/genres/liked');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonGenre.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get liked genres: $e');
    }
  }

  @override
  Future<void> likeTrack(String trackId) async {
    try {
      await _dioClient.post('/tracks/$trackId/like');
    } catch (e) {
      throw Exception('Failed to like track: $e');
    }
  }

  @override
  Future<void> unlikeTrack(String trackId) async {
    try {
      await _dioClient.post('/tracks/$trackId/unlike');
    } catch (e) {
      throw Exception('Failed to unlike track: $e');
    }
  }

  @override
  Future<void> likeArtist(String artistId) async {
    try {
      await _dioClient.post('/artists/$artistId/like');
    } catch (e) {
      throw Exception('Failed to like artist: $e');
    }
  }

  @override
  Future<void> unlikeArtist(String artistId) async {
    try {
      await _dioClient.post('/artists/$artistId/unlike');
    } catch (e) {
      throw Exception('Failed to unlike artist: $e');
    }
  }

  @override
  Future<void> likeAlbum(String albumId) async {
    try {
      await _dioClient.post('/albums/$albumId/like');
    } catch (e) {
      throw Exception('Failed to like album: $e');
    }
  }

  @override
  Future<void> unlikeAlbum(String albumId) async {
    try {
      await _dioClient.post('/albums/$albumId/unlike');
    } catch (e) {
      throw Exception('Failed to unlike album: $e');
    }
  }

  @override
  Future<void> likeGenre(String genreId) async {
    try {
      await _dioClient.post('/genres/$genreId/like');
    } catch (e) {
      throw Exception('Failed to like genre: $e');
    }
  }

  @override
  Future<void> unlikeGenre(String genreId) async {
    try {
      await _dioClient.post('/genres/$genreId/unlike');
    } catch (e) {
      throw Exception('Failed to unlike genre: $e');
    }
  }

  @override
  Future<void> likeAnime(String animeId) async {
    try {
      await _dioClient.post('/anime/$animeId/like');
    } catch (e) {
      throw Exception('Failed to like anime: $e');
    }
  }

  @override
  Future<void> unlikeAnime(String animeId) async {
    try {
      await _dioClient.post('/anime/$animeId/unlike');
    } catch (e) {
      throw Exception('Failed to unlike anime: $e');
    }
  }

  @override
  Future<void> likeManga(String mangaId) async {
    try {
      await _dioClient.post('/manga/$mangaId/like');
    } catch (e) {
      throw Exception('Failed to like manga: $e');
    }
  }

  @override
  Future<void> unlikeManga(String mangaId) async {
    try {
      await _dioClient.post('/manga/$mangaId/unlike');
    } catch (e) {
      throw Exception('Failed to unlike manga: $e');
    }
  }

  @override
  Future<List<CommonTrack>> searchTracks(String query) async {
    try {
      final response = await _dioClient.post(
        '/tracks/search',
        data: {'q': query},
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonTrack.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search tracks: $e');
    }
  }

  @override
  Future<List<CommonArtist>> searchArtists(String query) async {
    try {
      final response = await _dioClient.post(
        '/artists/search',
        data: {'q': query},
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonArtist.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search artists: $e');
    }
  }

  @override
  Future<List<CommonAlbum>> searchAlbums(String query) async {
    try {
      final response = await _dioClient.post(
        '/albums/search',
        data: {'q': query},
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonAlbum.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search albums: $e');
    }
  }

  @override
  Future<List<CommonGenre>> searchGenres(String query) async {
    try {
      final response = await _dioClient.post(
        '/genres/search',
        data: {'q': query},
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonGenre.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search genres: $e');
    }
  }

  @override
  Future<List<CommonAnime>> searchAnime(String query) async {
    try {
      final response = await _dioClient.post(
        '/anime/search',
        data: {'q': query},
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonAnime.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search anime: $e');
    }
  }

  @override
  Future<List<CommonManga>> searchManga(String query) async {
    try {
      final response = await _dioClient.post(
        '/manga/search',
        data: {'q': query},
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => CommonManga.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search manga: $e');
    }
  }

  @override
  Future<CommonTrack> getTrackDetails(String trackId) async {
    try {
      final response = await _dioClient.post('/tracks/$trackId');
      return CommonTrack.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get track details: $e');
    }
  }

  @override
  Future<CommonArtist> getArtistDetails(String artistId) async {
    try {
      final response = await _dioClient.post('/artists/$artistId');
      return CommonArtist.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get artist details: $e');
    }
  }

  @override
  Future<CommonAlbum> getAlbumDetails(String albumId) async {
    try {
      final response = await _dioClient.post('/albums/$albumId');
      return CommonAlbum.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get album details: $e');
    }
  }

  @override
  Future<CommonGenre> getGenreDetails(String genreId) async {
    try {
      final response = await _dioClient.post('/genres/$genreId');
      return CommonGenre.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get genre details: $e');
    }
  }

  @override
  Future<CommonAnime> getAnimeDetails(String animeId) async {
    try {
      final response = await _dioClient.post('/anime/$animeId');
      return CommonAnime.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get anime details: $e');
    }
  }

  @override
  Future<CommonManga> getMangaDetails(String mangaId) async {
    try {
      final response = await _dioClient.post('/manga/$mangaId');
      return CommonManga.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get manga details: $e');
    }
  }

  @override
  Future<List<CommonTrack>> getPopularTracks() async {
    try {
      final response = await _dioClient.post('/tracks/popular');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getPopularArtists() async {
    try {
      final response = await _dioClient.post('/artists/popular');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getPopularAlbums() async {
    try {
      final response = await _dioClient.post('/albums/popular');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonAlbum.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular albums');
    }
  }

  @override
  Future<List<CommonAnime>> getPopularAnime() async {
    try {
      final response = await _dioClient.post('/anime/popular');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonAnime.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular anime');
    }
  }

  @override
  Future<List<CommonManga>> getPopularManga() async {
    try {
      final response = await _dioClient.post('/manga/popular');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => CommonManga.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular manga');
    }
  }

  @override
  Future<void> toggleTrackLike(String trackId) async {
    try {
      await _dioClient.post('/tracks/$trackId/toggle-like');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to toggle track like');
    }
  }

  @override
  Future<void> toggleArtistLike(String artistId) async {
    try {
      await _dioClient.post('/artists/$artistId/toggle-like');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to toggle artist like');
    }
  }

  @override
  Future<void> toggleAlbumLike(String albumId) async {
    try {
      await _dioClient.post('/albums/$albumId/toggle-like');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to toggle album like');
    }
  }

  @override
  Future<void> toggleGenreLike(String genreId) async {
    try {
      await _dioClient.post('/genres/$genreId/toggle-like');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to toggle genre like');
    }
  }

  @override
  Future<void> toggleAnimeLike(String animeId) async {
    try {
      await _dioClient.post('/anime/$animeId/toggle-like');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to toggle anime like');
    }
  }

  @override
  Future<void> toggleMangaLike(String mangaId) async {
    try {
      await _dioClient.post('/manga/$mangaId/toggle-like');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to toggle manga like');
    }
  }

  @override
  Future<void> updateLikes() async {
    try {
      await _dioClient.post('/likes/update');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to update likes');
    }
  }
}
