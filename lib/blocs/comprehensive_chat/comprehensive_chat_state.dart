import 'package:equatable/equatable.dart';
import '../../domain/models/channel.dart';
import '../../domain/models/message.dart';
import '../../domain/models/channel_details.dart';
import '../../domain/models/channel_dashboard.dart';
import '../../domain/models/channel_statistics.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/channel_invitation.dart';

// Base state class
abstract class ComprehensiveChatState extends Equatable {
  const ComprehensiveChatState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ComprehensiveChatInitial extends ComprehensiveChatState {}

// Loading state
class ComprehensiveChatLoading extends ComprehensiveChatState {}

// Error state
class ComprehensiveChatError extends ComprehensiveChatState {
  final String message;

  const ComprehensiveChatError(this.message);

  @override
  List<Object?> get props => [message];
}

// Authentication states
class LoginSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const LoginSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class RegisterSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const RegisterSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class LogoutSuccess extends ComprehensiveChatState {}

class RefreshTokenSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const RefreshTokenSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

// Chat states
class ChannelsLoaded extends ComprehensiveChatState {
  final List<Channel> channels;

  const ChannelsLoaded(this.channels);

  @override
  List<Object?> get props => [channels];
}

class ChannelCreatedSuccess extends ComprehensiveChatState {
  final Channel channel;

  const ChannelCreatedSuccess(this.channel);

  @override
  List<Object?> get props => [channel];
}

class ChannelJoinedSuccess extends ComprehensiveChatState {}

class ChannelLeftSuccess extends ComprehensiveChatState {}

class ChannelJoinRequestedSuccess extends ComprehensiveChatState {}

class MessagesLoaded extends ComprehensiveChatState {
  final List<Message> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessageSentSuccess extends ComprehensiveChatState {
  final Message message;

  const MessageSentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageDeletedSuccess extends ComprehensiveChatState {}

// Admin states
class AdminStatusLoaded extends ComprehensiveChatState {
  final bool isAdmin;

  const AdminStatusLoaded(this.isAdmin);

  @override
  List<Object?> get props => [isAdmin];
}

class AdminAddedSuccess extends ComprehensiveChatState {}

class AdminRemovedSuccess extends ComprehensiveChatState {}

class ModeratorAddedSuccess extends ComprehensiveChatState {}

class ModeratorRemovedSuccess extends ComprehensiveChatState {}

class UserKickedSuccess extends ComprehensiveChatState {}

class UserBlockedSuccess extends ComprehensiveChatState {}

class UserUnblockedSuccess extends ComprehensiveChatState {}

// Channel management states
class ChannelDetailsLoaded extends ComprehensiveChatState {
  final ChannelDetails details;

  const ChannelDetailsLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class ChannelDashboardLoaded extends ComprehensiveChatState {
  final ChannelDashboard dashboard;

  const ChannelDashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class ChannelStatisticsLoaded extends ComprehensiveChatState {
  final ChannelStatistics statistics;

  const ChannelStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

class ChannelSettingsUpdatedSuccess extends ComprehensiveChatState {
  final String channelId;
  final dynamic settings;

  const ChannelSettingsUpdatedSuccess({
    required this.channelId,
    required this.settings,
  });

  @override
  List<Object?> get props => [channelId, settings];
}

class ChannelDeletedSuccess extends ComprehensiveChatState {}

// User management states
class UsersLoaded extends ComprehensiveChatState {
  final List<UserProfile> users;

  const UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserProfileLoaded extends ComprehensiveChatState {
  final UserProfile profile;

  const UserProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UserProfileUpdatedSuccess extends ComprehensiveChatState {}

class UserBannedSuccess extends ComprehensiveChatState {}

class UserUnbannedSuccess extends ComprehensiveChatState {}

class BannedUsersLoaded extends ComprehensiveChatState {
  final List<UserProfile> bannedUsers;

  const BannedUsersLoaded(this.bannedUsers);

  @override
  List<Object?> get props => [bannedUsers];
}

// Service connection states
class SpotifyConnectedSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const SpotifyConnectedSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class SpotifyDisconnectedSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const SpotifyDisconnectedSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class LastfmConnectedSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const LastfmConnectedSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class LastfmDisconnectedSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const LastfmDisconnectedSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class YtmusicConnectedSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const YtmusicConnectedSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class YtmusicDisconnectedSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const YtmusicDisconnectedSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class MalConnectedSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const MalConnectedSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class MalDisconnectedSuccess extends ComprehensiveChatState {
  final Map<String, dynamic> result;

  const MalDisconnectedSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

// Invitation states
class ChannelInvitationsLoaded extends ComprehensiveChatState {
  final List<ChannelInvitation> invitations;

  const ChannelInvitationsLoaded(this.invitations);

  @override
  List<Object?> get props => [invitations];
}

class UserInvitationsLoaded extends ComprehensiveChatState {
  final List<ChannelInvitation> invitations;

  const UserInvitationsLoaded(this.invitations);

  @override
  List<Object?> get props => [invitations];
}

class InvitationSentSuccess extends ComprehensiveChatState {}

class InvitationAcceptedSuccess extends ComprehensiveChatState {}

class InvitationDeclinedSuccess extends ComprehensiveChatState {}