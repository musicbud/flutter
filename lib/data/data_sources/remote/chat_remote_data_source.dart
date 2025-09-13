import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../domain/models/chat.dart';
import '../../../domain/models/chat_message.dart';
import '../../../domain/models/message.dart';
import '../../../domain/models/channel.dart';
import '../../../domain/models/user_profile.dart';
import '../../../config/api_config.dart';

abstract class ChatRemoteDataSource {
  // Direct chat operations
  Future<List<Chat>> getChats();
  Future<Chat> getChatByUserId(String userId);
  Future<List<ChatMessage>> getChatMessages(String chatId, {int? limit, String? before});
  Future<ChatMessage> sendDirectMessage(String chatId, String content);
  Future<void> markAsRead(String chatId);
  Future<void> markChatAsRead(String chatId);
  Future<void> deleteChat(String chatId);
  Future<void> archiveChat(String chatId);

  // Channel operations
  Future<List<Channel>> getChannels();
  Future<Channel> getChannel(String channelId);
  Future<Channel> createChannel(String name, String description, {bool isPrivate = false});
  Future<void> updateChannel(String channelId, String name, String description);
  Future<void> deleteChannel(String channelId);
  Future<List<Message>> getChannelMessages(String channelId, {int? limit, String? before});
  Future<Message> sendChannelMessage(String channelId, String content);
  Future<void> joinChannel(String channelId);
  Future<void> leaveChannel(String channelId);
  Future<List<UserProfile>> getChannelMembers(String channelId);
  Future<void> addChannelMember(String channelId, String username);
  Future<Map<String, dynamic>> getChannelStatistics(String channelId);

  // Additional operations
  Future<List<UserProfile>> getUsers();
  Future<Map<String, dynamic>> getChannelUsers(String channelId);
  Future<void> deleteMessage(String channelId, String messageId);
  Future<void> requestJoinChannel(String channelId);
  Future<Map<String, dynamic>> getChannelDetails(String channelId);
  Future<Map<String, dynamic>> getChannelDashboardData(String channelId);
  Future<Map<String, bool>> checkChannelRoles(String channelId);
  Future<void> performAdminAction(String channelId, String action, String userId);
  Future<List<Map<String, dynamic>>> getChannelInvitations(String channelId);
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(String channelId);
  Future<List<Map<String, dynamic>>> getUserInvitations(String userId);
  Future<List<Message>> getUserMessages(String userId, {int? limit, String? before});
  Future<Message> sendUserMessage(String userId, String content);

  // Additional methods for compatibility
  Future<void> sendMessage({
    required String channelId,
    required String message,
    required String userId,
  });

  Future<List<dynamic>> getMessages({
    required String channelId,
    int? limit,
    String? beforeId,
  });

  // Admin role methods
  Future<bool> isChannelAdmin(String channelId);
  Future<void> addModerator(String channelId, String userId);
  Future<void> removeModerator(String channelId, String userId);
  Future<void> makeAdmin(String channelId, String userId);
  Future<void> removeAdmin(String channelId, String userId);
  Future<void> kickUser(String channelId, String userId);
  Future<void> blockUser(String channelId, String userId);
  Future<void> unblockUser(String channelId, String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient _dioClient;

  ChatRemoteDataSourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<Chat>> getChats() async {
    try {
      // Using chat home endpoint to get chats
      final response = await _dioClient.get(ApiConfig.chatHome);
      return (response.data as List).map((json) => Chat.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get chats');
    }
  }

  @override
  Future<Chat> getChatByUserId(String userId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatUserChat}$userId/');
      return Chat.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get chat by user ID');
    }
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String chatId, {int? limit, String? before}) async {
    try {
      // Using user chat endpoint for messages
      final response = await _dioClient.get('${ApiConfig.chatUserChat}$chatId/');
      return (response.data as List).map((json) => ChatMessage.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get chat messages');
    }
  }

  @override
  Future<ChatMessage> sendDirectMessage(String chatId, String content) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatSendMessage, data: {
        'chatId': chatId,
        'content': content,
      });
      return ChatMessage.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to send direct message');
    }
  }

  @override
  Future<void> markAsRead(String chatId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      // We'll implement it through the chat system
      await _dioClient.post(ApiConfig.chatSendMessage, data: {
        'chatId': chatId,
        'action': 'mark_read',
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to mark chat as read');
    }
  }

  @override
  Future<void> markChatAsRead(String chatId) async {
    await markAsRead(chatId);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Delete chat not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to delete chat');
    }
  }

  @override
  Future<void> archiveChat(String chatId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Archive chat not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to archive chat');
    }
  }

  @override
  Future<List<Channel>> getChannels() async {
    try {
      final response = await _dioClient.get(ApiConfig.chatChannels);
      return (response.data as List).map((json) => Channel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        throw ServerException(message: 'Server error: Chat service is temporarily unavailable. Please try again later.');
      }
      throw ServerException(message: e.message ?? 'Failed to get channels');
    }
  }

  @override
  Future<Channel> getChannel(String channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatChannelChat}$channelId/');
      return Channel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel');
    }
  }

  @override
  Future<Channel> createChannel(String name, String description, {bool isPrivate = false}) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatCreateChannel, data: {
        'name': name,
        'description': description,
        'type': isPrivate ? 'private' : 'public',
      });
      return Channel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to create channel');
    }
  }

  @override
  Future<void> updateChannel(String channelId, String name, String description) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Update channel not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to update channel');
    }
  }

  @override
  Future<void> deleteChannel(String channelId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Delete channel not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to delete channel');
    }
  }

  @override
  Future<List<Message>> getChannelMessages(String channelId, {int? limit, String? before}) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatChannelChat}$channelId/');
      return (response.data as List).map((json) => Message.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel messages');
    }
  }

  @override
  Future<Message> sendChannelMessage(String channelId, String content) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatSendMessage, data: {
        'channelId': channelId,
        'content': content,
      });
      return Message.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to send channel message');
    }
  }

  @override
  Future<void> joinChannel(String channelId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Join channel not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to join channel');
    }
  }

  @override
  Future<void> leaveChannel(String channelId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Leave channel not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to leave channel');
    }
  }

  @override
  Future<List<UserProfile>> getChannelMembers(String channelId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Get channel members not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel members');
    }
  }

  @override
  Future<void> addChannelMember(String channelId, String username) async {
    try {
      await _dioClient.post(ApiConfig.chatAddChannelMember, data: {
        'channelId': channelId,
        'username': username,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to add channel member');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelStatistics(String channelId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Get channel statistics not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel statistics');
    }
  }

  @override
  Future<List<UserProfile>> getUsers() async {
    try {
      final response = await _dioClient.get(ApiConfig.chatUsers);
      return (response.data as List).map((json) => UserProfile.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        throw ServerException(message: 'Server error: User service is temporarily unavailable. Please try again later.');
      }
      throw ServerException(message: e.message ?? 'Failed to get users');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelUsers(String channelId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Get channel users not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel users');
    }
  }

  @override
  Future<void> deleteMessage(String channelId, String messageId) async {
    try {
      await _dioClient.post(ApiConfig.chatDeleteMessage, data: {
        'messageId': messageId,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to delete message');
    }
  }

  @override
  Future<void> requestJoinChannel(String channelId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Request join channel not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to request join channel');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDetails(String channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatChannelDashboard}$channelId/dashboard/');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel details');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDashboardData(String channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatChannelDashboard}$channelId/dashboard/');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel dashboard data');
    }
  }

  @override
  Future<Map<String, bool>> checkChannelRoles(String channelId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Check channel roles not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to check channel roles');
    }
  }

  @override
  Future<void> performAdminAction(String channelId, String action, String userId) async {
    try {
      String endpoint;
      switch (action) {
        case 'add_moderator':
          endpoint = '${ApiConfig.chatAddModerator}$channelId/';
          break;
        case 'kick_user':
          endpoint = '${ApiConfig.chatKickUser}$channelId/$userId/';
          break;
        case 'block_user':
          endpoint = '${ApiConfig.chatBlockUser}$channelId/$userId/';
          break;
        default:
          throw ServerException(message: 'Unsupported admin action: $action');
      }

      await _dioClient.post(endpoint, data: {});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to perform admin action');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelInvitations(String channelId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Get channel invitations not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel invitations');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(String channelId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Get channel blocked users not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel blocked users');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserInvitations(String userId) async {
    try {
      // This functionality is not directly supported by the API endpoints
      throw ServerException(message: 'Get user invitations not supported by API');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get user invitations');
    }
  }

  @override
  Future<List<Message>> getUserMessages(String userId, {int? limit, String? before}) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatUserChatByUsername}$userId/');
      return (response.data as List).map((json) => Message.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get user messages');
    }
  }

  @override
  Future<Message> sendUserMessage(String userId, String content) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatSendMessage, data: {
        'userId': userId,
        'content': content,
      });
      return Message.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to send user message');
    }
  }

  // Additional methods for compatibility
  @override
  Future<void> sendMessage({
    required String channelId,
    required String message,
    required String userId,
  }) async {
    await sendChannelMessage(channelId, message);
  }

  @override
  Future<List<dynamic>> getMessages({
    required String channelId,
    int? limit,
    String? beforeId,
  }) async {
    final messages = await getChannelMessages(channelId, limit: limit, before: beforeId);
    return messages;
  }

  // Admin role methods
  @override
  Future<bool> isChannelAdmin(String channelId) async {
    try {
      final roles = await checkChannelRoles(channelId);
      return roles['isAdmin'] ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> addModerator(String channelId, String userId) async {
    await performAdminAction(channelId, 'add_moderator', userId);
  }

  @override
  Future<void> removeModerator(String channelId, String userId) async {
    // This functionality is not directly supported by the API endpoints
    throw ServerException(message: 'Remove moderator not supported by API');
  }

  @override
  Future<void> makeAdmin(String channelId, String userId) async {
    // This functionality is not directly supported by the API endpoints
    throw ServerException(message: 'Make admin not supported by API');
  }

  @override
  Future<void> removeAdmin(String channelId, String userId) async {
    // This functionality is not directly supported by the API endpoints
    throw ServerException(message: 'Remove admin not supported by API');
  }

  @override
  Future<void> kickUser(String channelId, String userId) async {
    await performAdminAction(channelId, 'kick_user', userId);
  }

  @override
  Future<void> blockUser(String channelId, String userId) async {
    await performAdminAction(channelId, 'block_user', userId);
  }

  @override
  Future<void> unblockUser(String channelId, String userId) async {
    // This functionality is not directly supported by the API endpoints
    throw ServerException(message: 'Unblock user not supported by API');
  }
}
