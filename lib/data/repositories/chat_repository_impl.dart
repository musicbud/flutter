import '../../domain/repositories/chat_repository.dart';
import '../../models/channel.dart';
import '../../models/message.dart';
import '../data_sources/remote/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({required ChatRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    return await _remoteDataSource.login(username, password);
  }

  @override
  Future<List<Channel>> getChannelList() async {
    return await _remoteDataSource.getChannelList();
  }

  @override
  Future<Map<String, dynamic>> createChannel(
      Map<String, dynamic> channelData) async {
    return await _remoteDataSource.createChannel(channelData);
  }

  @override
  Future<Map<String, dynamic>> getChannelDetails(int channelId) async {
    return await _remoteDataSource.getChannelDetails(channelId);
  }

  @override
  Future<Map<String, dynamic>> getChannelDashboardData(int channelId) async {
    return await _remoteDataSource.getChannelDashboardData(channelId);
  }

  @override
  Future<Map<String, dynamic>> joinChannel(String channelId) async {
    return await _remoteDataSource.joinChannel(channelId);
  }

  @override
  Future<Map<String, dynamic>> requestJoinChannel(int channelId) async {
    return await _remoteDataSource.requestJoinChannel(channelId);
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    return await _remoteDataSource.getUsers();
  }

  @override
  Future<Map<String, dynamic>> getChannelUsers(int channelId) async {
    return await _remoteDataSource.getChannelUsers(channelId);
  }

  @override
  Future<Map<String, dynamic>> addChannelMember(
      int channelId, String username) async {
    return await _remoteDataSource.addChannelMember(channelId, username);
  }

  @override
  Future<Map<String, dynamic>> removeChannelMember(
      int channelId, int userId) async {
    return await _remoteDataSource.removeChannelMember(channelId, userId);
  }

  @override
  Future<bool> isUserAdmin(int channelId) async {
    return await _remoteDataSource.isUserAdmin(channelId);
  }

  @override
  Future<bool> isChannelAdmin(int channelId) async {
    return await _remoteDataSource.isChannelAdmin(channelId);
  }

  @override
  Future<bool> isChannelMember(int channelId) async {
    return await _remoteDataSource.isChannelMember(channelId);
  }

  @override
  Future<bool> isChannelModerator(int channelId) async {
    return await _remoteDataSource.isChannelModerator(channelId);
  }

  @override
  Future<Map<String, bool>> checkChannelRoles(int channelId) async {
    return await _remoteDataSource.checkChannelRoles(channelId);
  }

  @override
  Future<Map<String, dynamic>> makeAdmin(int channelId, int userId) async {
    return await _remoteDataSource.makeAdmin(channelId, userId);
  }

  @override
  Future<Map<String, dynamic>> removeAdmin(int channelId, int userId) async {
    return await _remoteDataSource.removeAdmin(channelId, userId);
  }

  @override
  Future<Map<String, dynamic>> addModerator(int channelId, int userId) async {
    return await _remoteDataSource.addModerator(channelId, userId);
  }

  @override
  Future<Map<String, dynamic>> removeModerator(
      int channelId, int userId) async {
    return await _remoteDataSource.removeModerator(channelId, userId);
  }

  @override
  Future<Map<String, dynamic>> acceptUser(int channelId, int userId) async {
    return await _remoteDataSource.acceptUser(channelId, userId);
  }

  @override
  Future<Map<String, dynamic>> kickUser(int channelId, int userId) async {
    return await _remoteDataSource.kickUser(channelId, userId);
  }

  @override
  Future<Map<String, dynamic>> blockUser(int channelId, int userId) async {
    return await _remoteDataSource.blockUser(channelId, userId);
  }

  @override
  Future<Map<String, dynamic>> unblockUser(int channelId, int userId) async {
    return await _remoteDataSource.unblockUser(channelId, userId);
  }

  @override
  Future<List<Message>> getChannelMessages(int channelId) async {
    final List<Message> messages =
        await _remoteDataSource.getChannelMessages(channelId);
    return messages;
  }

  @override
  Future<Map<String, dynamic>> getUserMessages(
      String currentUsername, String otherUsername) async {
    return await _remoteDataSource.getUserMessages(
        currentUsername, otherUsername);
  }

  @override
  Future<Map<String, dynamic>> sendMessage(
      Map<String, dynamic> messageData) async {
    return await _remoteDataSource.sendMessage(messageData);
  }

  @override
  Future<Map<String, dynamic>> sendChannelMessage(
      int channelId, String senderUsername, String content) async {
    return await _remoteDataSource.sendChannelMessage(
        channelId, senderUsername, content);
  }

  @override
  Future<Map<String, dynamic>> sendUserMessage(
      String senderUsername, String recipientUsername, String content) async {
    return await _remoteDataSource.sendUserMessage(
        senderUsername, recipientUsername, content);
  }

  @override
  Future<Map<String, dynamic>> deleteMessage(
      int channelId, int messageId) async {
    return await _remoteDataSource.deleteMessage(channelId, messageId);
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelInvitations(
      int channelId) async {
    return await _remoteDataSource.getChannelInvitations(channelId);
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelBlockedUsers(
      int channelId) async {
    return await _remoteDataSource.getChannelBlockedUsers(channelId);
  }

  @override
  Future<List<Map<String, dynamic>>> getUserInvitations(int userId) async {
    return await _remoteDataSource.getUserInvitations(userId);
  }

  @override
  Future<Map<String, dynamic>> performAdminAction(
      int channelId, String action, int userId) async {
    return await _remoteDataSource.performAdminAction(
        channelId, action, userId);
  }
}
