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
      print('Sending request to get buds for track: $trackId');
      final response = await _dio.post('/bud/track', data: {'track_id': trackId});
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        if (response.data['buds'] != null) {
          return response.data['buds'] as List<dynamic>;
        } else {
          print('Buds data is null');
          return [];
        }
      } else {
        throw Exception('Failed to get buds for track');
      }
    } catch (e) {
      print('Error getting buds for track: $e');
      throw Exception('Error getting buds for track: $e');
    }
  }

  Future<List<dynamic>> getBudsByArtist(String artistId) async {
    try {
      print('Sending request to get buds for artist: $artistId');
      final response = await _dio.post('/bud/artist', data: {'artist_id': artistId});
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200 && response.data['buds'] != null) {
        return response.data['buds'] as List<dynamic>;
      } else {
        print('Buds data is null or status is not 200');
        return [];
      }
    } catch (e) {
      print('Error getting buds for artist: $e');
      throw Exception('Error getting buds for artist: $e');
    }
  }

  Future<List<dynamic>> getBudsByGenre(String genreId) async {
    try {
      print('Sending request to get buds for genre: $genreId');
      final response = await _dio.post('/bud/genre', data: {'genre_id': genreId});
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200 && response.data['buds'] != null) {
        return response.data['buds'] as List<dynamic>;
      } else {
        print('Buds data is null or status is not 200');
        return [];
      }
    } catch (e) {
      print('Error getting buds for genre: $e');
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
      print('Error playing track: $e');
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
        print('Failed to load played tracks: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching played tracks: $e');
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
      print('Error fetching currently played tracks: $e');
      return [];
    }
  }

  Future<void> playTrackWithLocation(String trackUid, String trackName, double latitude, double longitude) async {
    if (trackUid.isEmpty) {
      print('Error: trackUid is empty');
      throw Exception('Invalid track UID');
    }

    try {
      print('Sending request to play track with location:');
      print('track_id (UID): $trackUid');
      print('track_name: $trackName');
      print('latitude: $latitude');
      print('longitude: $longitude');

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
        print('Error response: ${response.statusCode}');
        print('Error data: ${response.data}');
        throw Exception('Failed to play track with location: ${response.statusCode}');
      }

      print('Successfully played track with location');
    } catch (e) {
      print('Error playing track with location: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getSpotifyDevices() async {
    try {
      final response = await _dio.get('/spotify/devices');
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['data'] is List) {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          print('Unexpected data structure for Spotify devices: ${responseData['data']}');
          return [];
        }
      } else {
        throw Exception('Failed to load Spotify devices: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Spotify devices: $e');
      return [];
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
      print('Error playing Spotify track: $e');
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
      print('Error fetching tracks with location: $e');
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
        print('Location saved successfully');
      } else {
        print('Failed to save location');
      }
    } catch (e) {
      print('Error saving location: $e');
    }
  }
}
