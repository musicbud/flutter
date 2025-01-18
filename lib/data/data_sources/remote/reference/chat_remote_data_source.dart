import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../network/dio_client.dart';

abstract class ChatRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> getChannelUsers(int channelId);
  Future<Map<String, dynamic>> removeAdmin(int channelId, int userId);
  Future<Map<String, dynamic>> addChannelMember(int channelId, String username);
  Future<bool> isUserAdmin(int channelId);
  Future<Map<String, bool>> checkChannelRoles(int channelId);
  Future<Map<String, dynamic>> getChannelDashboardData(int channelId);
  Future<bool> isChannelAdmin(int channelId);
  Future<bool> isChannelMember(int channelId);
  Future<bool> isChannelModerator(int channelId);
  Future<Map<String, dynamic>> removeChannelMember(int channelId, int userId);
  Future<Map<String, dynamic>> makeAdmin(int channelId, int userId);
  Future<Map<String, dynamic>> addModerator(int channelId, int userId);
  Future<Map<String, dynamic>> removeModerator(int channelId, int userId);
  Future<Map<String, dynamic>> acceptUser(int channelId, int userId);
  Future<Map<String, dynamic>> kickUser(int channelId, int userId);
  Future<Map<String, dynamic>> blockUser(int channelId, int userId);
  Future<Map<String, dynamic>> unblockUser(int channelId, int userId);
  Future<Map<String, dynamic>> deleteMessage(int channelId, int messageId);
  Future<List<Map<String, dynamic>>> getChannelInvitations(int channelId);
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(int channelId);
  Future<List<Map<String, dynamic>>> getUserInvitations(int userId);
  Future<List<Map<String, dynamic>>> getChannelList();
  Future<Map<String, dynamic>> joinChannel(String channelId);
  Future<List<Map<String, dynamic>>> getUsers();
  Future<Map<String, dynamic>> createChannel(Map<String, dynamic> channelData);
  Future<Map<String, dynamic>> getUserMessages(
      String currentUsername, String otherUsername);
  Future<Map<String, dynamic>> sendUserMessage(
      String senderUsername, String recipientUsername, String content);
  Future<Map<String, dynamic>> getChannelMessages(int channelId);
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> messageData);
  Future<Map<String, dynamic>> sendChannelMessage(
      int channelId, String senderUsername, String content);
  Future<Map<String, dynamic>> performAdminAction(
      int channelId, String action, int userId);
  Future<Map<String, dynamic>> getChannelDetails(int channelId);
  Future<Map<String, dynamic>> requestJoinChannel(int channelId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl() : _dio = DioClient().dio;

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
  Future<Map<String, dynamic>> getChannelUsers(int channelId) async {
    try {
      final response = await _dio.get('/chat/get_channel_users/$channelId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel users');
    }
  }

  @override
  Future<Map<String, dynamic>> removeAdmin(int channelId, int userId) async {
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
      int channelId, String username) async {
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
  Future<bool> isUserAdmin(int channelId) async {
    try {
      final response = await _dio.get('/chat/channel/$channelId/is_admin/');
      return response.data['is_admin'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to check admin status');
    }
  }

  @override
  Future<Map<String, bool>> checkChannelRoles(int channelId) async {
    try {
      final response = await _dio.get('/chat/channel/$channelId/check_roles/');
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
  Future<Map<String, dynamic>> getChannelDashboardData(int channelId) async {
    try {
      final response =
          await _dio.get('/chat/channel/$channelId/dashboard_data/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get dashboard data');
    }
  }

  @override
  Future<bool> isChannelAdmin(int channelId) async {
    try {
      final response = await _dio.get('/chat/channel/$channelId/is_admin/');
      return response.data['is_admin'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to check channel admin status');
    }
  }

  @override
  Future<bool> isChannelMember(int channelId) async {
    try {
      final response = await _dio.get('/chat/channel/$channelId/is_member/');
      return response.data['is_member'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to check member status');
    }
  }

  @override
  Future<bool> isChannelModerator(int channelId) async {
    try {
      final response = await _dio.get('/chat/channel/$channelId/is_moderator/');
      return response.data['is_moderator'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to check moderator status');
    }
  }

  @override
  Future<Map<String, dynamic>> removeChannelMember(
      int channelId, int userId) async {
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
  Future<Map<String, dynamic>> makeAdmin(int channelId, int userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/make_admin/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to make admin');
    }
  }

  @override
  Future<Map<String, dynamic>> addModerator(int channelId, int userId) async {
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
      int channelId, int userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/remove_moderator/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove moderator');
    }
  }

  @override
  Future<Map<String, dynamic>> acceptUser(int channelId, int userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/accept_user/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to accept user');
    }
  }

  @override
  Future<Map<String, dynamic>> kickUser(int channelId, int userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/kick/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to kick user');
    }
  }

  @override
  Future<Map<String, dynamic>> blockUser(int channelId, int userId) async {
    try {
      final response =
          await _dio.post('/chat/channel/$channelId/block/$userId/');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to block user');
    }
  }

  @override
  Future<Map<String, dynamic>> unblockUser(int channelId, int userId) async {
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
      int channelId, int messageId) async {
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
      int channelId) async {
    try {
      final response =
          await _dio.get('/chat/get_channel_invitations/$channelId/');
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
          await _dio.get('/chat/get_channel_blocked_users/$channelId/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get blocked users');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserInvitations(int userId) async {
    try {
      final response = await _dio.get('/chat/get_user_invitations/$userId/');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get user invitations');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelList() async {
    try {
      final response = await _dio.get('/chat/channels/');
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
      final response = await _dio.get('/chat/users/');
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
      final response = await _dio.get(
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
  Future<Map<String, dynamic>> getChannelMessages(int channelId) async {
    try {
      final response = await _dio.get('/api/channels/$channelId/messages');
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
      int channelId, String senderUsername, String content) async {
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
      int channelId, String action, int userId) async {
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
  Future<Map<String, dynamic>> getChannelDetails(int channelId) async {
    try {
      final response = await _dio.get('/api/channels/$channelId');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get channel details');
    }
  }

  @override
  Future<Map<String, dynamic>> requestJoinChannel(int channelId) async {
    try {
      final response = await _dio.post('/api/channels/$channelId/join');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to request join channel');
    }
  }
}
