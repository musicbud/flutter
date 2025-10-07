import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl;

  ApiService({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  Future<List<dynamic>> getChannels() async {
    try {
      final response = await _dio.get('/channels');
      return response.data['channels'] as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to get channels: $e');
    }
  }

  Future<Map<String, dynamic>> getChannelDetails(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get channel details: $e');
    }
  }

  Future<Map<String, dynamic>> createChannel(
      Map<String, dynamic> channelData) async {
    try {
      final response = await _dio.post('/channels', data: channelData);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to create channel: $e');
    }
  }

  Future<List<dynamic>> getBudsByTrack(String trackId) async {
    try {
      final response = await _dio.post('/bud/track', data: {'track_id': trackId});
      if (response.statusCode == 200) {
        if (response.data['buds'] != null) {
          return response.data['buds'] as List<dynamic>;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to get buds for track');
      }
    } catch (e) {
      throw Exception('Error getting buds for track: $e');
    }
  }

  Future<List<dynamic>> getBudsByArtist(String artistId) async {
    try {
      final response = await _dio.post('/bud/artist', data: {'artist_id': artistId});
      if (response.statusCode == 200 && response.data['buds'] != null) {
        return response.data['buds'] as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error getting buds for artist: $e');
    }
  }

  Future<List<dynamic>> getBudsByGenre(String genreId) async {
    try {
      final response = await _dio.post('/bud/genre', data: {'genre_id': genreId});
      if (response.statusCode == 200 && response.data['buds'] != null) {
        return response.data['buds'] as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error getting buds for genre: $e');
    }
  }

  Future<void> playTrack(String trackIdentifier, {String? service}) async {
    try {
      final response = await _dio.post('/play', data: {
        'track_id': trackIdentifier,
        if (service != null) 'service': service,
      });
      if (response.statusCode != 200) {
        throw Exception('Failed to play track');
      }
    } catch (e) {
      throw Exception('Failed to play track: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPlayedTracks({int page = 1}) async {
    try {
      final response = await _dio.post('/me/played/tracks', data: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => json as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCurrentlyPlayedTracks() async {
    try {
      final response = await _dio.get('/me/currently-played');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => json as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load currently played tracks');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> playTrackWithLocation(String trackUid, String trackName, double latitude, double longitude) async {
    if (trackUid.isEmpty) {
      throw Exception('Invalid track UID');
    }

    try {

      final response = await _dio.post(
        '/me/play-track-with-location',
        data: {
          'track_id': trackUid,
          'track_name': trackName,
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to play track with location: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> playSpotifyTrack(String trackId, {String? deviceId}) async {
    try {
      final response = await _dio.post(
        '/spotify/play',
        data: {
          'track_id': trackId,
          if (deviceId != null) 'device_id': deviceId,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getPlayedTracksWithLocation() async {
    try {
      final response = await _dio.get('/spotify/played-tracks-with-location');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => json as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load tracks with location');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveLocation(double latitude, double longitude) async {
    try {
      final response = await _dio.post(
        '/me/location/save',
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
    }
  }
}
