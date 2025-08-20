import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/models/track.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';
import 'user_remote_data_source.dart';
import '../../providers/token_provider.dart';
import '../../network/dio_client.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _dioClient;
  final TokenProvider _tokenProvider;

  UserRemoteDataSourceImpl({
    required DioClient dioClient,
    required TokenProvider tokenProvider,
  })  : _dioClient = dioClient,
        _tokenProvider = tokenProvider;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${_tokenProvider.token}',
  };

  @override
  Future<UserProfile> getUserProfile() async {
    debugPrint('Getting profile with token: ${_tokenProvider.token}');
    final response = await _dioClient.post('/me/profile');

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.data));
    } else {
      debugPrint('Failed to get profile. Status: ${response.statusCode}');
      debugPrint('Response body: ${response.data}');
      debugPrint('Headers sent: $_headers');
      throw ServerException(message: 'Failed to get user profile');
    }
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    final response = await _dioClient.get('/me/liked-tracks');

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.data);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked tracks');
    }
  }

  @override
  Future<void> likeSong(String songId) async {
    final response = await _dioClient.post('/me/liked-tracks/$songId');

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to like song');
    }
  }

  @override
  Future<void> unlikeSong(String songId) async {
    final response = await _dioClient.delete('/me/liked-tracks/$songId');

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to unlike song');
    }
  }

  @override
  void updateToken(String newToken) {
    _tokenProvider.updateToken(newToken);
  }

  @override
  Future<UserProfile> getMyProfile() async {
    return getUserProfile();
  }

  @override
  Future<UserProfile> getBudProfile(String username) async {
    final response = await _dioClient.get('/$username');

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.data));
    } else {
      throw ServerException(message: 'Failed to get bud profile');
    }
  }

  @override
  Future<void> updateMyProfile(UserProfile profile) async {
    final response = await _dioClient.put(
      '/me',
      data: profile.toJson(),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update profile');
    }
  }

  @override
  Future<void> updateMyLikes() async {
    final response = await _dioClient.post('/me/likes/update');

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update likes');
    }
  }

  @override
  Future<List<CommonArtist>> getLikedArtists() async {
    final response = await _dioClient.get('/me/liked-artists');

    if (response.statusCode == 200) {
      final List<dynamic> artistsJson = json.decode(response.data);
      return artistsJson.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() async {
    final response = await _dioClient.get('/me/liked-albums');

    if (response.statusCode == 200) {
      final List<dynamic> albumsJson = json.decode(response.data);
      return albumsJson.map((json) => CommonAlbum.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked albums');
    }
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() async {
    final response = await _dioClient.get('/me/liked-genres');

    if (response.statusCode == 200) {
      final List<dynamic> genresJson = json.decode(response.data);
      return genresJson.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked genres');
    }
  }

  @override
  Future<List<CommonArtist>> getTopArtists() async {
    final response = await _dioClient.get('/me/top-artists');

    if (response.statusCode == 200) {
      final List<dynamic> artistsJson = json.decode(response.data);
      return artistsJson.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top artists');
    }
  }

  @override
  Future<List<Track>> getTopTracks() async {
    final response = await _dioClient.get('/me/top-tracks');

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.data);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top tracks');
    }
  }

  @override
  Future<List<CommonGenre>> getTopGenres() async {
    final response = await _dioClient.get('/me/top-genres');

    if (response.statusCode == 200) {
      final List<dynamic> genresJson = json.decode(response.data);
      return genresJson.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top genres');
    }
  }

  @override
  Future<List<CommonAnime>> getTopAnime() async {
    final response = await _dioClient.get('/me/top-anime');

    if (response.statusCode == 200) {
      final List<dynamic> animeJson = json.decode(response.data);
      return animeJson.map((json) => CommonAnime.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top anime');
    }
  }

  @override
  Future<List<CommonManga>> getTopManga() async {
    final response = await _dioClient.get('/me/top-manga');

    if (response.statusCode == 200) {
      final List<dynamic> mangaJson = json.decode(response.data);
      return mangaJson.map((json) => CommonManga.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top manga');
    }
  }

  @override
  Future<String> getSpotifyAuthUrl() async {
    final response = await _dioClient.get('/auth/spotify/url');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.data);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get Spotify auth URL');
    }
  }

  @override
  Future<void> connectSpotify(String code) async {
    final response = await _dioClient.post(
      '/auth/spotify/callback',
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect Spotify');
    }
  }

  @override
  Future<void> disconnectSpotify() async {
    final response = await _dioClient.post('/auth/spotify/disconnect');

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to disconnect Spotify');
    }
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    final response = await _dioClient.get('/auth/ytmusic/url');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.data);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get YouTube Music auth URL');
    }
  }

  @override
  Future<void> connectYTMusic(String code) async {
    final response = await _dioClient.post(
      '/auth/ytmusic/callback',
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect YouTube Music');
    }
  }

  @override
  Future<void> disconnectYTMusic() async {
    final response = await _dioClient.post('/auth/ytmusic/disconnect');

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to disconnect YouTube Music');
    }
  }

  @override
  Future<String> getMALAuthUrl() async {
    final response = await _dioClient.get('/auth/mal/url');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.data);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get MyAnimeList auth URL');
    }
  }

  @override
  Future<void> connectMAL(String code) async {
    final response = await _dioClient.post(
      '/auth/mal/callback',
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect MyAnimeList');
    }
  }

  @override
  Future<void> disconnectMAL() async {
    final response = await _dioClient.post('/auth/mal/disconnect');

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to disconnect MyAnimeList');
    }
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    final response = await _dioClient.get('/auth/lastfm/url');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.data);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get Last.fm auth URL');
    }
  }

  @override
  Future<void> connectLastFM(String code) async {
    final response = await _dioClient.post(
      '/auth/lastfm/callback',
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect Last.fm');
    }
  }

  @override
  Future<void> disconnectLastFM() async {
    final response = await _dioClient.post('/auth/lastfm/disconnect');

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to disconnect Last.fm');
    }
  }

  @override
  Future<void> saveLocation(double latitude, double longitude) async {
    final response = await _dioClient.post(
      '/me/location',
      data: json.encode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to save location');
    }
  }

  @override
  Future<List<Track>> getPlayedTracks() async {
    final response = await _dioClient.get('/me/played-tracks');

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.data);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get played tracks');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    final response = await _dioClient.get('/me/played-tracks/with-location');

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.data);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(
          message: 'Failed to get played tracks with location');
    }
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    final response = await _dioClient.get('/me/currently-playing');

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.data);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get currently played tracks');
    }
  }
}
