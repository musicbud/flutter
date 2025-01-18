import '../../models/channel.dart';
import '../../models/message.dart';

abstract class ChatRepository {
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
