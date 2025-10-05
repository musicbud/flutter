import '../../network/dio_client.dart';
import '../../../config/api_config.dart';

abstract class ChatManagementRemoteDataSource {
  Future<Map<String, dynamic>> getChatHome();
  Future<Map<String, dynamic>> getChatUsers();
  Future<Map<String, dynamic>> getChatChannels();
  Future<Map<String, dynamic>> getUserChat(String username);
  Future<Map<String, dynamic>> getChannelChat(String channelId);
  Future<Map<String, dynamic>> sendMessage(String message, String? channelId, String? username);
  Future<Map<String, dynamic>> createChannel(Map<String, dynamic> channelData);
  Future<Map<String, dynamic>> getChannelDashboard(String channelId);
  Future<void> addChannelMember(String channelId, String username);
  Future<void> acceptUserInvitation(String channelId, String username);
  Future<void> kickUser(String channelId, String username);
  Future<void> blockUser(String channelId, String username);
  Future<void> addModerator(String channelId, String username);
  Future<void> deleteMessage(String messageId, String channelId);
  Future<void> handleInvitation(String channelId, String username, bool accept);
}

class ChatManagementRemoteDataSourceImpl implements ChatManagementRemoteDataSource {
  final DioClient _dioClient;

  ChatManagementRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> getChatHome() async {
    try {
      final response = await _dioClient.get(ApiConfig.chatHome);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get chat home: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChatUsers() async {
    try {
      final response = await _dioClient.get(ApiConfig.chatUsers);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get chat users: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChatChannels() async {
    try {
      final response = await _dioClient.get(ApiConfig.chatChannels);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get chat channels: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserChat(String username) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatUserChatByUsername}$username/');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get user chat: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelChat(String channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatChannelChat}$channelId/');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get channel chat: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> sendMessage(String message, String? channelId, String? username) async {
    try {
      final Map<String, dynamic> data = {'message': message};
      if (channelId != null) {
        data['channel_id'] = channelId;
      }
      if (username != null) {
        data['username'] = username;
      }

      final response = await _dioClient.post(ApiConfig.chatSendMessage, data: data);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createChannel(Map<String, dynamic> channelData) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatCreateChannel, data: channelData);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to create channel: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelDashboard(String channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatChannelDashboard}$channelId/');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get channel dashboard: $e');
    }
  }

  @override
  Future<void> addChannelMember(String channelId, String username) async {
    try {
      await _dioClient.post('${ApiConfig.chatAddChannelMember}$channelId/', data: {
        'username': username,
      });
    } catch (e) {
      throw Exception('Failed to add channel member: $e');
    }
  }

  @override
  Future<void> acceptUserInvitation(String channelId, String username) async {
    try {
      await _dioClient.post('${ApiConfig.chatAcceptUserInvitation}$channelId/', data: {
        'username': username,
        'action': 'accept',
      });
    } catch (e) {
      throw Exception('Failed to accept user invitation: $e');
    }
  }

  @override
  Future<void> kickUser(String channelId, String username) async {
    try {
      await _dioClient.post('${ApiConfig.chatKickUser}$channelId/', data: {
        'username': username,
        'action': 'kick',
      });
    } catch (e) {
      throw Exception('Failed to kick user: $e');
    }
  }

  @override
  Future<void> blockUser(String channelId, String username) async {
    try {
      await _dioClient.post('${ApiConfig.chatBlockUser}$channelId/', data: {
        'username': username,
        'action': 'block',
      });
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  @override
  Future<void> addModerator(String channelId, String username) async {
    try {
      await _dioClient.post('${ApiConfig.chatAddModerator}$channelId/', data: {
        'username': username,
        'action': 'add_moderator',
      });
    } catch (e) {
      throw Exception('Failed to add moderator: $e');
    }
  }

  @override
  Future<void> deleteMessage(String messageId, String channelId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}$channelId/', data: {
        'message_id': messageId,
      });
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  @override
  Future<void> handleInvitation(String channelId, String username, bool accept) async {
    try {
      await _dioClient.post('${ApiConfig.chatHandleInvitation}$channelId/', data: {
        'username': username,
        'action': accept ? 'accept' : 'reject',
      });
    } catch (e) {
      throw Exception('Failed to handle invitation: $e');
    }
  }
}