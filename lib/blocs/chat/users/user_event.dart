import 'package:equatable/equatable.dart';

abstract class ChatUserEvent extends Equatable {
  const ChatUserEvent();

  @override
  List<Object?> get props => [];
}

class ChannelUsersRequested extends ChatUserEvent {
  final int channelId;

  const ChannelUsersRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelRolesChecked extends ChatUserEvent {
  final int channelId;

  const ChannelRolesChecked(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelInvitationsRequested extends ChatUserEvent {
  final int channelId;

  const ChannelInvitationsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelBlockedUsersRequested extends ChatUserEvent {
  final int channelId;

  const ChannelBlockedUsersRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class UserInvitationsRequested extends ChatUserEvent {
  final int userId;

  const UserInvitationsRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class AdminActionPerformed extends ChatUserEvent {
  final int channelId;
  final String action;
  final int userId;

  const AdminActionPerformed({
    required this.channelId,
    required this.action,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, action, userId];
}
