import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class ChannelMessagesRequested extends MessageEvent {
  final int channelId;

  const ChannelMessagesRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class MessageSent extends MessageEvent {
  final int channelId;
  final String senderUsername;
  final String content;

  const MessageSent({
    required this.channelId,
    required this.senderUsername,
    required this.content,
  });

  @override
  List<Object> get props => [channelId, senderUsername, content];
}

class MessageDeleted extends MessageEvent {
  final int channelId;
  final int messageId;

  const MessageDeleted({
    required this.channelId,
    required this.messageId,
  });

  @override
  List<Object> get props => [channelId, messageId];
}

class DirectMessagesRequested extends MessageEvent {
  final String currentUsername;
  final String otherUsername;

  const DirectMessagesRequested({
    required this.currentUsername,
    required this.otherUsername,
  });

  @override
  List<Object> get props => [currentUsername, otherUsername];
}

class DirectMessageSent extends MessageEvent {
  final String senderUsername;
  final String recipientUsername;
  final String content;

  const DirectMessageSent({
    required this.senderUsername,
    required this.recipientUsername,
    required this.content,
  });

  @override
  List<Object> get props => [senderUsername, recipientUsername, content];
}
