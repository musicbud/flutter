import 'package:musicbud_flutter/data/network/dio_client.dart';
import 'package:musicbud_flutter/data/models/common_track.dart';
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
  Future<List<CommonTrack>> getPlayedTracksWithLocation() async {
    final response = await dioClient.get('/spotify/played-tracks-with-location');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tracks with location');
    }
  }
}