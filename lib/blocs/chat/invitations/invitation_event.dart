import 'package:equatable/equatable.dart';

abstract class InvitationEvent extends Equatable {
  const InvitationEvent();

  @override
  List<Object?> get props => [];
}

class ChannelInvitationsSent extends InvitationEvent {
  final int channelId;
  final String username;

  const ChannelInvitationsSent({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object> get props => [channelId, username];
}

class ChannelInvitationsAccepted extends InvitationEvent {
  final int channelId;
  final int userId;

  const ChannelInvitationsAccepted({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class ChannelInvitationsRejected extends InvitationEvent {
  final int channelId;
  final int userId;

  const ChannelInvitationsRejected({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class ChannelInvitationsListRequested extends InvitationEvent {
  final int channelId;

  const ChannelInvitationsListRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class UserInvitationsListRequested extends InvitationEvent {
  final int userId;

  const UserInvitationsListRequested(this.userId);

  @override
  List<Object> get props => [userId];
}
