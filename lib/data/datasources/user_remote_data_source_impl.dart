import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/error/exceptions.dart';
import '../../models/track.dart';
import '../../domain/models/user_profile.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/anime.dart';
import '../../models/manga.dart';
import 'user_remote_data_source.dart';
import '../providers/token_provider.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client _client;
  final TokenProvider _tokenProvider;
  final String _baseUrl = 'http://84.235.170.234';

  UserRemoteDataSourceImpl({
    required http.Client client,
    required TokenProvider tokenProvider,
  })  : _client = client,
        _tokenProvider = tokenProvider;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${_tokenProvider.token}',
  };

  @override
  Future<UserProfile> getUserProfile() async {
    debugPrint('Getting profile with token: ${_tokenProvider.token}');
    final response = await _client.post(
      Uri.parse('$_baseUrl/me/profile'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      debugPrint('Failed to get profile. Status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      debugPrint('Headers sent: $_headers');
      throw ServerException(message: 'Failed to get user profile');
    }
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/liked-tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.body);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked tracks');
    }
  }

  @override
  Future<void> likeSong(String songId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/me/liked-tracks/$songId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to like song');
    }
  }

  @override
  Future<void> unlikeSong(String songId) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/me/liked-tracks/$songId'),
      headers: _headers,
    );

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
    final response = await _client.get(
      Uri.parse('$_baseUrl/$username'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to get bud profile');
    }
  }

  @override
  Future<void> updateMyProfile(UserProfile profile) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/me'),
      headers: _headers,
      body: json.encode(profile.toJson()),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update profile');
    }
  }

  @override
  Future<void> updateMyLikes() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/me/likes/update'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update likes');
    }
  }

  @override
  Future<List<Artist>> getLikedArtists() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/liked-artists'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> artistsJson = json.decode(response.body);
      return artistsJson.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked artists');
    }
  }

  @override
  Future<List<Album>> getLikedAlbums() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/liked-albums'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> albumsJson = json.decode(response.body);
      return albumsJson.map((json) => Album.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked albums');
    }
  }

  @override
  Future<List<Genre>> getLikedGenres() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/liked-genres'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> genresJson = json.decode(response.body);
      return genresJson.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked genres');
    }
  }

  @override
  Future<List<Artist>> getTopArtists() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/top-artists'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> artistsJson = json.decode(response.body);
      return artistsJson.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top artists');
    }
  }

  @override
  Future<List<Track>> getTopTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/top-tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.body);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top tracks');
    }
  }

  @override
  Future<List<Genre>> getTopGenres() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/top-genres'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> genresJson = json.decode(response.body);
      return genresJson.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top genres');
    }
  }

  @override
  Future<List<Anime>> getTopAnime() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/top-anime'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> animeJson = json.decode(response.body);
      return animeJson.map((json) => Anime.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top anime');
    }
  }

  @override
  Future<List<Manga>> getTopManga() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/top-manga'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> mangaJson = json.decode(response.body);
      return mangaJson.map((json) => Manga.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top manga');
    }
  }

  @override
  Future<String> getSpotifyAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/auth/spotify/url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get Spotify auth URL');
    }
  }

  @override
  Future<void> connectSpotify(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/spotify/callback'),
      headers: _headers,
      body: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect Spotify');
    }
  }

  @override
  Future<void> disconnectSpotify() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/spotify/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to disconnect Spotify');
    }
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/auth/ytmusic/url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get YouTube Music auth URL');
    }
  }

  @override
  Future<void> connectYTMusic(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/ytmusic/callback'),
      headers: _headers,
      body: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect YouTube Music');
    }
  }

  @override
  Future<void> disconnectYTMusic() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/ytmusic/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to disconnect YouTube Music');
    }
  }

  @override
  Future<String> getMALAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/auth/mal/url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get MyAnimeList auth URL');
    }
  }

  @override
  Future<void> connectMAL(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/mal/callback'),
      headers: _headers,
      body: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect MyAnimeList');
    }
  }

  @override
  Future<void> disconnectMAL() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/mal/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to disconnect MyAnimeList');
    }
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/auth/lastfm/url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get Last.fm auth URL');
    }
  }

  @override
  Future<void> connectLastFM(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/lastfm/callback'),
      headers: _headers,
      body: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect Last.fm');
    }
  }

  @override
  Future<void> disconnectLastFM() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/lastfm/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to disconnect Last.fm');
    }
  }

  @override
  Future<void> saveLocation(double latitude, double longitude) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/me/location'),
      headers: _headers,
      body: json.encode({
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
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/played-tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.body);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get played tracks');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/played-tracks/with-location'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.body);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(
          message: 'Failed to get played tracks with location');
    }
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/currently-playing'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.body);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get currently played tracks');
    }
  }
}
