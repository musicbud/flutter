import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';

abstract class ContentRemoteDataSource {
  // Home page
  Future<Map<String, dynamic>> getHomePageData();

  // Popular content
  Future<List<CommonTrack>> getPopularTracks({int limit = 20});
  Future<List<CommonArtist>> getPopularArtists({int limit = 20});
  Future<List<CommonAlbum>> getPopularAlbums({int limit = 20});
  Future<List<CommonAnime>> getPopularAnime({int limit = 20});
  Future<List<CommonManga>> getPopularManga({int limit = 20});

  // Top content
  Future<List<CommonTrack>> getTopTracks();
  Future<List<CommonArtist>> getTopArtists();
  Future<List<CommonGenre>> getTopGenres();
  Future<List<CommonAnime>> getTopAnime();
  Future<List<CommonManga>> getTopManga();

  // Liked content
  Future<List<CommonTrack>> getLikedTracks();
  Future<List<CommonArtist>> getLikedArtists();
  Future<List<CommonAlbum>> getLikedAlbums();
  Future<List<CommonGenre>> getLikedGenres();

  // Played content
  Future<List<CommonTrack>> getPlayedTracks();
  Future<List<CommonTrack>> getPlayedTracksWithLocation();
  Future<List<CommonTrack>> getCurrentlyPlayedTracks();

  // Like/Unlike operations
  Future<bool> likeTrack(String id);
  Future<bool> likeArtist(String id);
  Future<bool> likeAlbum(String id);
  Future<bool> likeGenre(String id);
  Future<bool> likeAnime(String id);
  Future<bool> likeManga(String id);
  Future<bool> unlikeTrack(String id);
  Future<bool> unlikeArtist(String id);
  Future<bool> unlikeAlbum(String id);
  Future<bool> unlikeGenre(String id);
  Future<bool> unlikeAnime(String id);
  Future<bool> unlikeManga(String id);

  // Search operations
  Future<List<CommonTrack>> searchTracks(String query);
  Future<List<CommonArtist>> searchArtists(String query);
  Future<List<CommonAlbum>> searchAlbums(String query);
  Future<List<CommonGenre>> searchGenres(String query);
  Future<List<CommonAnime>> searchAnime(String query);
  Future<List<CommonManga>> searchManga(String query);

  // Playback operations
  Future<List<String>> getSpotifyDevices();
  Future<void> playTrack(String trackId, {String? deviceId});
  Future<void> playTrackWithLocation(
      String trackId, double latitude, double longitude);
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude);
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final http.Client _client;
  final String _token;
  final String _baseUrl = 'https://api.musicbud.com';

  ContentRemoteDataSourceImpl({
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
  Future<Map<String, dynamic>> getHomePageData() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/home'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load home page data');
    }
  }

  @override
  Future<List<CommonTrack>> getPopularTracks({int limit = 20}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/popular/tracks').replace(
        queryParameters: {'limit': limit.toString()},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getPopularArtists({int limit = 20}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/popular/artists').replace(
        queryParameters: {'limit': limit.toString()},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getPopularAlbums({int limit = 20}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/popular/albums').replace(
        queryParameters: {'limit': limit.toString()},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonAlbum.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular albums');
    }
  }

  @override
  Future<List<CommonAnime>> getPopularAnime({int limit = 20}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/popular/anime').replace(
        queryParameters: {'limit': limit.toString()},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonAnime.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular anime');
    }
  }

  @override
  Future<List<CommonManga>> getPopularManga({int limit = 20}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/popular/manga').replace(
        queryParameters: {'limit': limit.toString()},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonManga.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular manga');
    }
  }

  @override
  Future<List<CommonTrack>> getTopTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/top/tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getTopArtists() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/top/artists'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top artists');
    }
  }

  @override
  Future<List<CommonGenre>> getTopGenres() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/top/genres'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top genres');
    }
  }

  @override
  Future<List<CommonAnime>> getTopAnime() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/top/anime'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonAnime.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top anime');
    }
  }

  @override
  Future<List<CommonManga>> getTopManga() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/top/manga'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonManga.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top manga');
    }
  }

  @override
  Future<List<CommonTrack>> getLikedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/liked/tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load liked tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getLikedArtists() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/liked/artists'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load liked artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/liked/albums'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonAlbum.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load liked albums');
    }
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/liked/genres'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load liked genres');
    }
  }

  @override
  Future<List<CommonTrack>> getPlayedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/played/tracks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load played tracks');
    }
  }

  @override
  Future<List<CommonTrack>> getPlayedTracksWithLocation() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/played/tracks/with-location'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load played tracks with location');
    }
  }

  @override
  Future<List<CommonTrack>> getCurrentlyPlayedTracks() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/played/tracks/current'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load currently played tracks');
    }
  }

  @override
  Future<bool> likeTrack(String id) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/content/tracks/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> likeArtist(String id) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/content/artists/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> likeAlbum(String id) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/content/albums/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> likeGenre(String id) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/content/genres/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> likeAnime(String id) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/content/anime/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> likeManga(String id) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/content/manga/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> unlikeTrack(String id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/content/tracks/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> unlikeArtist(String id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/content/artists/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> unlikeAlbum(String id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/content/albums/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> unlikeGenre(String id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/content/genres/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> unlikeAnime(String id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/content/anime/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> unlikeManga(String id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/content/manga/$id/like'),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  @override
  Future<List<CommonTrack>> searchTracks(String query) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/search/tracks').replace(
        queryParameters: {'q': query},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search tracks');
    }
  }

  @override
  Future<List<CommonArtist>> searchArtists(String query) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/search/artists').replace(
        queryParameters: {'q': query},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search artists');
    }
  }

  @override
  Future<List<CommonAlbum>> searchAlbums(String query) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/search/albums').replace(
        queryParameters: {'q': query},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonAlbum.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search albums');
    }
  }

  @override
  Future<List<CommonGenre>> searchGenres(String query) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/search/genres').replace(
        queryParameters: {'q': query},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search genres');
    }
  }

  @override
  Future<List<CommonAnime>> searchAnime(String query) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/search/anime').replace(
        queryParameters: {'q': query},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonAnime.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search anime');
    }
  }

  @override
  Future<List<CommonManga>> searchManga(String query) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/search/manga').replace(
        queryParameters: {'q': query},
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonManga.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search manga');
    }
  }

  @override
  Future<List<String>> getSpotifyDevices() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/content/spotify/devices'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => json['id'] as String).toList();
    } else {
      throw Exception('Failed to get Spotify devices');
    }
  }

  @override
  Future<void> playTrack(String trackId, {String? deviceId}) async {
    final Map<String, dynamic> data = {'track_id': trackId};
    if (deviceId != null) {
      data['device_id'] = deviceId;
    }

    final response = await _client.post(
      Uri.parse('$_baseUrl/api/content/spotify/play'),
      headers: _headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to play track');
    }
  }

  @override
  Future<void> playTrackWithLocation(
      String trackId, double latitude, double longitude) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/content/spotify/play-with-location'),
      headers: _headers,
      body: jsonEncode({
        'track_id': trackId,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to play track with location');
    }
  }

  @override
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/content/played/tracks'),
      headers: _headers,
      body: jsonEncode({
        'track_id': trackId,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to save played track');
    }
  }
}
