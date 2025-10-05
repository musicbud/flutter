import 'package:equatable/equatable.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();

  @override
  List<Object?> get props => [];
}

class ChatRoomMessagesRequested extends ChatRoomEvent {
  final String channelId;
  final int? limit;
  final String? before;

  const ChatRoomMessagesRequested({
    required this.channelId,
    this.limit,
    this.before,
  });

  @override
  List<Object?> get props => [channelId, limit, before];
}

class ChatRoomMessageSent extends ChatRoomEvent {
  final String channelId;
  final String content;

  const ChatRoomMessageSent({
    required this.channelId,
    required this.content,
  });

  @override
  List<Object?> get props => [channelId, content];
}

class ChatRoomMessageDeleted extends ChatRoomEvent {
  final String channelId;
  final String messageId;

  const ChatRoomMessageDeleted({
    required this.channelId,
    required this.messageId,
  });

  @override
  List<Object?> get props => [channelId, messageId];
}

class ChatRoomMessageEdited extends ChatRoomEvent {
  final String channelId;
  final String messageId;
  final String newContent;

  const ChatRoomMessageEdited({
    required this.channelId,
    required this.messageId,
    required this.newContent,
  });

  @override
  List<Object?> get props => [channelId, messageId, newContent];
}

class ChatRoomTypingStarted extends ChatRoomEvent {
  final String username;

  const ChatRoomTypingStarted({required this.username});

  @override
  List<Object?> get props => [username];
}

class ChatRoomTypingStopped extends ChatRoomEvent {
  final String username;

  const ChatRoomTypingStopped({required this.username});

  @override
  List<Object?> get props => [username];
}

class ChatRoomReactionAdded extends ChatRoomEvent {
  final String channelId;
  final String messageId;
  final String reaction;

  const ChatRoomReactionAdded({
    required this.channelId,
    required this.messageId,
    required this.reaction,
  });

  @override
  List<Object?> get props => [channelId, messageId, reaction];
}

class ChatRoomReactionRemoved extends ChatRoomEvent {
  final String channelId;
  final String messageId;
  final String reaction;

  const ChatRoomReactionRemoved({
    required this.channelId,
    required this.messageId,
    required this.reaction,
  });

  @override
  List<Object?> get props => [channelId, messageId, reaction];
}

class ChatRoomMembersRequested extends ChatRoomEvent {
  final String channelId;

  const ChatRoomMembersRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChatRoomDetailsRequested extends ChatRoomEvent {
  final String channelId;

  const ChatRoomDetailsRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChatRoomJoinRequested extends ChatRoomEvent {
  final String channelId;

  const ChatRoomJoinRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChatRoomLeaveRequested extends ChatRoomEvent {
  final String channelId;

  const ChatRoomLeaveRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChatRoomMuteRequested extends ChatRoomEvent {
  final String channelId;

  const ChatRoomMuteRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChatRoomUnmuteRequested extends ChatRoomEvent {
  final String channelId;

  const ChatRoomUnmuteRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}