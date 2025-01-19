import 'package:equatable/equatable.dart';

abstract class ChatUserEvent extends Equatable {
  const ChatUserEvent();

  @override
  List<Object?> get props => [];
}

class ChannelUsersRequested extends ChatUserEvent {
  final String channelId;

  const ChannelUsersRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelRolesChecked extends ChatUserEvent {
  final String channelId;

  const ChannelRolesChecked(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelInvitationsRequested extends ChatUserEvent {
  final String channelId;

  const ChannelInvitationsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelBlockedUsersRequested extends ChatUserEvent {
  final String channelId;

  const ChannelBlockedUsersRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class UserInvitationsRequested extends ChatUserEvent {
  final String userId;

  const UserInvitationsRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class AdminActionPerformed extends ChatUserEvent {
  final String channelId;
  final String action;
  final String userId;

  const AdminActionPerformed({
    required this.channelId,
    required this.action,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, action, userId];
}

class UserListRequested extends ChatUserEvent {
  final String channelId;

  const UserListRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class UserAdded extends ChatUserEvent {
  final String channelId;
  final String username;

  const UserAdded({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object> get props => [channelId, username];
}

class UserRemoved extends ChatUserEvent {
  final String channelId;
  final String userId;

  const UserRemoved({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class UserBlocked extends ChatUserEvent {
  final String channelId;
  final String userId;

  const UserBlocked({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class UserUnblocked extends ChatUserEvent {
  final String channelId;
  final String userId;

  const UserUnblocked({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}
