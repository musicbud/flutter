import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../../config/api_config.dart';
import '../../../domain/models/chat.dart';
import '../../../domain/models/message.dart';
import '../../../domain/models/channel.dart';
import '../../../domain/models/chat_message.dart';
import '../../../domain/models/user_profile.dart';
import '../../network/dio_client.dart';

abstract class ChatRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<List<Channel>> getChannels();
  Future<Channel> createChannel(Map<String, dynamic> channelData);
  Future<Channel> getChannelById(int channelId);
  Future<List<ChatMessage>> getChannelMessages(int channelId);
  Future<Message> sendChannelMessage(int channelId, String content);
  Future<Message> sendUserMessage(String recipientUsername, String content);
  Future<void> deleteMessage(int channelId, int messageId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient _dioClient;

  ChatRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatLogin, data: {
        'username': username,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to login');
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.post(ApiConfig.refreshToken, data: {
        'refresh': refreshToken,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to refresh token');
    }
  }

  @override
  Future<List<Channel>> getChannels() async {
    try {
      final response = await _dioClient.get(ApiConfig.chatGetChannels);
      return (response.data as List)
          .map((channel) => Channel.fromJson(channel))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channels');
    }
  }

  @override
  Future<Channel> createChannel(Map<String, dynamic> channelData) async {
    try {
      final response =
          await _dioClient.post(ApiConfig.chatCreateChannel, data: channelData);
      return Channel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to create channel');
    }
  }

  @override
  Future<Channel> getChannelById(int channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatGetChannels}$channelId/');
      return Channel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel');
    }
  }

  @override
  Future<List<ChatMessage>> getChannelMessages(int channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatGetChannelMessages}$channelId/');
      return (response.data as List)
          .map((message) => ChatMessage.fromJson(message))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel messages');
    }
  }

  @override
  Future<Message> sendChannelMessage(int channelId, String content) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatSendChannelMessage, data: {
        'channel_id': channelId,
        'content': content,
      });
      return Message.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to send channel message');
    }
  }

  @override
  Future<Message> sendUserMessage(
      String recipientUsername, String content) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatSendUserMessage, data: {
        'recipient_username': recipientUsername,
        'content': content,
      });
      return Message.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to send user message');
    }
  }

  @override
  Future<void> deleteMessage(int channelId, int messageId) async {
    try {
      await _dioClient
          .post('${ApiConfig.chatDeleteMessage}/$channelId/delete_message/$messageId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to delete message');
    }
  }
}
