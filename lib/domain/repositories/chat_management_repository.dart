abstract class ChatManagementRepository {
  /// Get chat home data
  Future<Map<String, dynamic>> getChatHome();

  /// Get chat users
  Future<List<dynamic>> getChatUsers();

  /// Get chat channels
  Future<List<dynamic>> getChatChannels();

  /// Get user chat by username
  Future<List<dynamic>> getUserChat(String username);

  /// Get channel chat by channel ID
  Future<List<dynamic>> getChannelChat(String channelId);

  /// Send a message (to user or channel)
  Future<Map<String, dynamic>> sendMessage(String message, String? channelId, String? username);

  /// Create a new channel
  Future<Map<String, dynamic>> createChannel(Map<String, dynamic> channelData);

  /// Get channel dashboard
  Future<Map<String, dynamic>> getChannelDashboard(String channelId);

  /// Add member to channel
  Future<void> addChannelMember(String channelId, String username);

  /// Accept user invitation to channel
  Future<void> acceptUserInvitation(String channelId, String username);

  /// Kick user from channel
  Future<void> kickUser(String channelId, String username);

  /// Block user in channel
  Future<void> blockUser(String channelId, String username);

  /// Add moderator to channel
  Future<void> addModerator(String channelId, String username);

  /// Delete message from channel
  Future<void> deleteMessage(String messageId, String channelId);

  /// Handle invitation (accept/reject)
  Future<void> handleInvitation(String channelId, String username, bool accept);
}