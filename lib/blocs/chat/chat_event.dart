import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatChannelListRequested extends ChatEvent {}

class ChatUsersRequested extends ChatEvent {}

class ChatUserListRequested extends ChatEvent {}

class ChatChannelUsersRequested extends ChatEvent {
  final String channelId;

  const ChatChannelUsersRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatChannelMessagesRequested extends ChatEvent {
  final String channelId;
  final int? limit;
  final String? before;

  const ChatChannelMessagesRequested(
    this.channelId, {
    this.limit,
    this.before,
  });

  @override
  List<Object?> get props => [channelId, limit, before];
}

class ChatMessageSent extends ChatEvent {
  final String channelId;
  final String content;

  const ChatMessageSent({
    required this.channelId,
    required this.content,
  });

  @override
  List<Object> get props => [channelId, content];
}

class ChatMessageDeleted extends ChatEvent {
  final String channelId;
  final String messageId;

  const ChatMessageDeleted({
    required this.channelId,
    required this.messageId,
  });

  @override
  List<Object> get props => [channelId, messageId];
}

class ChatChannelCreated extends ChatEvent {
  final String name;
  final String description;
  final bool isPrivate;

  const ChatChannelCreated({
    required this.name,
    required this.description,
    this.isPrivate = false,
  });

  @override
  List<Object> get props => [name, description, isPrivate];
}

class ChatChannelJoined extends ChatEvent {
  final String channelId;

  const ChatChannelJoined(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatChannelJoinRequested extends ChatEvent {
  final String channelId;

  const ChatChannelJoinRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChatChannelDetailsRequested extends ChatEvent {
  final String channelId;

  const ChatChannelDetailsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatChannelDashboardRequested extends ChatEvent {
  final String channelId;

  const ChatChannelDashboardRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatChannelRolesChecked extends ChatEvent {
  final String channelId;

  const ChatChannelRolesChecked(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatAdminActionPerformed extends ChatEvent {
  final String channelId;
  final String action;
  final String userId;

  const ChatAdminActionPerformed({
    required this.channelId,
    required this.action,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, action, userId];
}

class ChatChannelInvitationsRequested extends ChatEvent {
  final String channelId;

  const ChatChannelInvitationsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatChannelBlockedUsersRequested extends ChatEvent {
  final String channelId;

  const ChatChannelBlockedUsersRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatUserInvitationsRequested extends ChatEvent {
  final String userId;

  const ChatUserInvitationsRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class ChatUserMessagesRequested extends ChatEvent {
  final String currentUsername;
  final String otherUsername;

  const ChatUserMessagesRequested({
    required this.currentUsername,
    required this.otherUsername,
  });

  @override
  List<Object> get props => [currentUsername, otherUsername];
}

class ChatUserMessageSent extends ChatEvent {
  final String senderUsername;
  final String recipientUsername;
  final String content;

  const ChatUserMessageSent({
    required this.senderUsername,
    required this.recipientUsername,
    required this.content,
  });

  @override
  List<Object> get props => [senderUsername, recipientUsername, content];
}

class ChatChannelMemberAdded extends ChatEvent {
  final String channelId;
  final String username;

  const ChatChannelMemberAdded({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object> get props => [channelId, username];
}

class ChatChannelStatisticsRequested extends ChatEvent {
  final String channelId;

  const ChatChannelStatisticsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class SendMessage extends ChatEvent {
  final String channelId;
  final String message;
  final String userId;

  const SendMessage({
    required this.channelId,
    required this.message,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, message, userId];
}

class LoadMessages extends ChatEvent {
  final String channelId;
  final int limit;
  final String? beforeId;

  const LoadMessages({
    required this.channelId,
    this.limit = 50,
    this.beforeId,
  });

  @override
  List<Object?> get props => [channelId, limit, beforeId];
}

class LoadDirectMessages extends ChatEvent {
  final String userId;
  final int limit;
  final String? beforeId;

  const LoadDirectMessages({
    required this.userId,
    this.limit = 50,
    this.beforeId,
  });

  @override
  List<Object?> get props => [userId, limit, beforeId];
}

class SendDirectMessage extends ChatEvent {
  final String userId;
  final String message;

  const SendDirectMessage({
    required this.userId,
    required this.message,
  });

  @override
  List<Object> get props => [userId, message];
}

class LoadConversations extends ChatEvent {
  const LoadConversations();
}

class DeleteConversation extends ChatEvent {
  final String conversationId;

  const DeleteConversation(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}
