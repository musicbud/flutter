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
  final int channelId;

  const ChatChannelMessagesRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatMessageSent extends ChatEvent {
  final int channelId;
  final String senderUsername;
  final String content;

  const ChatMessageSent({
    required this.channelId,
    required this.senderUsername,
    required this.content,
  });

  @override
  List<Object> get props => [channelId, senderUsername, content];
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
  final Map<String, dynamic> channelData;

  const ChatChannelCreated(this.channelData);

  @override
  List<Object> get props => [channelData];
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
  final int channelId;

  const ChatChannelDetailsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChatChannelDashboardRequested extends ChatEvent {
  final int channelId;

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
  final int channelId;
  final String username;

  const ChatChannelMemberAdded({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object> get props => [channelId, username];
}

class ChatChannelStatisticsRequested extends ChatEvent {
  final int channelId;

  const ChatChannelStatisticsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}
