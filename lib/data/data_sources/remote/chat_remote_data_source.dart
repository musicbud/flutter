import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/channel.dart';
import '../../../models/message.dart';

abstract class ChatRemoteDataSource {
  // Authentication
  Future<Map<String, dynamic>> login(String username, String password);

  // Channel Management
  Future<List<Channel>> getChannelList();
  Future<Map<String, dynamic>> createChannel(Map<String, dynamic> channelData);
  Future<Map<String, dynamic>> getChannelDetails(int channelId);
  Future<Map<String, dynamic>> getChannelDashboardData(int channelId);
  Future<Map<String, dynamic>> joinChannel(String channelId);
  Future<Map<String, dynamic>> requestJoinChannel(int channelId);

  // User Management
  Future<List<Map<String, dynamic>>> getUsers();
  Future<Map<String, dynamic>> getChannelUsers(int channelId);
  Future<Map<String, dynamic>> addChannelMember(int channelId, String username);
  Future<Map<String, dynamic>> removeChannelMember(int channelId, int userId);

  // Role Management
  Future<bool> isUserAdmin(int channelId);
  Future<bool> isChannelAdmin(int channelId);
  Future<bool> isChannelMember(int channelId);
  Future<bool> isChannelModerator(int channelId);
  Future<Map<String, bool>> checkChannelRoles(int channelId);
  Future<Map<String, dynamic>> makeAdmin(int channelId, int userId);
  Future<Map<String, dynamic>> removeAdmin(int channelId, int userId);
  Future<Map<String, dynamic>> addModerator(int channelId, int userId);
  Future<Map<String, dynamic>> removeModerator(int channelId, int userId);

  // User Actions
  Future<Map<String, dynamic>> acceptUser(int channelId, int userId);
  Future<Map<String, dynamic>> kickUser(int channelId, int userId);
  Future<Map<String, dynamic>> blockUser(int channelId, int userId);
  Future<Map<String, dynamic>> unblockUser(int channelId, int userId);

  // Message Management
  Future<List<Message>> getChannelMessages(int channelId);
  Future<Map<String, dynamic>> getUserMessages(
      String currentUsername, String otherUsername);
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> messageData);
  Future<Map<String, dynamic>> sendChannelMessage(
      int channelId, String senderUsername, String content);
  Future<Map<String, dynamic>> sendUserMessage(
      String senderUsername, String recipientUsername, String content);
  Future<Map<String, dynamic>> deleteMessage(int channelId, int messageId);

  // Invitations and Blocked Users
  Future<List<Map<String, dynamic>>> getChannelInvitations(int channelId);
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(int channelId);
  Future<List<Map<String, dynamic>>> getUserInvitations(int userId);

  // Admin Actions
  Future<Map<String, dynamic>> performAdminAction(
      int channelId, String action, int userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client _client;
  final String _token;
  final String _baseUrl = 'http://127.0.0.1:8000';

  ChatRemoteDataSourceImpl({
    required http.Client client,
    required String token,
  })  : _client = client,
        _token = token;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: _headers,
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<List<Channel>> getChannelList() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Channel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load channels');
    }
  }

  @override
  Future<Map<String, dynamic>> createChannel(
      Map<String, dynamic> channelData) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels'),
      headers: _headers,
      body: jsonEncode(channelData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create channel');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDetails(int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get channel details');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDashboardData(int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId/dashboard'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get channel dashboard data');
    }
  }

  @override
  Future<Map<String, dynamic>> joinChannel(String channelId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/join'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to join channel');
    }
  }

  @override
  Future<Map<String, dynamic>> requestJoinChannel(int channelId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/request-join'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to request join channel');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get users');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelUsers(int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId/users'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get channel users');
    }
  }

  @override
  Future<Map<String, dynamic>> addChannelMember(
      int channelId, String username) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/members'),
      headers: _headers,
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add channel member');
    }
  }

  @override
  Future<Map<String, dynamic>> removeChannelMember(
      int channelId, int userId) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/channels/$channelId/members/$userId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to remove channel member');
    }
  }

  @override
  Future<bool> isUserAdmin(int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId/is-admin'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['is_admin'] ?? false;
    } else {
      throw Exception('Failed to check admin status');
    }
  }

  @override
  Future<bool> isChannelAdmin(int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId/is-admin'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['is_admin'] ?? false;
    } else {
      throw Exception('Failed to check channel admin status');
    }
  }

  @override
  Future<bool> isChannelMember(int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId/is-member'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['is_member'] ?? false;
    } else {
      throw Exception('Failed to check member status');
    }
  }

  @override
  Future<bool> isChannelModerator(int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId/is-moderator'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['is_moderator'] ?? false;
    } else {
      throw Exception('Failed to check moderator status');
    }
  }

  @override
  Future<Map<String, bool>> checkChannelRoles(int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId/roles'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'is_admin': data['is_admin'] ?? false,
        'is_moderator': data['is_moderator'] ?? false,
        'is_member': data['is_member'] ?? false,
      };
    } else {
      throw Exception('Failed to check channel roles');
    }
  }

  @override
  Future<Map<String, dynamic>> makeAdmin(int channelId, int userId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/admins'),
      headers: _headers,
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to make admin');
    }
  }

  @override
  Future<Map<String, dynamic>> removeAdmin(int channelId, int userId) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/channels/$channelId/admins/$userId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to remove admin');
    }
  }

  @override
  Future<Map<String, dynamic>> addModerator(int channelId, int userId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/moderators'),
      headers: _headers,
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add moderator');
    }
  }

  @override
  Future<Map<String, dynamic>> removeModerator(
      int channelId, int userId) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/channels/$channelId/moderators/$userId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to remove moderator');
    }
  }

  @override
  Future<Map<String, dynamic>> acceptUser(int channelId, int userId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/accept-user'),
      headers: _headers,
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to accept user');
    }
  }

  @override
  Future<Map<String, dynamic>> kickUser(int channelId, int userId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/kick'),
      headers: _headers,
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to kick user');
    }
  }

  @override
  Future<Map<String, dynamic>> blockUser(int channelId, int userId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/block'),
      headers: _headers,
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to block user');
    }
  }

  @override
  Future<Map<String, dynamic>> unblockUser(int channelId, int userId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/unblock'),
      headers: _headers,
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to unblock user');
    }
  }

  @override
  Future<List<Message>> getChannelMessages(int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId/messages'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get channel messages');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserMessages(
      String currentUsername, String otherUsername) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/messages/direct').replace(queryParameters: {
        'current_username': currentUsername,
        'other_username': otherUsername,
      }),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user messages');
    }
  }

  @override
  Future<Map<String, dynamic>> sendMessage(
      Map<String, dynamic> messageData) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/messages'),
      headers: _headers,
      body: jsonEncode(messageData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send message');
    }
  }

  @override
  Future<Map<String, dynamic>> sendChannelMessage(
      int channelId, String senderUsername, String content) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/messages'),
      headers: _headers,
      body: jsonEncode({
        'sender_username': senderUsername,
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send channel message');
    }
  }

  @override
  Future<Map<String, dynamic>> sendUserMessage(
      String senderUsername, String recipientUsername, String content) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/messages/direct'),
      headers: _headers,
      body: jsonEncode({
        'sender_username': senderUsername,
        'recipient_username': recipientUsername,
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send user message');
    }
  }

  @override
  Future<Map<String, dynamic>> deleteMessage(
      int channelId, int messageId) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/channels/$channelId/messages/$messageId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete message');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelInvitations(
      int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId/invitations'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get channel invitations');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(
      int channelId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/channels/$channelId/blocked-users'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get blocked users');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserInvitations(int userId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/users/$userId/invitations'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get user invitations');
    }
  }

  @override
  Future<Map<String, dynamic>> performAdminAction(
      int channelId, String action, int userId) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/channels/$channelId/admin-actions'),
      headers: _headers,
      body: jsonEncode({
        'action': action,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to perform admin action');
    }
  }
}
