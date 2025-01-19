import '../../domain/models/chat.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/chat_statistics.dart';
import '../../domain/repositories/chat_repository.dart';
import '../network/dio_client.dart';

class ChatRepositoryImpl implements ChatRepository {
  final DioClient _dioClient;

  ChatRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<Chat>> getChats() async {
    final response = await _dioClient.get('/chats');
    return (response.data as List).map((json) => Chat.fromJson(json)).toList();
  }

  @override
  Future<Chat> getChatByUserId(String userId) async {
    final response = await _dioClient.get('/chats/user/$userId');
    return Chat.fromJson(response.data);
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String chatId,
      {int? limit, String? before}) async {
    final response = await _dioClient.get(
      '/chats/$chatId/messages',
      queryParameters: {
        if (limit != null) 'limit': limit,
        if (before != null) 'before': before,
      },
    );
    return (response.data as List)
        .map((json) => ChatMessage.fromJson(json))
        .toList();
  }

  @override
  Future<ChatMessage> sendMessage(String chatId, String content) async {
    final response = await _dioClient.post('/chats/$chatId/messages', data: {
      'content': content,
    });
    return ChatMessage.fromJson(response.data);
  }

  @override
  Future<void> markAsRead(String chatId) async {
    await _dioClient.post('/chats/$chatId/read');
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _dioClient.delete('/chats/$chatId');
  }

  @override
  Future<void> archiveChat(String chatId) async {
    await _dioClient.post('/chats/$chatId/archive');
  }

  @override
  Future<ChatStatistics> getChannelStatistics(String channelId) async {
    final response = await _dioClient.get('/channels/$channelId/statistics');
    return ChatStatistics.fromJson(response.data);
  }

  @override
  Future<void> joinChannel(String channelId) async {
    await _dioClient.post('/channels/$channelId/join');
  }

  @override
  Future<void> leaveChannel(String channelId) async {
    await _dioClient.post('/channels/$channelId/leave');
  }
}
