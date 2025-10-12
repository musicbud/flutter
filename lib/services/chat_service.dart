import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../domain/repositories/chat_repository.dart';
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../models/message.dart';
import '../models/channel.dart';
import '../models/user_profile.dart';

class ChatService implements ChatRepository {
  final Dio _dio;
  final String baseUrl;
  WebSocketChannel? _channel;

  ChatService({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Real-time messaging
  void connectWebSocket(String userId) {
    final wsUrl = '${baseUrl.replaceFirst('http', 'ws')}/ws/chat?user_id=$userId';
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  }

  void disconnectWebSocket() {
    _channel?.sink.close();
    _channel = null;
  }

  Stream<dynamic> get messageStream => _channel?.stream ?? const Stream.empty();

  void sendRealTimeMessage(String channelId, String message, String userId) {
    if (_channel != null) {
      _channel!.sink.add({
        'type': 'message',
        'channel_id': channelId,
        'message': message,
        'user_id': userId,
      });
    }
  }

  // Direct chat operations
  @override
  Future<List<Chat>> getChats() async {
    try {
      final response = await _dio.get('/chats');
      return (response.data['chats'] as List)
          .map((json) => Chat.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get chats: $e');
    }
  }

  @override
  Future<Chat> getChatByUserId(String userId) async {
    try {
      final response = await _dio.get('/chats/user/$userId');
      return Chat.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get chat: $e');
    }
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String chatId,
      {int? limit, String? before}) async {
    try {
      final response = await _dio.get(
        '/chats/$chatId/messages',
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (before != null) 'before': before,
        },
      );
      return (response.data['messages'] as List)
          .map((json) => ChatMessage.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get chat messages: $e');
    }
  }

  @override
  Future<ChatMessage> sendDirectMessage(String chatId, String content) async {
    try {
      final response = await _dio.post('/chats/$chatId/messages', data: {
        'content': content,
      });
      return ChatMessage.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send direct message: $e');
    }
  }

  @override
  Future<void> markAsRead(String chatId) async {
    try {
      await _dio.put('/chats/$chatId/read');
    } catch (e) {
      throw Exception('Failed to mark as read: $e');
    }
  }

  @override
  Future<void> markChatAsRead(String chatId) async {
    return markAsRead(chatId);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      await _dio.delete('/chats/$chatId');
    } catch (e) {
      throw Exception('Failed to delete chat: $e');
    }
  }

  @override
  Future<void> archiveChat(String chatId) async {
    try {
      await _dio.put('/chats/$chatId/archive');
    } catch (e) {
      throw Exception('Failed to archive chat: $e');
    }
  }

  // Channel operations
  @override
  Future<List<Channel>> getChannels() async {
    try {
      final response = await _dio.get('/channels');
      return (response.data['channels'] as List)
          .map((json) => Channel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get channels: $e');
    }
  }

  @override
  Future<Channel> getChannel(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId');
      return Channel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get channel: $e');
    }
  }

  @override
  Future<Channel> createChannel(String name, String description,
      {bool isPrivate = false}) async {
    try {
      final response = await _dio.post('/channels', data: {
        'name': name,
        'description': description,
        'is_private': isPrivate,
      });
      return Channel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create channel: $e');
    }
  }

  @override
  Future<void> updateChannel(String channelId, String name, String description) async {
    try {
      await _dio.put('/channels/$channelId', data: {
        'name': name,
        'description': description,
      });
    } catch (e) {
      throw Exception('Failed to update channel: $e');
    }
  }

  @override
  Future<void> deleteChannel(String channelId) async {
    try {
      await _dio.delete('/channels/$channelId');
    } catch (e) {
      throw Exception('Failed to delete channel: $e');
    }
  }

  @override
  Future<List<Message>> getChannelMessages(String channelId,
      {int? limit, String? before}) async {
    try {
      final response = await _dio.get(
        '/channels/$channelId/messages',
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (before != null) 'before': before,
        },
      );
      return (response.data['messages'] as List)
          .map((json) => Message.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get channel messages: $e');
    }
  }

  @override
  Future<Message> sendChannelMessage(String channelId, String content) async {
    try {
      final response = await _dio.post('/channels/$channelId/messages', data: {
        'content': content,
      });
      return Message.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send channel message: $e');
    }
  }

  @override
  Future<void> joinChannel(String channelId) async {
    try {
      await _dio.post('/channels/$channelId/join');
    } catch (e) {
      throw Exception('Failed to join channel: $e');
    }
  }

  @override
  Future<void> leaveChannel(String channelId) async {
    try {
      await _dio.post('/channels/$channelId/leave');
    } catch (e) {
      throw Exception('Failed to leave channel: $e');
    }
  }

  @override
  Future<List<UserProfile>> getChannelMembers(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId/members');
      return (response.data['members'] as List)
          .map((json) => UserProfile.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get channel members: $e');
    }
  }

  @override
  Future<void> addChannelMember(String channelId, String username) async {
    try {
      await _dio.post('/channels/$channelId/members', data: {
        'username': username,
      });
    } catch (e) {
      throw Exception('Failed to add channel member: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelStatistics(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId/statistics');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get channel statistics: $e');
    }
  }

  // Channel admin operations
  @override
  Future<bool> isChannelAdmin(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId/admin');
      return response.data['is_admin'] as bool;
    } catch (e) {
      throw Exception('Failed to check admin status: $e');
    }
  }

  @override
  Future<void> addModerator(String channelId, String userId) async {
    try {
      await _dio.post('/channels/$channelId/moderators', data: {'user_id': userId});
    } catch (e) {
      throw Exception('Failed to add moderator: $e');
    }
  }

  @override
  Future<void> removeModerator(String channelId, String userId) async {
    try {
      await _dio.delete('/channels/$channelId/moderators/$userId');
    } catch (e) {
      throw Exception('Failed to remove moderator: $e');
    }
  }

  @override
  Future<void> makeAdmin(String channelId, String userId) async {
    try {
      await _dio.post('/channels/$channelId/admins', data: {'user_id': userId});
    } catch (e) {
      throw Exception('Failed to make admin: $e');
    }
  }

  @override
  Future<void> removeAdmin(String channelId, String userId) async {
    try {
      await _dio.delete('/channels/$channelId/admins/$userId');
    } catch (e) {
      throw Exception('Failed to remove admin: $e');
    }
  }

  @override
  Future<void> kickUser(String channelId, String userId) async {
    try {
      await _dio.post('/channels/$channelId/kick', data: {'user_id': userId});
    } catch (e) {
      throw Exception('Failed to kick user: $e');
    }
  }

  @override
  Future<void> blockUser(String channelId, String userId) async {
    try {
      await _dio.post('/channels/$channelId/block', data: {'user_id': userId});
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  @override
  Future<void> unblockUser(String channelId, String userId) async {
    try {
      await _dio.post('/channels/$channelId/unblock', data: {'user_id': userId});
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }

  // Additional operations
  @override
  Future<List<UserProfile>> getUsers() async {
    try {
      final response = await _dio.get('/users');
      return (response.data['users'] as List)
          .map((json) => UserProfile.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelUsers(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId/users');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get channel users: $e');
    }
  }

  @override
  Future<void> deleteMessage(String channelId, String messageId) async {
    try {
      await _dio.delete('/channels/$channelId/messages/$messageId');
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  @override
  Future<void> requestJoinChannel(String channelId) async {
    try {
      await _dio.post('/channels/$channelId/request-join');
    } catch (e) {
      throw Exception('Failed to request join channel: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDetails(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId/details');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get channel details: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDashboardData(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId/dashboard');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get channel dashboard data: $e');
    }
  }

  @override
  Future<Map<String, bool>> checkChannelRoles(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId/roles');
      return Map<String, bool>.from(response.data);
    } catch (e) {
      throw Exception('Failed to check channel roles: $e');
    }
  }

  @override
  Future<void> performAdminAction(String channelId, String action, String userId) async {
    try {
      await _dio.post('/channels/$channelId/admin-action', data: {
        'action': action,
        'user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to perform admin action: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelInvitations(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId/invitations');
      return List<Map<String, dynamic>>.from(response.data['invitations']);
    } catch (e) {
      throw Exception('Failed to get channel invitations: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(String channelId) async {
    try {
      final response = await _dio.get('/channels/$channelId/blocked');
      return List<Map<String, dynamic>>.from(response.data['blocked_users']);
    } catch (e) {
      throw Exception('Failed to get blocked users: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserInvitations(String userId) async {
    try {
      final response = await _dio.get('/users/$userId/invitations');
      return List<Map<String, dynamic>>.from(response.data['invitations']);
    } catch (e) {
      throw Exception('Failed to get user invitations: $e');
    }
  }

  @override
  Future<List<Message>> getUserMessages(String userId,
      {int? limit, String? before}) async {
    try {
      final response = await _dio.get(
        '/users/$userId/messages',
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (before != null) 'before': before,
        },
      );
      return (response.data['messages'] as List)
          .map((json) => Message.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user messages: $e');
    }
  }

  @override
  Future<Message> sendUserMessage(String userId, String content) async {
    try {
      final response = await _dio.post('/users/$userId/messages', data: {
        'content': content,
      });
      return Message.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send user message: $e');
    }
  }

  @override
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

  @override
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

  // Invitation operations
  @override
  Future<void> sendInvitation(String channelId, String userId) async {
    try {
      await _dio.post('/channels/$channelId/invitations', data: {
        'user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to send invitation: $e');
    }
  }

  @override
  Future<void> acceptInvitation(String invitationId) async {
    try {
      await _dio.post('/invitations/$invitationId/accept');
    } catch (e) {
      throw Exception('Failed to accept invitation: $e');
    }
  }

  @override
  Future<void> declineInvitation(String invitationId) async {
    try {
      await _dio.post('/invitations/$invitationId/decline');
    } catch (e) {
      throw Exception('Failed to decline invitation: $e');
    }
  }
}
