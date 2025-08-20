import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../network/dio_client.dart';

abstract class ChatRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> getChannelUsers(String channelId);
  Future<Map<String, dynamic>> removeAdmin(String channelId, String userId);
  Future<Map<String, dynamic>> addChannelMember(
      String channelId, String username);
  Future<bool> isUserAdmin(String channelId);
  Future<Map<String, bool>> checkChannelRoles(String channelId);
  Future<Map<String, dynamic>> getChannelDashboardData(String channelId);
  Future<bool> isChannelAdmin(String channelId);
  Future<bool> isChannelMember(String channelId);
  Future<bool> isChannelModerator(String channelId);
  Future<Map<String, dynamic>> removeChannelMember(
      String channelId, String userId);
  Future<Map<String, dynamic>> makeAdmin(String channelId, String userId);
  Future<Map<String, dynamic>> addModerator(String channelId, String userId);
  Future<Map<String, dynamic>> removeModerator(String channelId, String userId);
  Future<Map<String, dynamic>> acceptUser(String channelId, String userId);
  Future<Map<String, dynamic>> kickUser(String channelId, String userId);
  Future<Map<String, dynamic>> blockUser(String channelId, String userId);
  Future<Map<String, dynamic>> unblockUser(String channelId, String userId);
  Future<Map<String, dynamic>> deleteMessage(
      String channelId, String messageId);
  Future<List<Map<String, dynamic>>> getChannelInvitations(String channelId);
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(String channelId);
  Future<List<Map<String, dynamic>>> getUserInvitations(String userId);
  Future<List<Map<String, dynamic>>> getChannelList();
  Future<Map<String, dynamic>> joinChannel(String channelId);
  Future<List<Map<String, dynamic>>> getUsers();
  Future<Map<String, dynamic>> createChannel(Map<String, dynamic> channelData);
  Future<Map<String, dynamic>> getUserMessages(
      String currentUsername, String otherUsername);
  Future<Map<String, dynamic>> sendUserMessage(
      String senderUsername, String recipientUsername, String content);
  Future<Map<String, dynamic>> getChannelMessages(String channelId);
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> messageData);
  Future<Map<String, dynamic>> sendChannelMessage(
      String channelId, String senderUsername, String content);
  Future<Map<String, dynamic>> performAdminAction(
      String channelId, String action, String userId);
  Future<Map<String, dynamic>> getChannelDetails(String channelId);
  Future<Map<String, dynamic>> requestJoinChannel(String channelId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;
  static const String _baseUrl = 'http://84.235.170.234';

  ChatRemoteDataSourceImpl() : _dio = DioClient(baseUrl: _baseUrl).dio;

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post('/chat/login/',
          data: {'username': username, 'password': password});
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to login');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelUsers(String channelId) async {
    try {
      final response = await _dio.post('/chat/get_channel_users/$channelId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel users');
    }
  }

  @override
  Future<Map<String, dynamic>> removeAdmin(
      String channelId, String userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/remove_admin/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove admin');
    }
  }

  @override
  Future<Map<String, dynamic>> addChannelMember(
      String channelId, String username) async {
    try {
      final response = await _dio.post('/chat/add_channel_member/$channelId/',
          data: {'username': username});
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to add channel member');
    }
  }

  @override
  Future<bool> isUserAdmin(String channelId) async {
    try {
      final response = await _dio.post('/chat/channel/$channelId/is_admin/');
      return response.data['is_admin'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to check admin status');
    }
  }

  @override
  Future<Map<String, bool>> checkChannelRoles(String channelId) async {
    try {
      final response = await _dio.post('/chat/channel/$channelId/check_roles/');
      return {
        'is_admin': response.data['is_admin'] ?? false,
        'is_moderator': response.data['is_moderator'] ?? false,
        'is_member': response.data['is_member'] ?? false,
      };
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to check channel roles');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDashboardData(String channelId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/dashboard_data/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get dashboard data');
    }
  }

  @override
  Future<bool> isChannelAdmin(String channelId) async {
    try {
      final response = await _dio.post('/chat/channel/$channelId/is_admin/');
      return response.data['is_admin'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to check channel admin status');
    }
  }

  @override
  Future<bool> isChannelMember(String channelId) async {
    try {
      final response = await _dio.post('/chat/channel/$channelId/is_member/');
      return response.data['is_member'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to check member status');
    }
  }

  @override
  Future<bool> isChannelModerator(String channelId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/is_moderator/');
      return response.data['is_moderator'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to check moderator status');
    }
  }

  @override
  Future<Map<String, dynamic>> removeChannelMember(
      String channelId, String userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/remove_member/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to remove channel member');
    }
  }

  @override
  Future<Map<String, dynamic>> makeAdmin(
      String channelId, String userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/make_admin/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to make admin');
    }
  }

  @override
  Future<Map<String, dynamic>> addModerator(
      String channelId, String userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/add_moderator/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to add moderator');
    }
  }

  @override
  Future<Map<String, dynamic>> removeModerator(
      String channelId, String userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/remove_moderator/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove moderator');
    }
  }

  @override
  Future<Map<String, dynamic>> acceptUser(
      String channelId, String userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/accept_user/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to accept user');
    }
  }

  @override
  Future<Map<String, dynamic>> kickUser(String channelId, String userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/kick/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to kick user');
    }
  }

  @override
  Future<Map<String, dynamic>> blockUser(
      String channelId, String userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/block/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to block user');
    }
  }

  @override
  Future<Map<String, dynamic>> unblockUser(
      String channelId, String userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/unblock/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unblock user');
    }
  }

  @override
  Future<Map<String, dynamic>> deleteMessage(
      String channelId, String messageId) async {
    try {
      final response = await _dio
          .delete('/chat/channel/$channelId/delete_message/$messageId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to delete message');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelInvitations(
      String channelId) async {
    try {
      final response =
          await _dio.post('/chat/get_channel_invitations/$channelId/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel invitations');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(
      String channelId) async {
    try {
      final response =
          await _dio.post('/chat/get_channel_blocked_users/$channelId/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get blocked users');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserInvitations(String userId) async {
    try {
      final response = await _dio.post('/chat/get_user_invitations/$userId/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get user invitations');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelList() async {
    try {
      final response = await _dio.post('/chat/channels/');
      final data = response.data as Map<String, dynamic>;
      return (data['channels'] as List).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel list');
    }
  }

  @override
  Future<Map<String, dynamic>> joinChannel(String channelId) async {
    try {
      final response = await _dio.post('/chat/join_channel/$channelId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to join channel');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final response = await _dio.post('/chat/users/');
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else if (response.data is Map && response.data['users'] is List) {
        return List<Map<String, dynamic>>.from(response.data['users']);
      }
      throw ServerException(message: 'Invalid response format');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get users');
    }
  }

  @override
  Future<Map<String, dynamic>> createChannel(
      Map<String, dynamic> channelData) async {
    try {
      final response =
          await _dio.post('/chat/create_channel/', data: channelData);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to create channel');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserMessages(
      String currentUsername, String otherUsername) async {
    try {
      final encodedCurrentUsername = Uri.encodeComponent(currentUsername);
      final encodedOtherUsername = Uri.encodeComponent(otherUsername);
      final response = await _dio.post(
          '/chat/get_user_messages/$encodedCurrentUsername/$encodedOtherUsername/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get user messages');
    }
  }

  @override
  Future<Map<String, dynamic>> sendUserMessage(
      String senderUsername, String recipientUsername, String content) async {
    try {
      final response = await _dio.post('/chat/send_user_message/', data: {
        'sender_username': senderUsername,
        'recipient_username': recipientUsername,
        'content': content,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to send user message');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelMessages(String channelId) async {
    try {
      final response = await _dio.post('/api/channels/$channelId/messages');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel messages');
    }
  }

  @override
  Future<Map<String, dynamic>> sendMessage(
      Map<String, dynamic> messageData) async {
    try {
      final response =
          await _dio.post('/chat/send_message/', data: messageData);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to send message');
    }
  }

  @override
  Future<Map<String, dynamic>> sendChannelMessage(
      String channelId, String senderUsername, String content) async {
    try {
      final response = await _dio.post('/chat/send_message/', data: {
        'recipient_type': 'channel',
        'recipient_id': channelId,
        'sender_username': senderUsername,
        'content': content,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to send channel message');
    }
  }

  @override
  Future<Map<String, dynamic>> performAdminAction(
      String channelId, String action, String userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/admin_action/', data: {
        'action': action,
        'user_id': userId,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to perform admin action');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDetails(String channelId) async {
    try {
      final response = await _dio.post('/api/channels/$channelId');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel details');
    }
  }

  @override
  Future<Map<String, dynamic>> requestJoinChannel(String channelId) async {
    try {
      final response = await _dio.post('/api/channels/$channelId/join');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to request join channel');
    }
  }
}
