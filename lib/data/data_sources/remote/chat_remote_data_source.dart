import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../models/channel.dart';
import '../../../models/message.dart';

abstract class ChatRemoteDataSource {
  // Authentication
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> refreshToken(String refreshToken);

  // Channel Management
  Future<List<Channel>> getChannels();
  Future<Channel> createChannel(Map<String, dynamic> channelData);
  Future<Channel> getChannelById(int channelId);
  Future<Channel> getChannelByName(String channelName);
  Future<Map<String, dynamic>> getChannelDashboard(int channelId);
  Future<Map<String, dynamic>> getChannelStatistics(int channelId);
  Future<void> requestJoinChannel(int channelId);

  // User Management
  Future<List<Map<String, dynamic>>> getUsers();
  Future<List<Map<String, dynamic>>> getChannelUsers(int channelId);
  Future<List<Map<String, dynamic>>> getChannelInvitations(int channelId);
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(int channelId);
  Future<List<Map<String, dynamic>>> getUserInvitations(int userId);
  Future<int> getUserCount();

  // Role Management
  Future<void> addModerator(int channelId, int userId);
  Future<void> removeModerator(int channelId, int userId);
  Future<void> makeAdmin(int channelId, int userId);
  Future<void> removeAdmin(int channelId, int userId);
  Future<void> removeMember(int channelId, int userId);

  // User Actions
  Future<void> acceptUser(int channelId, int userId);
  Future<void> kickUser(int channelId, int userId);
  Future<void> blockUser(int channelId, int userId);
  Future<void> unblockUser(int channelId, int userId);

  // Message Management
  Future<List<Message>> getChannelMessages(int channelId);
  Future<List<Message>> getUserMessages(
      String userUsername, String otherUsername);
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
      final response = await _dioClient.post('/chat/login/', data: {
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
      final response = await _dioClient.post('/chat/refresh-token/', data: {
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
      final response = await _dioClient.get('/chat/get_channels/');
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
          await _dioClient.post('/chat/create_channel/', data: channelData);
      return Channel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to create channel');
    }
  }

  @override
  Future<Channel> getChannelById(int channelId) async {
    try {
      final response = await _dioClient.get('/chat/channel/$channelId/');
      return Channel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel');
    }
  }

  @override
  Future<Channel> getChannelByName(String channelName) async {
    try {
      final response = await _dioClient.get('/chat/channel/$channelName/');
      return Channel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDashboard(int channelId) async {
    try {
      final response =
          await _dioClient.get('/chat/channel/$channelId/dashboard/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel dashboard');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelStatistics(int channelId) async {
    try {
      final response =
          await _dioClient.get('/chat/channel/$channelId/statistics/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel statistics');
    }
  }

  @override
  Future<void> requestJoinChannel(int channelId) async {
    try {
      await _dioClient.post('/chat/channel/$channelId/request_join/');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to request join channel');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final response = await _dioClient.get('/chat/get_users/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get users');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelUsers(int channelId) async {
    try {
      final response =
          await _dioClient.get('/chat/get_channel_users/$channelId/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel users');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelInvitations(
      int channelId) async {
    try {
      final response =
          await _dioClient.get('/chat/get_channel_invitations/$channelId/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel invitations');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(
      int channelId) async {
    try {
      final response =
          await _dioClient.get('/chat/get_channel_blocked_users/$channelId/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get blocked users');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserInvitations(int userId) async {
    try {
      final response =
          await _dioClient.get('/chat/get_user_invitations/$userId/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get user invitations');
    }
  }

  @override
  Future<int> getUserCount() async {
    try {
      final response = await _dioClient.get('/chat/user_count/');
      return response.data['count'];
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get user count');
    }
  }

  @override
  Future<void> addModerator(int channelId, int userId) async {
    try {
      await _dioClient.post('/chat/channel/$channelId/add_moderator/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to add moderator');
    }
  }

  @override
  Future<void> removeModerator(int channelId, int userId) async {
    try {
      await _dioClient
          .post('/chat/channel/$channelId/remove_moderator/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove moderator');
    }
  }

  @override
  Future<void> makeAdmin(int channelId, int userId) async {
    try {
      await _dioClient.post('/chat/channel/$channelId/make_admin/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to make admin');
    }
  }

  @override
  Future<void> removeAdmin(int channelId, int userId) async {
    try {
      await _dioClient.post('/chat/channel/$channelId/remove_admin/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove admin');
    }
  }

  @override
  Future<void> removeMember(int channelId, int userId) async {
    try {
      await _dioClient.post('/chat/channel/$channelId/remove_member/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove member');
    }
  }

  @override
  Future<void> acceptUser(int channelId, int userId) async {
    try {
      await _dioClient.post('/chat/channel/$channelId/accept_user/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to accept user');
    }
  }

  @override
  Future<void> kickUser(int channelId, int userId) async {
    try {
      await _dioClient.post('/chat/channel/$channelId/kick/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to kick user');
    }
  }

  @override
  Future<void> blockUser(int channelId, int userId) async {
    try {
      await _dioClient.post('/chat/channel/$channelId/block/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to block user');
    }
  }

  @override
  Future<void> unblockUser(int channelId, int userId) async {
    try {
      await _dioClient.post('/chat/channel/$channelId/unblock/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unblock user');
    }
  }

  @override
  Future<List<Message>> getChannelMessages(int channelId) async {
    try {
      final response =
          await _dioClient.get('/chat/get_channel_messages/$channelId/');
      return (response.data as List)
          .map((message) => Message.fromJson(message))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel messages');
    }
  }

  @override
  Future<List<Message>> getUserMessages(
      String userUsername, String otherUsername) async {
    try {
      final response = await _dioClient
          .get('/chat/get_user_messages/$userUsername/$otherUsername/');
      return (response.data as List)
          .map((message) => Message.fromJson(message))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get user messages');
    }
  }

  @override
  Future<Message> sendChannelMessage(int channelId, String content) async {
    try {
      final response = await _dioClient.post('/chat/send_message/', data: {
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
      final response = await _dioClient.post('/chat/send_user_message/', data: {
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
          .post('/chat/channel/$channelId/delete_message/$messageId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to delete message');
    }
  }
}
