import 'package:equatable/equatable.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();

  @override
  List<Object> get props => [];
}

class ChatRoomMessagesRequested extends ChatRoomEvent {
  final int channelId;

  const ChatRoomMessagesRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatRoomMessageSent extends ChatRoomEvent {
  final int channelId;
  final String senderUsername;
  final String content;

  const ChatRoomMessageSent({
    required this.channelId,
    required this.senderUsername,
    required this.content,
  });

  @override
  List<Object> get props => [channelId, senderUsername, content];
}

class ChatRoomMessageDeleted extends ChatRoomEvent {
  final int channelId;
  final int messageId;

  const ChatRoomMessageDeleted({
    required this.channelId,
    required this.messageId,
  });

  @override
  List<Object> get props => [channelId, messageId];
}
