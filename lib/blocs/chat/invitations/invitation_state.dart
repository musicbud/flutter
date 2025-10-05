import 'package:equatable/equatable.dart';

abstract class InvitationState extends Equatable {
  const InvitationState();

  @override
  List<Object?> get props => [];
}

class InvitationInitial extends InvitationState {}

class InvitationLoading extends InvitationState {}

class InvitationFailure extends InvitationState {
  final String error;

  const InvitationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class InvitationSentSuccess extends InvitationState {}

class InvitationAcceptedSuccess extends InvitationState {}

class InvitationRejectedSuccess extends InvitationState {}

class ChannelInvitationsLoaded extends InvitationState {
  final List<Map<String, dynamic>> invitations;

  const ChannelInvitationsLoaded(this.invitations);

  @override
  List<Object> get props => [invitations];
}

class UserInvitationsLoaded extends InvitationState {
  final List<Map<String, dynamic>> invitations;

  const UserInvitationsLoaded(this.invitations);

  @override
  List<Object> get props => [invitations];
}
