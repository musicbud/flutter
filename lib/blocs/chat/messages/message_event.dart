import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class ChannelMessagesRequested extends MessageEvent {
  final String channelId;
  final int? limit;
  final String? before;

  const ChannelMessagesRequested(
    this.channelId, {
    this.limit,
    this.before,
  });

  @override
  List<Object?> get props => [channelId, limit, before];
}

class MessageSent extends MessageEvent {
  final String channelId;
  final String content;

  const MessageSent({
    required this.channelId,
    required this.content,
  });

  @override
  List<Object> get props => [channelId, content];
}

class MessageDeleted extends MessageEvent {
  final String channelId;
  final String messageId;

  const MessageDeleted({
    required this.channelId,
    required this.messageId,
  });

  @override
  List<Object> get props => [channelId, messageId];
}

class UserMessagesRequested extends MessageEvent {
  final String userId;
  final int? limit;
  final String? before;

  const UserMessagesRequested(
    this.userId, {
    this.limit,
    this.before,
  });

  @override
  List<Object?> get props => [userId, limit, before];
}

class UserMessageSent extends MessageEvent {
  final String userId;
  final String content;

  const UserMessageSent({
    required this.userId,
    required this.content,
  });

  @override
  List<Object> get props => [userId, content];
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
