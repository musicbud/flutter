import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatChannelListRequested extends ChatEvent {}

class ChatUserListRequested extends ChatEvent {}

class ChatChannelUsersRequested extends ChatEvent {
  final int channelId;

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
  final int channelId;
  final int messageId;

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

  const ChatChannelCreated({
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [name, description];
}

class ChatChannelJoined extends ChatEvent {
  final String channelId;

  const ChatChannelJoined(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatChannelJoinRequested extends ChatEvent {
  final int channelId;

  const ChatChannelJoinRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
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
  final int channelId;

  const ChatChannelRolesChecked(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatAdminActionPerformed extends ChatEvent {
  final int channelId;
  final String action;
  final int userId;

  const ChatAdminActionPerformed({
    required this.channelId,
    required this.action,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, action, userId];
}

class ChatChannelInvitationsRequested extends ChatEvent {
  final int channelId;

  const ChatChannelInvitationsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatChannelBlockedUsersRequested extends ChatEvent {
  final int channelId;

  const ChatChannelBlockedUsersRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatUserInvitationsRequested extends ChatEvent {
  final int userId;

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
