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
}
