import '../models/chat.dart';
import '../models/chat_message.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats();
  Future<Chat> getChatByUserId(String userId);
  Future<List<ChatMessage>> getChatMessages(String chatId, {int? limit, String? before});
  Future<ChatMessage> sendMessage(String chatId, String content);
  Future<void> markAsRead(String chatId);
  Future<void> deleteChat(String chatId);
  Future<void> archiveChat(String chatId);
  Future<void> joinChannel(String channelId);
  Future<void> leaveChannel(String channelId);
}
