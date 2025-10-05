import 'package:equatable/equatable.dart';

abstract class InvitationEvent extends Equatable {
  const InvitationEvent();

  @override
  List<Object> get props => [];
}

class InvitationAccepted extends InvitationEvent {
  final String channelId;
  final String userId;

  const InvitationAccepted({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class InvitationRejected extends InvitationEvent {
  final String channelId;
  final String userId;

  const InvitationRejected({
    required this.channelId,
    required this.userId,
  });

  @override
  List<Object> get props => [channelId, userId];
}

class ChannelInvitationsRequested extends InvitationEvent {
  final String channelId;

  const ChannelInvitationsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class UserInvitationsRequested extends InvitationEvent {
  final String userId;

  const UserInvitationsRequested(this.userId);

  @override
  List<Object> get props => [userId];
}
