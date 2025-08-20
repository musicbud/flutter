import '../../domain/repositories/chat_repository.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/message.dart';
import '../../domain/models/channel.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/user_profile.dart';
import 'package:dio/dio.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Dio _dio;
  final String baseUrl;

  ChatRepositoryImpl({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  @override
  Future<List<Chat>> getChats() async {
    final response = await _dio.get('/chats');
    return (response.data as List).map((json) => Chat.fromJson(json)).toList();
  }

  @override
  Future<Chat> getChatByUserId(String userId) async {
    final response = await _dio.get('/chats/user/$userId');
    return Chat.fromJson(response.data);
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String chatId,
      {int? limit, String? before}) async {
    final response =
        await _dio.get('/chats/$chatId/messages', queryParameters: {
      if (limit != null) 'limit': limit,
      if (before != null) 'before': before,
    });
    return (response.data as List)
        .map((json) => ChatMessage.fromJson(json))
        .toList();
  }

  @override
  Future<ChatMessage> sendDirectMessage(String chatId, String content) async {
    final response = await _dio.post('/chats/$chatId/messages', data: {
      'content': content,
    });
    return ChatMessage.fromJson(response.data);
  }

  @override
  Future<void> markAsRead(String chatId) async {
    await _dio.post('/chats/$chatId/read');
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _dio.delete('/chats/$chatId');
  }

  @override
  Future<void> archiveChat(String chatId) async {
    await _dio.post('/chats/$chatId/archive');
  }

  @override
  Future<List<Channel>> getChannels() async {
    final response = await _dio.get('/channels');
    return (response.data as List)
        .map((json) => Channel.fromJson(json))
        .toList();
  }

  @override
  Future<Channel> getChannel(String channelId) async {
    final response = await _dio.get('/channels/$channelId');
    return Channel.fromJson(response.data);
  }

  @override
  Future<Channel> createChannel(String name, String description,
      {bool isPrivate = false}) async {
    final response = await _dio.post('/channels', data: {
      'name': name,
      'description': description,
      'type': isPrivate ? 'private' : 'public',
    });
    return Channel.fromJson(response.data);
  }

  @override
  Future<void> updateChannel(
      String channelId, String name, String description) async {
    await _dio.put('/channels/$channelId', data: {
      'name': name,
      'description': description,
    });
  }

  @override
  Future<void> deleteChannel(String channelId) async {
    await _dio.delete('/channels/$channelId');
  }

  @override
  Future<List<Message>> getChannelMessages(String channelId,
      {int? limit, String? before}) async {
    final response =
        await _dio.get('/channels/$channelId/messages', queryParameters: {
      if (limit != null) 'limit': limit,
      if (before != null) 'before': before,
    });
    return (response.data as List)
        .map((json) => Message.fromJson(json))
        .toList();
  }

  @override
  Future<Message> sendChannelMessage(String channelId, String content) async {
    final response = await _dio.post('/channels/$channelId/messages', data: {
      'content': content,
    });
    return Message.fromJson(response.data);
  }

  @override
  Future<void> joinChannel(String channelId) async {
    await _dio.post('/channels/$channelId/join');
  }

  @override
  Future<void> leaveChannel(String channelId) async {
    await _dio.post('/channels/$channelId/leave');
  }

  @override
  Future<List<UserProfile>> getChannelMembers(String channelId) async {
    final response = await _dio.get('/channels/$channelId/members');
    return (response.data as List)
        .map((json) => UserProfile.fromJson(json))
        .toList();
  }

  @override
  Future<void> addChannelMember(String channelId, String username) async {
    await _dio.post('/channels/$channelId/members', data: {
      'username': username,
    });
  }

  @override
  Future<Map<String, dynamic>> getChannelStatistics(String channelId) async {
    final response = await _dio.get('/channels/$channelId/statistics');
    return response.data;
  }

  @override
  Future<bool> isChannelAdmin(String channelId) async {
    final response = await _dio.get('/channels/$channelId/admin');
    return response.data['isAdmin'] as bool;
  }

  @override
  Future<void> addModerator(String channelId, String userId) async {
    await _dio.post('/channels/$channelId/moderators', data: {
      'userId': userId,
    });
  }

  @override
  Future<void> removeModerator(String channelId, String userId) async {
    await _dio.delete('/channels/$channelId/moderators/$userId');
  }

  @override
  Future<void> makeAdmin(String channelId, String userId) async {
    await _dio.post('/channels/$channelId/admins', data: {
      'userId': userId,
    });
  }

  @override
  Future<void> removeAdmin(String channelId, String userId) async {
    await _dio.delete('/channels/$channelId/admins/$userId');
  }

  @override
  Future<void> kickUser(String channelId, String userId) async {
    await _dio.post('/channels/$channelId/kick', data: {
      'userId': userId,
    });
  }

  @override
  Future<void> blockUser(String channelId, String userId) async {
    await _dio.post('/channels/$channelId/block', data: {
      'userId': userId,
    });
  }

  @override
  Future<void> unblockUser(String channelId, String userId) async {
    await _dio.post('/channels/$channelId/unblock', data: {
      'userId': userId,
    });
  }

  @override
  Future<List<UserProfile>> getUsers() async {
    final response = await _dio.get('/users');
    return (response.data as List)
        .map((json) => UserProfile.fromJson(json))
        .toList();
  }

  @override
  Future<List<Message>> getUserMessages(String userId,
      {int? limit, String? before}) async {
    final response =
        await _dio.get('/users/$userId/messages', queryParameters: {
      if (limit != null) 'limit': limit,
      if (before != null) 'before': before,
    });
    return (response.data as List)
        .map((json) => Message.fromJson(json))
        .toList();
  }

  @override
  Future<Message> sendUserMessage(String userId, String content) async {
    final response = await _dio.post('/users/$userId/messages', data: {
      'content': content,
    });
    return Message.fromJson(response.data);
  }

  @override
  Future<Map<String, dynamic>> getChannelUsers(String channelId) async {
    final response = await _dio.get('/channels/$channelId/users');
    return response.data;
  }

  @override
  Future<void> deleteMessage(String channelId, String messageId) async {
    await _dio.delete('/channels/$channelId/messages/$messageId');
  }

  @override
  Future<void> requestJoinChannel(String channelId) async {
    await _dio.post('/channels/$channelId/join/request');
  }

  @override
  Future<Map<String, dynamic>> getChannelDetails(String channelId) async {
    final response = await _dio.get('/channels/$channelId');
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getChannelDashboardData(String channelId) async {
    final response = await _dio.get('/channels/$channelId/dashboard');
    return response.data;
  }

  @override
  Future<Map<String, bool>> checkChannelRoles(String channelId) async {
    final response = await _dio.get('/channels/$channelId/roles');
    return Map<String, bool>.from(response.data);
  }

  @override
  Future<void> performAdminAction(
    String channelId,
    String action,
    String userId,
  ) async {
    await _dio.post('/channels/$channelId/admin/$action', data: {
      'user_id': userId,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelInvitations(
      String channelId) async {
    final response = await _dio.get('/channels/$channelId/invitations');
    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(
      String channelId) async {
    final response = await _dio.get('/channels/$channelId/blocked');
    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Future<List<Map<String, dynamic>>> getUserInvitations(String userId) async {
    final response = await _dio.get('/users/$userId/invitations');
    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Future<void> markChatAsRead(String chatId) async {
    await _dio.post('/chats/$chatId/read');
  }

  @override
  Future<void> sendMessage({
    required String channelId,
    required String message,
    required String userId,
  }) async {
    await _dio.post('/channels/$channelId/messages', data: {
      'content': message,
      'userId': userId,
    });
  }

  @override
  Future<List<dynamic>> getMessages({
    required String channelId,
    int? limit,
    String? beforeId,
  }) async {
    final response =
        await _dio.get('/channels/$channelId/messages', queryParameters: {
      if (limit != null) 'limit': limit,
      if (beforeId != null) 'beforeId': beforeId,
    });
    return response.data as List<dynamic>;
  }
}
