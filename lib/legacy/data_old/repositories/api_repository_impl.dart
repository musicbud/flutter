import 'package:dio/dio.dart';
import '../../domain/repositories/api_repository.dart';

class ApiRepositoryImpl implements ApiRepository {
  final Dio _dio;
  final String baseUrl;

  ApiRepositoryImpl({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  @override
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<List<dynamic>> getChannels() async {
    try {
      final response = await _dio.get('/channels');
      return response.data['channels'] as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to get channels: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDetails(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get channel details: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createChannel(
      Map<String, dynamic> channelData) async {
    try {
      final response = await _dio.post('/channels', data: channelData);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to create channel: $e');
    }
  }
}
