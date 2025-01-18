import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/user_profile.dart';
import '../../../models/track.dart';
import '../../../models/artist.dart';
import '../../../models/album.dart';
import '../../../models/genre.dart';
import '../../../models/anime.dart';
import '../../../models/manga.dart';

abstract class UserRemoteDataSource {
  Future<UserProfile> getMyProfile();
  Future<UserProfile> getBudProfile(String username);
  Future<void> updateMyProfile(UserProfile profile);
  Future<void> updateMyLikes();
  Future<List<Artist>> getLikedArtists();
  Future<List<Track>> getLikedTracks();
  Future<List<Album>> getLikedAlbums();
  Future<List<Genre>> getLikedGenres();
  Future<List<Artist>> getTopArtists();
  Future<List<Track>> getTopTracks();
  Future<List<Genre>> getTopGenres();
  Future<List<Anime>> getTopAnime();
  Future<List<Manga>> getTopManga();
  Future<void> saveLocation(double latitude, double longitude);
  Future<List<Track>> getPlayedTracks();
  Future<List<Track>> getPlayedTracksWithLocation();
  Future<List<Track>> getCurrentlyPlayedTracks();

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
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client _client;
  final String _token;
  final String _baseUrl =
      'https://api.musicbud.com'; // Replace with your actual API URL

  UserRemoteDataSourceImpl({
    required http.Client client,
    required String token,
  })  : _client = client,
        _token = token;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  @override
  Future<UserProfile> getMyProfile() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Future<UserProfile> getBudProfile(String username) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/$username'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load bud profile');
    }
  }

  @override
  Future<void> updateMyProfile(UserProfile profile) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/api/users/me'),
      headers: _headers,
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  @override
  Future<void> updateMyLikes() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/users/me/likes/update'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update likes');
    }
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/played/tracks/current'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Track.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load currently played tracks');
    }
  }

  @override
  Future<List<Artist>> getLikedArtists() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/liked/artists'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load liked artists');
    }
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/liked/tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Track.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load liked tracks');
    }
  }

  @override
  Future<List<Album>> getLikedAlbums() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/liked/albums'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load liked albums');
    }
  }

  @override
  Future<List<Genre>> getLikedGenres() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/liked/genres'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load liked genres');
    }
  }

  @override
  Future<List<Artist>> getTopArtists() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/top/artists'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top artists');
    }
  }

  @override
  Future<List<Track>> getTopTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/top/tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Track.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top tracks');
    }
  }

  @override
  Future<List<Genre>> getTopGenres() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/top/genres'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top genres');
    }
  }

  @override
  Future<List<Anime>> getTopAnime() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/top/anime'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Anime.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top anime');
    }
  }

  @override
  Future<List<Manga>> getTopManga() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/top/manga'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Manga.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top manga');
    }
  }

  @override
  Future<void> saveLocation(double latitude, double longitude) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/users/me/location'),
      headers: _headers,
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save location');
    }
  }

  @override
  Future<List<Track>> getPlayedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/played/tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Track.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load played tracks');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/me/played/tracks/with-location'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Track.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load played tracks with location');
    }
  }

  @override
  Future<String> getSpotifyAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/services/spotify/auth-url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to get Spotify auth URL');
    }
  }

  @override
  Future<void> connectSpotify(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/services/spotify/connect'),
      headers: _headers,
      body: jsonEncode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to connect Spotify');
    }
  }

  @override
  Future<void> disconnectSpotify() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/services/spotify/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to disconnect Spotify');
    }
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/services/ytmusic/auth-url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to get YouTube Music auth URL');
    }
  }

  @override
  Future<void> connectYTMusic(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/services/ytmusic/connect'),
      headers: _headers,
      body: jsonEncode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to connect YouTube Music');
    }
  }

  @override
  Future<void> disconnectYTMusic() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/services/ytmusic/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to disconnect YouTube Music');
    }
  }

  @override
  Future<String> getMALAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/services/mal/auth-url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to get MAL auth URL');
    }
  }

  @override
  Future<void> connectMAL(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/services/mal/connect'),
      headers: _headers,
      body: jsonEncode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to connect MAL');
    }
  }

  @override
  Future<void> disconnectMAL() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/services/mal/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to disconnect MAL');
    }
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/services/lastfm/auth-url'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to get LastFM auth URL');
    }
  }

  @override
  Future<void> connectLastFM(String code) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/services/lastfm/connect'),
      headers: _headers,
      body: jsonEncode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to connect LastFM');
    }
  }

  @override
  Future<void> disconnectLastFM() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/services/lastfm/disconnect'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to disconnect LastFM');
    }
  }
}
