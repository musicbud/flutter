import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../../config/api_config.dart';
import '../../../domain/models/chat.dart';
import '../../../domain/models/message.dart';
import '../../../domain/models/channel.dart';
import '../../../domain/models/chat_message.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/models/channel_user.dart';
import '../../../domain/models/channel_details.dart';
import '../../../domain/models/channel_dashboard.dart';
import '../../../domain/models/channel_invitation.dart';
import '../../../domain/models/channel_statistics.dart';
import '../../network/dio_client.dart';

abstract class ComprehensiveChatRemoteDataSource {
  // Authentication endpoints
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> register(String username, String email, String password);
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<void> logout();

  // Chat endpoints
  Future<List<Channel>> getChannels();
  Future<Channel> createChannel(Map<String, dynamic> channelData);
  Future<Channel> getChannelById(int channelId);
  Future<List<ChatMessage>> getChannelMessages(int channelId);
  Future<Message> sendChannelMessage(int channelId, String content);
  Future<Message> sendUserMessage(String recipientUsername, String content);
  Future<void> deleteMessage(int channelId, int messageId);
  Future<List<ChannelUser>> getChannelUsers(int channelId);
  Future<void> joinChannel(int channelId);
  Future<void> leaveChannel(int channelId);
  Future<void> requestJoinChannel(int channelId);

  // Admin endpoints
  Future<bool> isChannelAdmin(int channelId);
  Future<void> makeAdmin(int channelId, int userId);
  Future<void> removeAdmin(int channelId, int userId);
  Future<void> addModerator(int channelId, int userId);
  Future<void> removeModerator(int channelId, int userId);
  Future<void> kickUser(int channelId, int userId);
  Future<void> blockUser(int channelId, int userId);
  Future<void> unblockUser(int channelId, int userId);
  Future<List<ChannelUser>> getBlockedUsers(int channelId);

  // Channel management endpoints
  Future<ChannelDetails> getChannelDetails(int channelId);
  Future<ChannelDashboard> getChannelDashboard(int channelId);
  Future<ChannelStatistics> getChannelStatistics(int channelId);
  Future<void> updateChannelSettings(int channelId, Map<String, dynamic> settings);
  Future<void> deleteChannel(int channelId);

  // User management endpoints
  Future<List<UserProfile>> getUsers();
  Future<UserProfile> getUserProfile(int userId);
  Future<void> updateUserProfile(int userId, Map<String, dynamic> profileData);
  Future<void> banUser(int userId);
  Future<void> unbanUser(int userId);
  Future<List<UserProfile>> getBannedUsers();

  // Service connection endpoints
  Future<Map<String, dynamic>> connectSpotify();
  Future<Map<String, dynamic>> disconnectSpotify();
  Future<Map<String, dynamic>> connectLastfm();
  Future<Map<String, dynamic>> disconnectLastfm();
  Future<Map<String, dynamic>> connectYtmusic();
  Future<Map<String, dynamic>> disconnectYtmusic();
  Future<Map<String, dynamic>> connectMal();
  Future<Map<String, dynamic>> disconnectMal();

  // Invitation endpoints
  Future<List<ChannelInvitation>> getChannelInvitations(int channelId);
  Future<List<ChannelInvitation>> getUserInvitations(int userId);
  Future<void> sendInvitation(int channelId, int userId);
  Future<void> acceptInvitation(int invitationId);
  Future<void> declineInvitation(int invitationId);
}

class ComprehensiveChatRemoteDataSourceImpl implements ComprehensiveChatRemoteDataSource {
  final DioClient _dioClient;

  ComprehensiveChatRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  // Authentication endpoints
  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dioClient.post(ApiConfig.login, data: {
        'username': username,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to login');
    }
  }

  @override
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await _dioClient.post(ApiConfig.register, data: {
        'username': username,
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to register');
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.post(ApiConfig.refreshToken, data: {
        'refresh': refreshToken,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to refresh token');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post(ApiConfig.logout);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to logout');
    }
  }

  // Chat endpoints
  @override
  Future<List<Channel>> getChannels() async {
    try {
      final response = await _dioClient.get(ApiConfig.chatGetChannels);
      return (response.data as List)
          .map((channel) => Channel.fromJson(channel))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channels');
    }
  }

  @override
  Future<Channel> createChannel(Map<String, dynamic> channelData) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatCreateChannel, data: channelData);
      return Channel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to create channel');
    }
  }

  @override
  Future<Channel> getChannelById(int channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatGetChannels}$channelId/');
      return Channel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel');
    }
  }

  @override
  Future<List<ChatMessage>> getChannelMessages(int channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatGetChannelMessages}$channelId/');
      return (response.data as List)
          .map((message) => ChatMessage.fromJson(message))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel messages');
    }
  }

  @override
  Future<Message> sendChannelMessage(int channelId, String content) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatSendChannelMessage, data: {
        'channel_id': channelId,
        'content': content,
      });
      return Message.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to send channel message');
    }
  }

  @override
  Future<Message> sendUserMessage(String recipientUsername, String content) async {
    try {
      final response = await _dioClient.post(ApiConfig.chatSendUserMessage, data: {
        'recipient_username': recipientUsername,
        'content': content,
      });
      return Message.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to send user message');
    }
  }

  @override
  Future<void> deleteMessage(int channelId, int messageId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/$channelId/delete_message/$messageId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to delete message');
    }
  }

  @override
  Future<List<ChannelUser>> getChannelUsers(int channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatGetChannelUsers}$channelId/');
      return (response.data as List)
          .map((user) => ChannelUser.fromJson(user))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel users');
    }
  }

  @override
  Future<void> joinChannel(int channelId) async {
    try {
      await _dioClient.post('${ApiConfig.chatJoinChannel}$channelId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to join channel');
    }
  }

  @override
  Future<void> leaveChannel(int channelId) async {
    try {
      await _dioClient.post('${ApiConfig.chatLeaveChannel}$channelId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to leave channel');
    }
  }

  @override
  Future<void> requestJoinChannel(int channelId) async {
    try {
      await _dioClient.post('${ApiConfig.chatRequestJoin}$channelId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to request join channel');
    }
  }

  // Admin endpoints
  @override
  Future<bool> isChannelAdmin(int channelId) async {
    try {
      final response = await _dioClient.post('${ApiConfig.chatDeleteMessage}/$channelId/is_admin/');
      return response.data['is_admin'] ?? false;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to check admin status');
    }
  }

  @override
  Future<void> makeAdmin(int channelId, int userId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/$channelId/make_admin/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to make user admin');
    }
  }

  @override
  Future<void> removeAdmin(int channelId, int userId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/$channelId/remove_admin/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove admin');
    }
  }

  @override
  Future<void> addModerator(int channelId, int userId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/$channelId/add_moderator/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to add moderator');
    }
  }

  @override
  Future<void> removeModerator(int channelId, int userId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/$channelId/remove_moderator/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to remove moderator');
    }
  }

  @override
  Future<void> kickUser(int channelId, int userId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/$channelId/kick_user/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to kick user');
    }
  }

  @override
  Future<void> blockUser(int channelId, int userId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/$channelId/block_user/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to block user');
    }
  }

  @override
  Future<void> unblockUser(int channelId, int userId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/$channelId/unblock_user/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unblock user');
    }
  }

  @override
  Future<List<ChannelUser>> getBlockedUsers(int channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatDeleteMessage}/$channelId/blocked_users/');
      return (response.data as List)
          .map((user) => ChannelUser.fromJson(user))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get blocked users');
    }
  }

  // Channel management endpoints
  @override
  Future<ChannelDetails> getChannelDetails(int channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.channelDetails}$channelId/');
      return ChannelDetails.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel details');
    }
  }

  @override
  Future<ChannelDashboard> getChannelDashboard(int channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.channelDashboard}$channelId/');
      return ChannelDashboard.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel dashboard');
    }
  }

  @override
  Future<ChannelStatistics> getChannelStatistics(int channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.channelDashboard}$channelId/statistics/');
      return ChannelStatistics.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel statistics');
    }
  }

  @override
  Future<void> updateChannelSettings(int channelId, Map<String, dynamic> settings) async {
    try {
      await _dioClient.put('${ApiConfig.channelDetails}$channelId/', data: settings);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to update channel settings');
    }
  }

  @override
  Future<void> deleteChannel(int channelId) async {
    try {
      await _dioClient.delete('${ApiConfig.chatDeleteMessage}/$channelId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to delete channel');
    }
  }

  // User management endpoints
  @override
  Future<List<UserProfile>> getUsers() async {
    try {
      final response = await _dioClient.get(ApiConfig.users);
      return (response.data as List)
          .map((user) => UserProfile.fromJson(user))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get users');
    }
  }

  @override
  Future<UserProfile> getUserProfile(int userId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.userProfile}$userId/');
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get user profile');
    }
  }

  @override
  Future<void> updateUserProfile(int userId, Map<String, dynamic> profileData) async {
    try {
      await _dioClient.put('${ApiConfig.userProfile}$userId/', data: profileData);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to update user profile');
    }
  }

  @override
  Future<void> banUser(int userId) async {
    try {
      await _dioClient.post('${ApiConfig.users}$userId/ban/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to ban user');
    }
  }

  @override
  Future<void> unbanUser(int userId) async {
    try {
      await _dioClient.post('${ApiConfig.users}$userId/unban/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unban user');
    }
  }

  @override
  Future<List<UserProfile>> getBannedUsers() async {
    try {
      final response = await _dioClient.get('${ApiConfig.users}banned/');
      return (response.data as List)
          .map((user) => UserProfile.fromJson(user))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get banned users');
    }
  }

  // Service connection endpoints
  @override
  Future<Map<String, dynamic>> connectSpotify() async {
    try {
      final response = await _dioClient.post(ApiConfig.spotifyConnect);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect Spotify');
    }
  }

  @override
  Future<Map<String, dynamic>> disconnectSpotify() async {
    try {
      final response = await _dioClient.post(ApiConfig.spotifyDisconnect);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to disconnect Spotify');
    }
  }

  @override
  Future<Map<String, dynamic>> connectLastfm() async {
    try {
      final response = await _dioClient.post(ApiConfig.lastfmConnect);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect Last.fm');
    }
  }

  @override
  Future<Map<String, dynamic>> disconnectLastfm() async {
    try {
      final response = await _dioClient.post(ApiConfig.lastfmDisconnect);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to disconnect Last.fm');
    }
  }

  @override
  Future<Map<String, dynamic>> connectYtmusic() async {
    try {
      final response = await _dioClient.post(ApiConfig.ytmusicConnect);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect YouTube Music');
    }
  }

  @override
  Future<Map<String, dynamic>> disconnectYtmusic() async {
    try {
      final response = await _dioClient.post(ApiConfig.ytmusicDisconnect);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to disconnect YouTube Music');
    }
  }

  @override
  Future<Map<String, dynamic>> connectMal() async {
    try {
      final response = await _dioClient.post(ApiConfig.malConnect);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect MyAnimeList');
    }
  }

  @override
  Future<Map<String, dynamic>> disconnectMal() async {
    try {
      final response = await _dioClient.post(ApiConfig.malDisconnect);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to disconnect MyAnimeList');
    }
  }

  // Invitation endpoints
  @override
  Future<List<ChannelInvitation>> getChannelInvitations(int channelId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.chatDeleteMessage}/$channelId/invitations/');
      return (response.data as List)
          .map((invitation) => ChannelInvitation.fromJson(invitation))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get channel invitations');
    }
  }

  @override
  Future<List<ChannelInvitation>> getUserInvitations(int userId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.users}$userId/invitations/');
      return (response.data as List)
          .map((invitation) => ChannelInvitation.fromJson(invitation))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get user invitations');
    }
  }

  @override
  Future<void> sendInvitation(int channelId, int userId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/$channelId/invite/$userId/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to send invitation');
    }
  }

  @override
  Future<void> acceptInvitation(int invitationId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/invitations/$invitationId/accept/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to accept invitation');
    }
  }

  @override
  Future<void> declineInvitation(int invitationId) async {
    try {
      await _dioClient.post('${ApiConfig.chatDeleteMessage}/invitations/$invitationId/decline/');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to decline invitation');
    }
  }
}