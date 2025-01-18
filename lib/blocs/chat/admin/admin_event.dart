import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class AdminStatusChecked extends AdminEvent {
  final int channelId;

  const AdminStatusChecked(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ModeratorAdded extends AdminEvent {
  final int channelId;
  final int userId;

  const ModeratorAdded({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class ModeratorRemoved extends AdminEvent {
  final int channelId;
  final int userId;

  const ModeratorRemoved({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class AdminAdded extends AdminEvent {
  final int channelId;
  final int userId;

  const AdminAdded({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class AdminRemoved extends AdminEvent {
  final int channelId;
  final int userId;

  const AdminRemoved({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class UserKicked extends AdminEvent {
  final int channelId;
  final int userId;

  const UserKicked({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class UserBlocked extends AdminEvent {
  final int channelId;
  final int userId;

  const UserBlocked({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class UserUnblocked extends AdminEvent {
  final int channelId;
  final int userId;

  const UserUnblocked({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}
