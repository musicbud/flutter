import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../models/movie.dart';
import '../../../models/track.dart';
import '../../../models/artist.dart';
import '../../../models/album.dart';
import '../../../models/anime.dart';
import '../../../models/manga.dart';

abstract class ContentRemoteDataSource {
  // Home page
  Future<Map<String, dynamic>> getHomePageData();

  // Popular content
  Future<List<Movie>> getPopularMovies({int limit = 20});
  Future<List<Track>> getPopularTracks({int limit = 20});
  Future<List<Artist>> getPopularArtists({int limit = 20});
  Future<List<Album>> getPopularAlbums({int limit = 20});
  Future<List<Anime>> getPopularAnime({int limit = 20});
  Future<List<Manga>> getPopularManga({int limit = 20});

  // Like/Unlike operations
  Future<void> likeItem(String itemType, String itemId);
  Future<void> unlikeItem(String itemType, String itemId);

  // Playback operations
  Future<List<String>> getSpotifyDevices();
  Future<void> playTrack(String trackId, {String? deviceId});
  Future<void> playTrackWithLocation(
      String trackId, double latitude, double longitude);
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude);
  Future<List<Track>> getPlayedTracksWithLocation();
  Future<List<Track>> getCurrentlyPlayedTracks();
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final http.Client client;
  final String token;

  ContentRemoteDataSourceImpl({required this.client, required this.token});

  @override
  Future<Map<String, dynamic>> getHomePageData() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/home'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException(message: 'Failed to get home page data');
    }
  }

  @override
  Future<List<Movie>> getPopularMovies({int limit = 20}) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/popular/movies?limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get popular movies');
    }
  }

  @override
  Future<List<Track>> getPopularTracks({int limit = 20}) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/popular/music?type=tracks&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get popular tracks');
    }
  }

  @override
  Future<List<Artist>> getPopularArtists({int limit = 20}) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/popular/music?type=artists&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get popular artists');
    }
  }

  @override
  Future<List<Album>> getPopularAlbums({int limit = 20}) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/popular/music?type=albums&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Album.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get popular albums');
    }
  }

  @override
  Future<List<Anime>> getPopularAnime({int limit = 20}) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/popular/anime?limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Anime.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get popular anime');
    }
  }

  @override
  Future<List<Manga>> getPopularManga({int limit = 20}) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/popular/manga?limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Manga.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get popular manga');
    }
  }

  @override
  Future<void> likeItem(String itemType, String itemId) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/like'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'type': itemType,
        'id': itemId,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to like item');
    }
  }

  @override
  Future<void> unlikeItem(String itemType, String itemId) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/unlike'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'type': itemType,
        'id': itemId,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to unlike item');
    }
  }

  @override
  Future<List<String>> getSpotifyDevices() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/spotify/devices'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => json['id'] as String).toList();
    } else {
      throw ServerException(message: 'Failed to get Spotify devices');
    }
  }

  @override
  Future<void> playTrack(String trackId, {String? deviceId}) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/spotify/play'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'track_id': trackId,
        if (deviceId != null) 'device_id': deviceId,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to play track');
    }
  }

  @override
  Future<void> playTrackWithLocation(
      String trackId, double latitude, double longitude) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/me/play-track-with-location'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'track_id': trackId,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to play track with location');
    }
  }

  @override
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/me/location/save'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'track_id': trackId,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to save played track location');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/spotify/played-tracks-with-location'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(
          message: 'Failed to get played tracks with location');
    }
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/currently-played'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get currently played tracks');
    }
  }
}
