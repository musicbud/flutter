import '../../domain/repositories/chat_management_repository.dart';
import '../data_sources/remote/chat_management_remote_data_source.dart';

class ChatManagementRepositoryImpl implements ChatManagementRepository {
  final ChatManagementRemoteDataSource _remoteDataSource;

  ChatManagementRepositoryImpl({required ChatManagementRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Map<String, dynamic>> getChatHome() async {
    try {
      final response = await _remoteDataSource.getChatHome();
      return response;
    } catch (e) {
      throw Exception('Failed to get chat home: $e');
    }
  }

  @override
  Future<List<dynamic>> getChatUsers() async {
    try {
      final response = await _remoteDataSource.getChatUsers();
      return response['users'] ?? [];
    } catch (e) {
      throw Exception('Failed to get chat users: $e');
    }
  }

  @override
  Future<List<dynamic>> getChatChannels() async {
    try {
      final response = await _remoteDataSource.getChatChannels();
      return response['channels'] ?? [];
    } catch (e) {
      throw Exception('Failed to get chat channels: $e');
    }
  }

  @override
  Future<List<dynamic>> getUserChat(String username) async {
    try {
      final response = await _remoteDataSource.getUserChat(username);
      return response['messages'] ?? [];
    } catch (e) {
      throw Exception('Failed to get user chat: $e');
    }
  }

  @override
  Future<List<dynamic>> getChannelChat(String channelId) async {
    try {
      final response = await _remoteDataSource.getChannelChat(channelId);
      return response['messages'] ?? [];
    } catch (e) {
      throw Exception('Failed to get channel chat: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> sendMessage(String message, String? channelId, String? username) async {
    try {
      final response = await _remoteDataSource.sendMessage(message, channelId, username);
      return response;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createChannel(Map<String, dynamic> channelData) async {
    try {
      final response = await _remoteDataSource.createChannel(channelData);
      return response;
    } catch (e) {
      throw Exception('Failed to create channel: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDashboard(String channelId) async {
    try {
      final response = await _remoteDataSource.getChannelDashboard(channelId);
      return response;
    } catch (e) {
      throw Exception('Failed to get channel dashboard: $e');
    }
  }

  @override
  Future<void> addChannelMember(String channelId, String username) async {
    try {
      await _remoteDataSource.addChannelMember(channelId, username);
    } catch (e) {
      throw Exception('Failed to add channel member: $e');
    }
  }

  @override
  Future<void> acceptUserInvitation(String channelId, String username) async {
    try {
      await _remoteDataSource.acceptUserInvitation(channelId, username);
    } catch (e) {
      throw Exception('Failed to accept user invitation: $e');
    }
  }

  @override
  Future<void> kickUser(String channelId, String username) async {
    try {
      await _remoteDataSource.kickUser(channelId, username);
    } catch (e) {
      throw Exception('Failed to kick user: $e');
    }
  }

  @override
  Future<void> blockUser(String channelId, String username) async {
    try {
      await _remoteDataSource.blockUser(channelId, username);
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  @override
  Future<void> addModerator(String channelId, String username) async {
    try {
      await _remoteDataSource.addModerator(channelId, username);
    } catch (e) {
      throw Exception('Failed to add moderator: $e');
    }
  }

  @override
  Future<void> deleteMessage(String messageId, String channelId) async {
    try {
      await _remoteDataSource.deleteMessage(messageId, channelId);
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  @override
  Future<void> handleInvitation(String channelId, String username, bool accept) async {
    try {
      await _remoteDataSource.handleInvitation(channelId, username, accept);
    } catch (e) {
      throw Exception('Failed to handle invitation: $e');
    }
  }
}