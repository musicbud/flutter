import 'package:dio/dio.dart';

class ChatService {
  final Dio _dio;
  final String baseUrl;

  ChatService({required String baseUrl})
      : baseUrl = baseUrl,
        _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<void> sendMessage({
    required String channelId,
    required String message,
    required String userId,
  }) async {
    try {
      await _dio.post('/chat/messages', data: {
        'channelId': channelId,
        'message': message,
        'userId': userId,
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<List<dynamic>> getMessages({
    required String channelId,
    int? limit,
    String? beforeId,
  }) async {
    try {
      final response = await _dio.get(
        '/chat/messages',
        queryParameters: {
          'channelId': channelId,
          if (limit != null) 'limit': limit,
          if (beforeId != null) 'beforeId': beforeId,
        },
      );
      return response.data['messages'] as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }
}
