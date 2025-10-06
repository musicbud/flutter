import 'package:equatable/equatable.dart';
import '../../models/channel.dart';
import '../../models/channel_user.dart';
import '../../models/message.dart';
import '../../models/user_profile.dart';
import '../../models/channel_details.dart';
import '../../models/channel_dashboard.dart';
import '../../models/channel_invitation.dart';
import '../../models/channel_statistics.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class MessageSent extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<Message> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  @override
  List<Object?> get props => [error];
}

class ChatUserListLoaded extends ChatState {
  final List<UserProfile> users;

  const ChatUserListLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class ChatUsersLoaded extends ChatState {
  final List<UserProfile> users;

  const ChatUsersLoaded(this.users);

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

class ChatMessageDeletedSuccess extends ChatState {
  const ChatMessageDeletedSuccess();
}

class ChatChannelCreatedSuccess extends ChatState {
  final Channel channel;

  const ChatChannelCreatedSuccess(this.channel);

  @override
  List<Object> get props => [channel];
}

class ChatChannelJoinedSuccess extends ChatState {}

class ChatChannelJoinRequestedSuccess extends ChatState {}

class ChatChannelDetailsLoaded extends ChatState {
  final ChannelDetails details;

  const ChatChannelDetailsLoaded(this.details);

  @override
  List<Object> get props => [details];
}

class ChatChannelDashboardLoaded extends ChatState {
  final ChannelDashboard dashboard;

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

class ChatAdminActionSuccess extends ChatState {
  const ChatAdminActionSuccess();
}

class ChatChannelInvitationsLoaded extends ChatState {
  final List<ChannelInvitation> invitations;

  const ChatChannelInvitationsLoaded(this.invitations);

  @override
  List<Object> get props => [invitations];
}

class ChatChannelBlockedUsersLoaded extends ChatState {
  final List<UserProfile> blockedUsers;

  const ChatChannelBlockedUsersLoaded(this.blockedUsers);

  @override
  List<Object> get props => [blockedUsers];
}

class ChatUserInvitationsLoaded extends ChatState {
  final List<ChannelInvitation> invitations;

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
  final ChannelStatistics statistics;

  const ChatChannelStatisticsLoaded(this.statistics);

  @override
  List<Object> get props => [statistics];
}
