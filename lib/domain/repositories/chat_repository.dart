import '../models/chat.dart';
import '../models/chat_message.dart';
import '../models/channel.dart';
import '../models/channel_user.dart';
import '../models/message.dart';
import '../models/user_profile.dart';

abstract class ChatRepository {
  // Direct chat operations
  Future<List<Chat>> getChats();
  Future<Chat> getChatByUserId(String userId);
  Future<List<ChatMessage>> getChatMessages(String chatId,
      {int? limit, String? before});
  Future<ChatMessage> sendMessage(String chatId, String content);
  Future<void> markAsRead(String chatId);
  Future<void> deleteChat(String chatId);
  Future<void> archiveChat(String chatId);

  // Channel operations
  Future<List<Channel>> getChannels();
  Future<Channel> getChannel(String channelId);
  Future<Channel> createChannel(String name, String description);
  Future<void> updateChannel(String channelId, String name, String description);
  Future<void> deleteChannel(String channelId);
  Future<List<Message>> getChannelMessages(String channelId,
      {int? limit, String? before});
  Future<Message> sendChannelMessage(String channelId, String content);
  Future<void> joinChannel(String channelId);
  Future<void> leaveChannel(String channelId);
  Future<List<UserProfile>> getChannelMembers(String channelId);
  Future<void> addChannelMember(String channelId, String username);
  Future<Map<String, dynamic>> getChannelStatistics(String channelId);

  // Channel admin operations
  Future<bool> isChannelAdmin(String channelId);
  Future<void> addModerator(String channelId, String userId);
  Future<void> removeModerator(String channelId, String userId);
  Future<void> makeAdmin(String channelId, String userId);
  Future<void> removeAdmin(String channelId, String userId);
  Future<void> kickUser(String channelId, String userId);
  Future<void> blockUser(String channelId, String userId);
  Future<void> unblockUser(String channelId, String userId);

  // Additional operations
  Future<List<UserProfile>> getUsers();
  Future<Map<String, dynamic>> getChannelUsers(String channelId);
  Future<void> deleteMessage(String channelId, String messageId);
  Future<void> requestJoinChannel(String channelId);
  Future<Map<String, dynamic>> getChannelDetails(String channelId);
  Future<Map<String, dynamic>> getChannelDashboardData(String channelId);
  Future<Map<String, bool>> checkChannelRoles(String channelId);
  Future<void> performAdminAction(
      String channelId, String action, String userId);
  Future<List<Map<String, dynamic>>> getChannelInvitations(String channelId);
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(String channelId);
  Future<List<Map<String, dynamic>>> getUserInvitations(String userId);
  Future<List<Message>> getUserMessages(String userId,
      {int? limit, String? before});
  Future<Message> sendUserMessage(String userId, String content);
}
