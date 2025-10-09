import 'package:musicbud_flutter/data/network/dio_client.dart';
import 'package:musicbud_flutter/data/models/common_track.dart';
import 'package:musicbud_flutter/config/api_config.dart';
import 'spotify_remote_data_source.dart';

class SpotifyRemoteDataSourceImpl implements SpotifyRemoteDataSource {
  final DioClient dioClient;

  SpotifyRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<CommonTrack>> getPlayedTracks() async {
    final response = await dioClient.post('/me/played/tracks', data: {'page': 1});
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load played tracks');
    }
  }

  @override
  Future<bool> playTrackWithLocation(String trackId, String trackName, double latitude, double longitude) async {
    final response = await dioClient.post('/me/play-track-with-location', data: {
      'track_id': trackId,
      'track_name': trackName,
      'latitude': latitude,
      'longitude': longitude,
    });
    return response.statusCode == 200;
  }

  @override
  Future<List<Map<String, dynamic>>> getSpotifyDevices() async {
    final response = await dioClient.get('/spotify/devices');
    if (response.statusCode == 200) {
      final responseData = response.data;
      if (responseData['data'] is List) {
        return List<Map<String, dynamic>>.from(responseData['data']);
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Spotify devices');
    }
  }

  @override
  Future<bool> playSpotifyTrack(String trackId, {String? deviceId}) async {
    final response = await dioClient.post('/spotify/play', data: {
      'track_id': trackId,
      if (deviceId != null) 'device_id': deviceId,
    });
    return response.statusCode == 200;
  }

  @override
  Future<void> saveLocation(double latitude, double longitude) async {
    await dioClient.post('/me/location/save', data: {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  @override
  Future<List<CommonTrack>> getRecentlyPlayedTracks() async {
    final response = await dioClient.get('/spotify/recently-played');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recently played tracks');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableDevices() async {
    final response = await dioClient.get('/spotify/devices');
    if (response.statusCode == 200) {
      final responseData = response.data;
      if (responseData['data'] is List) {
        return List<Map<String, dynamic>>.from(responseData['data']);
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load available devices');
    }
  }

  @override
  Future<Map<String, dynamic>?> getCurrentDevice() async {
    final response = await dioClient.get('/spotify/current-device');
    if (response.statusCode == 200) {
      return response.data['data'] as Map<String, dynamic>?;
    } else {
      return null;
    }
  }

  @override
  Future<void> transferPlayback(String deviceId) async {
    final response = await dioClient.put('/spotify/transfer', data: {
      'device_id': deviceId,
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to transfer playback');
    }
  }

  @override
  Future<void> play({String? deviceId}) async {
    final response = await dioClient.put('/spotify/play', data: {
      if (deviceId != null) 'device_id': deviceId,
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to play');
    }
  }

  @override
  Future<void> pause({String? deviceId}) async {
    final response = await dioClient.put('/spotify/pause', data: {
      if (deviceId != null) 'device_id': deviceId,
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to pause');
    }
  }

  @override
  Future<void> skipToNext({String? deviceId}) async {
    final response = await dioClient.post('/spotify/next', data: {
      if (deviceId != null) 'device_id': deviceId,
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to skip to next');
    }
  }

  @override
  Future<void> skipToPrevious({String? deviceId}) async {
    final response = await dioClient.post('/spotify/previous', data: {
      if (deviceId != null) 'device_id': deviceId,
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to skip to previous');
    }
  }

  @override
  Future<void> setVolume(int volume, {String? deviceId}) async {
    final response = await dioClient.put('/spotify/volume', data: {
      'volume': volume,
      if (deviceId != null) 'device_id': deviceId,
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to set volume');
    }
  }

  @override
  Future<void> saveTrackLocation(String trackId, double latitude, double longitude) async {
    final response = await dioClient.post('/me/track-location/save', data: {
      'track_id': trackId,
      'latitude': latitude,
      'longitude': longitude,
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to save track location');
    }
  }

  @override
  Future<List<CommonTrack>> getPlayedTracksWithLocation() async {
    final response = await dioClient.get('/spotify/played-tracks-with-location');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tracks with location');
    }
  }

  @override
  Future<Map<String, dynamic>> createSeedUser() async {
    final response = await dioClient.post(ApiConfig.spotifySeedUserCreate);
    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create seed user');
    }
  }
}