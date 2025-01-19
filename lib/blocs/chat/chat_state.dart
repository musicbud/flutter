import 'package:equatable/equatable.dart';
import '../../models/channel.dart';
import '../../models/channel_user.dart';
import '../../models/message.dart';
import '../../models/user_profile.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatFailure extends ChatState {
  final String error;

  const ChatFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ChatUserListLoaded extends ChatState {
  final List<UserProfile> users;

  const ChatUserListLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class ChatChannelListLoaded extends ChatState {
  final List<Channel> channels;

  const ChatChannelListLoaded(this.channels);

  @override
  List<Object> get props => [channels];
}

class ChatChannelUsersLoaded extends ChatState {
  final List<ChannelUser> users;

  const ChatChannelUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class ChatChannelMessagesLoaded extends ChatState {
  final List<Message> messages;

  const ChatChannelMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatMessageSentSuccess extends ChatState {
  final Message message;

  const ChatMessageSentSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ChatMessageDeletedSuccess extends ChatState {}

class ChatChannelCreatedSuccess extends ChatState {
  final Channel channel;

  const ChatChannelCreatedSuccess(this.channel);

  @override
  List<Object> get props => [channel];
}

class ChatChannelJoinedSuccess extends ChatState {}

class ChatChannelJoinRequestedSuccess extends ChatState {}

class ChatChannelDetailsLoaded extends ChatState {
  final Map<String, dynamic> details;

  const ChatChannelDetailsLoaded(this.details);

  @override
  List<Object> get props => [details];
}

class ChatChannelDashboardLoaded extends ChatState {
  final Map<String, dynamic> dashboard;

  const ChatChannelDashboardLoaded(this.dashboard);

  @override
  List<Object> get props => [dashboard];
}

class ChatChannelRolesLoaded extends ChatState {
  final Map<String, bool> roles;

  const ChatChannelRolesLoaded(this.roles);

  @override
  List<Object> get props => [roles];
}

class ChatAdminActionSuccess extends ChatState {}

class ChatChannelInvitationsLoaded extends ChatState {
  final List<Map<String, dynamic>> invitations;

  const ChatChannelInvitationsLoaded(this.invitations);

  @override
  List<Object> get props => [invitations];
}

class ChatChannelBlockedUsersLoaded extends ChatState {
  final List<Map<String, dynamic>> blockedUsers;

  const ChatChannelBlockedUsersLoaded(this.blockedUsers);

  @override
  List<Object> get props => [blockedUsers];
}

class ChatUserInvitationsLoaded extends ChatState {
  final List<Map<String, dynamic>> invitations;

  const ChatUserInvitationsLoaded(this.invitations);

  @override
  List<Object> get props => [invitations];
}

class ChatUserMessagesLoaded extends ChatState {
  final List<Message> messages;

  const ChatUserMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatUserMessageSentSuccess extends ChatState {
  final Message message;

  const ChatUserMessageSentSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ChatChannelStatisticsLoaded extends ChatState {
  final Map<String, dynamic> statistics;

  const ChatChannelStatisticsLoaded(this.statistics);

  @override
  List<Object> get props => [statistics];
}
