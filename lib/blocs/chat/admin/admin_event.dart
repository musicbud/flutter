import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class AdminStatusChecked extends AdminEvent {
  final String channelId;

  const AdminStatusChecked(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class AdminActionPerformed extends AdminEvent {
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

class ModeratorAdded extends AdminEvent {
  final String channelId;
  final String userId;

  const ModeratorAdded({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class ModeratorRemoved extends AdminEvent {
  final String channelId;
  final String userId;

  const ModeratorRemoved({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class AdminAdded extends AdminEvent {
  final String channelId;
  final String userId;

  const AdminAdded({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class AdminRemoved extends AdminEvent {
  final String channelId;
  final String userId;

  const AdminRemoved({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class UserKicked extends AdminEvent {
  final String channelId;
  final String userId;

  const UserKicked({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class UserBlocked extends AdminEvent {
  final String channelId;
  final String userId;

  const UserBlocked({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class UserUnblocked extends AdminEvent {
  final String channelId;
  final String userId;

  const UserUnblocked({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}
