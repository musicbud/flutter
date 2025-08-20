import 'package:equatable/equatable.dart';
import '../../../domain/models/channel_user.dart';

abstract class ChatUserState extends Equatable {
  const ChatUserState();

  @override
  List<Object?> get props => [];
}

class ChatUserInitial extends ChatUserState {}

class ChatUserLoading extends ChatUserState {}

class ChatUserFailure extends ChatUserState {
  final String error;

  const ChatUserFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ChannelUsersLoaded extends ChatUserState {
  final List<ChannelUser> users;

  const ChannelUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class ChannelRolesLoaded extends ChatUserState {
  final Map<String, bool> roles;

  const ChannelRolesLoaded(this.roles);

  @override
  List<Object> get props => [roles];
}

class ChannelInvitationsLoaded extends ChatUserState {
  final List<Map<String, dynamic>> invitations;

  const ChannelInvitationsLoaded(this.invitations);

  @override
  List<Object> get props => [invitations];
}

class ChannelBlockedUsersLoaded extends ChatUserState {
  final List<Map<String, dynamic>> blockedUsers;

  const ChannelBlockedUsersLoaded(this.blockedUsers);

  @override
  List<Object> get props => [blockedUsers];
}

class UserInvitationsLoaded extends ChatUserState {
  final List<Map<String, dynamic>> invitations;

  const UserInvitationsLoaded(this.invitations);

  @override
  List<Object> get props => [invitations];
}

class AdminActionSuccess extends ChatUserState {}
