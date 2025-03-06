import 'package:http/http.dart' as http;
import '../../../domain/models/user_profile.dart';
import '../../../models/track.dart';
import '../../../models/artist.dart';
import '../../../models/album.dart';
import '../../../models/genre.dart';
import '../../../models/anime.dart';
import '../../../models/manga.dart';
import '../../providers/token_provider.dart';
import 'user_remote_data_source.dart';
import 'dart:convert';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client _client;
  final TokenProvider _tokenProvider;
  final String _baseUrl = 'http://84.235.170.234';  // Move this to config later

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
  Future<UserProfile?> getMyProfile() async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/me/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get profile: ${response.body}');
      }
    } catch (e) {
      print('Error in getMyProfile: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/profile'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get profile: ${response.body}');
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/profile'),
      headers: _headers,
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  @override
  Future<List<Artist>> getLikedArtists() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/liked/artists'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get liked artists: ${response.body}');
    }
  }

  @override
  Future<void> connectSpotify(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/services/spotify/connect'),
      headers: _headers,
      body: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to connect Spotify: ${response.body}');
    }
  }

  @override
  Future<UserProfile> getBudProfile(String username) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/bud/profile/$username'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get bud profile: ${response.body}');
    }
  }

  @override
  Future<void> updateMyProfile(UserProfile profile) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/me/profile'),
      headers: _headers,
      body: json.encode(profile.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  @override
  Future<void> updateMyLikes() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/me/likes/update'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update likes: ${response.body}');
    }
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/liked/tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get liked tracks: ${response.body}');
    }
  }

  @override
  Future<List<Album>> getLikedAlbums() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/liked/albums'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get liked albums: ${response.body}');
    }
  }

  @override
  Future<List<Genre>> getLikedGenres() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/liked/genres'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get liked genres: ${response.body}');
    }
  }

  @override
  Future<List<Artist>> getTopArtists() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/top/artists'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get top artists: ${response.body}');
    }
  }

  @override
  Future<String> getSpotifyAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/services/spotify/auth-url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['url'] as String;
    } else {
      throw Exception('Failed to get Spotify auth URL: ${response.body}');
    }
  }

  @override
  Future<void> disconnectSpotify() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/services/spotify/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to disconnect Spotify: ${response.body}');
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
      throw Exception('Failed to save location: ${response.body}');
    }
  }

  @override
  Future<List<Track>> getPlayedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/played/tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get played tracks: ${response.body}');
    }
  }

  @override
  Future<void> likeSong(String songId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/me/likes/songs/$songId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like song: ${response.body}');
    }
  }

  @override
  Future<void> unlikeSong(String songId) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/me/likes/songs/$songId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unlike song: ${response.body}');
    }
  }

  @override
  Future<List<Track>> getTopTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/top/tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get top tracks: ${response.body}');
    }
  }

  @override
  Future<List<Genre>> getTopGenres() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/top/genres'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get top genres: ${response.body}');
    }
  }

  @override
  Future<List<Anime>> getTopAnime() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/top/anime'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Anime.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get top anime: ${response.body}');
    }
  }

  @override
  Future<List<Manga>> getTopManga() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/top/manga'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Manga.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get top manga: ${response.body}');
    }
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/services/ytmusic/auth-url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['url'] as String;
    } else {
      throw Exception('Failed to get YouTube Music auth URL: ${response.body}');
    }
  }

  @override
  Future<void> connectYTMusic(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/services/ytmusic/connect'),
      headers: _headers,
      body: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to connect YouTube Music: ${response.body}');
    }
  }

  @override
  Future<void> disconnectYTMusic() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/services/ytmusic/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to disconnect YouTube Music: ${response.body}');
    }
  }

  @override
  Future<String> getMALAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/services/mal/auth-url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['url'] as String;
    } else {
      throw Exception('Failed to get MyAnimeList auth URL: ${response.body}');
    }
  }

  @override
  Future<void> connectMAL(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/services/mal/connect'),
      headers: _headers,
      body: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to connect MyAnimeList: ${response.body}');
    }
  }

  @override
  Future<void> disconnectMAL() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/services/mal/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to disconnect MyAnimeList: ${response.body}');
    }
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/services/lastfm/auth-url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['url'] as String;
    } else {
      throw Exception('Failed to get Last.fm auth URL: ${response.body}');
    }
  }

  @override
  Future<void> connectLastFM(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/services/lastfm/connect'),
      headers: _headers,
      body: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to connect Last.fm: ${response.body}');
    }
  }

  @override
  Future<void> disconnectLastFM() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/services/lastfm/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to disconnect Last.fm: ${response.body}');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/played/tracks/with-location'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get played tracks with location: ${response.body}');
    }
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/me/currently-playing'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get currently played tracks: ${response.body}');
    }
  }
} 