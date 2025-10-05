import '../../domain/repositories/chat_repository.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/message.dart';
import '../../domain/models/channel.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/user_profile.dart';
import '../data_sources/remote/chat_remote_data_source.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChatRepositoryImpl({required ChatRemoteDataSource chatRemoteDataSource})
      : _chatRemoteDataSource = chatRemoteDataSource;

  @override
  Future<List<Chat>> getChats() async {
    try {
      return await _chatRemoteDataSource.getChats();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Chat> getChatByUserId(String userId) async {
    try {
      return await _chatRemoteDataSource.getChatByUserId(userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String chatId, {int? limit, String? before}) async {
    try {
      return await _chatRemoteDataSource.getChatMessages(chatId, limit: limit, before: before);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<ChatMessage> sendDirectMessage(String chatId, String content) async {
    try {
      return await _chatRemoteDataSource.sendDirectMessage(chatId, content);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> markAsRead(String chatId) async {
    try {
      await _chatRemoteDataSource.markAsRead(chatId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> markChatAsRead(String chatId) async {
    try {
      await _chatRemoteDataSource.markChatAsRead(chatId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      await _chatRemoteDataSource.deleteChat(chatId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> archiveChat(String chatId) async {
    try {
      await _chatRemoteDataSource.archiveChat(chatId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<Channel>> getChannels() async {
    try {
      return await _chatRemoteDataSource.getChannels();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Channel> getChannel(String channelId) async {
    try {
      return await _chatRemoteDataSource.getChannel(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Channel> createChannel(String name, String description, {bool isPrivate = false}) async {
    try {
      return await _chatRemoteDataSource.createChannel(name, description, isPrivate: isPrivate);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> updateChannel(String channelId, String name, String description) async {
    try {
      await _chatRemoteDataSource.updateChannel(channelId, name, description);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteChannel(String channelId) async {
    try {
      await _chatRemoteDataSource.deleteChannel(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<Message>> getChannelMessages(String channelId, {int? limit, String? before}) async {
    try {
      return await _chatRemoteDataSource.getChannelMessages(channelId, limit: limit, before: before);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Message> sendChannelMessage(String channelId, String content) async {
    try {
      return await _chatRemoteDataSource.sendChannelMessage(channelId, content);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> joinChannel(String channelId) async {
    try {
      await _chatRemoteDataSource.joinChannel(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> leaveChannel(String channelId) async {
    try {
      await _chatRemoteDataSource.leaveChannel(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<UserProfile>> getChannelMembers(String channelId) async {
    try {
      return await _chatRemoteDataSource.getChannelMembers(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> addChannelMember(String channelId, String username) async {
    try {
      await _chatRemoteDataSource.addChannelMember(channelId, username);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelStatistics(String channelId) async {
    try {
      return await _chatRemoteDataSource.getChannelStatistics(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<UserProfile>> getUsers() async {
    try {
      return await _chatRemoteDataSource.getUsers();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelUsers(String channelId) async {
    try {
      return await _chatRemoteDataSource.getChannelUsers(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteMessage(String channelId, String messageId) async {
    try {
      await _chatRemoteDataSource.deleteMessage(channelId, messageId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> requestJoinChannel(String channelId) async {
    try {
      await _chatRemoteDataSource.requestJoinChannel(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDetails(String channelId) async {
    try {
      return await _chatRemoteDataSource.getChannelDetails(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDashboardData(String channelId) async {
    try {
      return await _chatRemoteDataSource.getChannelDashboardData(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Map<String, bool>> checkChannelRoles(String channelId) async {
    try {
      return await _chatRemoteDataSource.checkChannelRoles(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> performAdminAction(String channelId, String action, String userId) async {
    try {
      await _chatRemoteDataSource.performAdminAction(channelId, action, userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelInvitations(String channelId) async {
    try {
      return await _chatRemoteDataSource.getChannelInvitations(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(String channelId) async {
    try {
      return await _chatRemoteDataSource.getChannelBlockedUsers(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserInvitations(String userId) async {
    try {
      return await _chatRemoteDataSource.getUserInvitations(userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<Message>> getUserMessages(String userId, {int? limit, String? before}) async {
    try {
      return await _chatRemoteDataSource.getUserMessages(userId, limit: limit, before: before);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Message> sendUserMessage(String userId, String content) async {
    try {
      return await _chatRemoteDataSource.sendUserMessage(userId, content);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> sendMessage({
    required String channelId,
    required String message,
    required String userId,
  }) async {
    try {
      await _chatRemoteDataSource.sendMessage(
        channelId: channelId,
        message: message,
        userId: userId,
      );
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<dynamic>> getMessages({
    required String channelId,
    int? limit,
    String? beforeId,
  }) async {
    try {
      return await _chatRemoteDataSource.getMessages(
        channelId: channelId,
        limit: limit,
        beforeId: beforeId,
      );
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  // Admin role methods
  @override
  Future<bool> isChannelAdmin(String channelId) async {
    try {
      return await _chatRemoteDataSource.isChannelAdmin(channelId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> addModerator(String channelId, String userId) async {
    try {
      await _chatRemoteDataSource.addModerator(channelId, userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> removeModerator(String channelId, String userId) async {
    try {
      await _chatRemoteDataSource.removeModerator(channelId, userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> makeAdmin(String channelId, String userId) async {
    try {
      await _chatRemoteDataSource.makeAdmin(channelId, userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> removeAdmin(String channelId, String userId) async {
    try {
      await _chatRemoteDataSource.removeAdmin(channelId, userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> kickUser(String channelId, String userId) async {
    try {
      await _chatRemoteDataSource.kickUser(channelId, userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> blockUser(String channelId, String userId) async {
    try {
      await _chatRemoteDataSource.blockUser(channelId, userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> unblockUser(String channelId, String userId) async {
    try {
      await _chatRemoteDataSource.unblockUser(channelId, userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> sendInvitation(String channelId, String userId) async {
    try {
      await _chatRemoteDataSource.sendInvitation(channelId, userId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> acceptInvitation(String invitationId) async {
    try {
      await _chatRemoteDataSource.acceptInvitation(invitationId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> declineInvitation(String invitationId) async {
    try {
      await _chatRemoteDataSource.declineInvitation(invitationId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
