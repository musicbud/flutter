import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musicbud_flutter/services/logging_interceptor.dart';

class ChatService {
  final Dio dio;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? currentUsername;
  String? accessToken;

  ChatService(this.dio);

  void _addInterceptors() {
    dio.interceptors.add(LoggingInterceptor());
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.extra['withCredentials'] = true;
          final token = await _secureStorage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> login(String username, String password) async {
    try {
      final response = await dio.post('/chat/login/',
          data: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        currentUsername = username;
        if (response.data['tokens'] != null) {
          await _secureStorage.write(
              key: 'access_token', value: response.data['tokens']['access']);
          await _secureStorage.write(
              key: 'refresh_token', value: response.data['tokens']['refresh']);
        }
      }

      return response;
    } catch (e) {
      print('Exception caught in login method: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getChannelUsers(int channelId) async {
    final response = await dio.get('/chat/get_channel_users/$channelId/');
    return response.data;
  }

  Future<Map<String, dynamic>> removeAdmin(int channelId, int userId) async {
    final response =
        await dio.post('/chat/channel/$channelId/remove_admin/$userId/');
    return response.data;
  }

  Future<Map<String, dynamic>> addChannelMember(
      int channelId, String username) async {
    final response = await dio.post('/chat/add_channel_member/$channelId/',
        data: {'username': username});
    return response.data;
  }

  Future<bool> isUserAdmin(int channelId) async {
    try {
      final response = await dio.get('/chat/channel/$channelId/is_admin/');
      return response.data['is_admin'] ?? false;
    } catch (e) {
      print('Error checking admin status: $e');
      if (e is DioException && e.response?.statusCode == 404) {
        print(
            'Endpoint not found. Make sure the server-side route is correctly implemented.');
      }
      return false;
    }
  }

  Future<Map<String, bool>> checkChannelRoles(int channelId) async {
    try {
      final response = await dio.get('/chat/channel/$channelId/check_roles/');
      return {
        'is_admin': response.data['is_admin'] ?? false,
        'is_moderator': response.data['is_moderator'] ?? false,
        'is_member': response.data['is_member'] ?? false,
      };
    } catch (e) {
      print('Error checking channel roles: $e');
      return {'is_admin': false, 'is_moderator': false, 'is_member': false};
    }
  }

  Future<Map<String, dynamic>> getChannelDashboardData(int channelId) async {
    try {
      final response =
          await dio.get('/chat/channel/$channelId/dashboard_data/');
      return response.data;
    } catch (e) {
      print('Error getting channel dashboard data: $e');
      return {
        'status': 'error',
        'message': 'Unable to get channel dashboard data'
      };
    }
  }

  Future<bool> isChannelAdmin(int channelId) async {
    try {
      final response = await dio.get('/chat/channel/$channelId/is_admin/');
      return response.data['is_admin'] ?? false;
    } catch (e) {
      print('Error checking if user is channel admin: $e');
      return false;
    }
  }

  Future<bool> isChannelMember(int channelId) async {
    try {
      final response = await dio.get('/chat/channel/$channelId/is_member/');
      return response.data['is_member'] ?? false;
    } catch (e) {
      print('Error checking if user is channel member: $e');
      return false;
    }
  }

  Future<bool> isChannelModerator(int channelId) async {
    try {
      final response = await dio.get('/chat/channel/$channelId/is_moderator/');
      return response.data['is_moderator'] ?? false;
    } catch (e) {
      print('Error checking if user is channel moderator: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> removeChannelMember(
      int channelId, int userId) async {
    try {
      final response =
          await dio.post('/chat/channel/$channelId/remove_member/$userId/');
      return response.data;
    } catch (e) {
      print('Error removing channel member: $e');
      return {'status': 'error', 'message': 'Unable to remove channel member'};
    }
  }

  Future<Map<String, dynamic>> makeAdmin(int channelId, int userId) async {
    try {
      final response =
          await dio.post('/chat/channel/$channelId/make_admin/$userId/');
      return response.data;
    } catch (e) {
      print('Error making user admin: $e');
      return {'status': 'error', 'message': 'Unable to make user admin'};
    }
  }

  Future<Map<String, dynamic>> addModerator(int channelId, int userId) async {
    try {
      final response =
          await dio.post('/chat/channel/$channelId/add_moderator/$userId/');
      return response.data;
    } catch (e) {
      print('Error adding moderator: $e');
      return {'status': 'error', 'message': 'Unable to add moderator'};
    }
  }

  Future<Map<String, dynamic>> removeModerator(
      int channelId, int userId) async {
    try {
      final response =
          await dio.post('/chat/channel/$channelId/remove_moderator/$userId/');
      return response.data;
    } catch (e) {
      print('Error removing moderator: $e');
      return {'status': 'error', 'message': 'Unable to remove moderator'};
    }
  }

  Future<Map<String, dynamic>> acceptUser(int channelId, int userId) async {
    try {
      final response =
          await dio.post('/chat/channel/$channelId/accept_user/$userId/');
      return response.data;
    } catch (e) {
      print('Error accepting user: $e');
      return {'status': 'error', 'message': 'Unable to accept user'};
    }
  }

  Future<Map<String, dynamic>> kickUser(int channelId, int userId) async {
    try {
      final response = await dio.post('/chat/channel/$channelId/kick/$userId/');
      return response.data;
    } catch (e) {
      print('Error kicking user: $e');
      return {'status': 'error', 'message': 'Unable to kick user'};
    }
  }

  Future<Map<String, dynamic>> blockUser(int channelId, int userId) async {
    try {
      final response =
          await dio.post('/chat/channel/$channelId/block/$userId/');
      return response.data;
    } catch (e) {
      print('Error blocking user: $e');
      return {'status': 'error', 'message': 'Unable to block user'};
    }
  }

  Future<Map<String, dynamic>> unblockUser(int channelId, int userId) async {
    try {
      final response =
          await dio.post('/chat/channel/$channelId/unblock/$userId/');
      return response.data;
    } catch (e) {
      print('Error unblocking user: $e');
      return {'status': 'error', 'message': 'Unable to unblock user'};
    }
  }

  Future<Map<String, dynamic>> deleteMessage(
      int channelId, int messageId) async {
    try {
      final response = await dio
          .delete('/chat/channel/$channelId/delete_message/$messageId/');
      return response.data;
    } catch (e) {
      print('Error deleting message: $e');
      return {'status': 'error', 'message': 'Unable to delete message'};
    }
  }

  Future<List<Map<String, dynamic>>> getChannelInvitations(
      int channelId) async {
    try {
      final response =
          await dio.get('/chat/get_channel_invitations/$channelId/');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Error getting channel invitations: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(
      int channelId) async {
    try {
      final response =
          await dio.get('/chat/get_channel_blocked_users/$channelId/');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Error getting channel blocked users: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserInvitations(int userId) async {
    try {
      final response = await dio.get('/chat/get_user_invitations/$userId/');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Error getting user invitations: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getChannelList() async {
    try {
      final response = await dio.get('/chat/channels/');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return (data['channels'] as List).cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch channels');
      }
    } catch (e) {
      print('Error getting channel list: $e');
      return []; // Return an empty list instead of throwing an exception
    }
  }

  Future<Map<String, dynamic>> joinChannel(String channelId) async {
    try {
      final response = await dio.post('/chat/join_channel/$channelId/');
      return response.data;
    } catch (e) {
      print('Error joining channel: $e');
      return {'status': 'error', 'message': 'Unable to join channel'};
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      print('Fetching users from: ${dio.options.baseUrl}/chat/users/');
      final response = await dio.get('/chat/users/');
      print('Get users response status: ${response.statusCode}');
      print('Get users response data: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<Map<String, dynamic>>.from(response.data);
        } else if (response.data is Map && response.data['users'] is List) {
          return List<Map<String, dynamic>>.from(response.data['users']);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to get users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting users: $e');
      if (e is DioError) {
        print('DioError response: ${e.response}');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createChannel(
      Map<String, dynamic> channelData) async {
    try {
      final response =
          await dio.post('/chat/create_channel/', data: channelData);
      return response.data;
    } catch (e) {
      print('Error creating channel: $e');
      return {'status': 'error', 'message': 'Unable to create channel'};
    }
  }

  Future<Map<String, dynamic>> getUserMessages(
      String currentUsername, String otherUsername) async {
    final encodedCurrentUsername = Uri.encodeComponent(currentUsername);
    final encodedOtherUsername = Uri.encodeComponent(otherUsername);

    try {
      final response = await dio.get(
          '/chat/get_user_messages/$encodedCurrentUsername/$encodedOtherUsername/');
      if (response.statusCode == 404) {
        print('404 Error: URL not found - ${response.requestOptions.path}');
        throw Exception('Chat messages not found');
      }
      return response.data;
    } catch (e) {
      print('Error in getUserMessages: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendUserMessage(
      String senderUsername, String recipientUsername, String content) async {
    try {
      final response = await dio.post('/chat/send_user_message/', data: {
        'sender_username': senderUsername,
        'recipient_username': recipientUsername,
        'content': content,
      });
      return response.data;
    } catch (e) {
      print('Error sending user message: $e');
      return {'status': 'error', 'message': 'Unable to send user message'};
    }
  }

  Future<Response> getChannelMessages(int channelId) async {
    final response = await dio.get(
      '/api/channels/$channelId/messages',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return response;
  }

  Future<Map<String, dynamic>> sendMessage(
      Map<String, dynamic> messageData) async {
    try {
      final response = await dio.post('/chat/send_message/', data: messageData);
      return response.data;
    } catch (e) {
      print('Error sending message: $e');
      return {'status': 'error', 'message': 'Unable to send message'};
    }
  }

  Future<Map<String, dynamic>> sendChannelMessage(
      int channelId, String senderUsername, String content) async {
    try {
      // Check if the access token is set
      if (await _secureStorage.read(key: 'access_token') == null) {
        throw Exception('Not authenticated. Please log in.');
      }

      final response = await dio.post('/chat/send_message/', data: {
        'recipient_type': 'channel',
        'recipient_id': channelId,
        'sender_username': senderUsername,
        'content': content,
      });

      if (response.statusCode == 403) {
        throw Exception(
            'You do not have permission to send messages to this channel.');
      }

      return response.data;
    } catch (e) {
      print('Error sending channel message: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> performAdminAction(
      int channelId, String action, int userId) async {
    final response =
        await dio.post('/chat/channel/$channelId/admin_action/', data: {
      'action': action,
      'user_id': userId,
    });
    return response.data;
  }

  Future<Response> getChannelDetails(int channelId) async {
    final response = await dio.get(
      '/api/channels/$channelId',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return response;
  }

  Future<Response> requestJoinChannel(int channelId) async {
    final response = await dio.post(
      '/api/channels/$channelId/join',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return response;
  }
}
