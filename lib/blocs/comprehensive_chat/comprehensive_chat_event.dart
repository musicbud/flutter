import 'package:equatable/equatable.dart';

// Base event class
abstract class ComprehensiveChatEvent extends Equatable {
  const ComprehensiveChatEvent();

  @override
  List<Object?> get props => [];
}

// Authentication events
class LoginRequested extends ComprehensiveChatEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class RegisterRequested extends ComprehensiveChatEvent {
  final String username;
  final String email;
  final String password;

  const RegisterRequested({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

class LogoutRequested extends ComprehensiveChatEvent {}

class RefreshTokenRequested extends ComprehensiveChatEvent {
  final String refreshToken;

  const RefreshTokenRequested({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}

// Chat events
class ChannelsRequested extends ComprehensiveChatEvent {}

class ChannelCreated extends ComprehensiveChatEvent {
  final String name;
  final String description;

  const ChannelCreated({required this.name, required this.description});

  @override
  List<Object?> get props => [name, description];
}

class ChannelJoined extends ComprehensiveChatEvent {
  final String channelId;

  const ChannelJoined({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChannelLeft extends ComprehensiveChatEvent {
  final String channelId;

  const ChannelLeft({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChannelJoinRequested extends ComprehensiveChatEvent {
  final String channelId;

  const ChannelJoinRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class MessagesRequested extends ComprehensiveChatEvent {
  final String channelId;
  final int? limit;
  final String? before;

  const MessagesRequested({
    required this.channelId,
    this.limit,
    this.before,
  });

  @override
  List<Object?> get props => [channelId, limit, before];
}

class MessageSent extends ComprehensiveChatEvent {
  final String channelId;
  final String content;

  const MessageSent({required this.channelId, required this.content});

  @override
  List<Object?> get props => [channelId, content];
}

class MessageDeleted extends ComprehensiveChatEvent {
  final String channelId;
  final String messageId;

  const MessageDeleted({required this.channelId, required this.messageId});

  @override
  List<Object?> get props => [channelId, messageId];
}

// Admin events
class AdminStatusChecked extends ComprehensiveChatEvent {
  final String channelId;

  const AdminStatusChecked({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class AdminAdded extends ComprehensiveChatEvent {
  final String channelId;
  final String userId;

  const AdminAdded({required this.channelId, required this.userId});

  @override
  List<Object?> get props => [channelId, userId];
}

class AdminRemoved extends ComprehensiveChatEvent {
  final String channelId;
  final String userId;

  const AdminRemoved({required this.channelId, required this.userId});

  @override
  List<Object?> get props => [channelId, userId];
}

class ModeratorAdded extends ComprehensiveChatEvent {
  final String channelId;
  final String userId;

  const ModeratorAdded({required this.channelId, required this.userId});

  @override
  List<Object?> get props => [channelId, userId];
}

class ModeratorRemoved extends ComprehensiveChatEvent {
  final String channelId;
  final String userId;

  const ModeratorRemoved({required this.channelId, required this.userId});

  @override
  List<Object?> get props => [channelId, userId];
}

class UserKicked extends ComprehensiveChatEvent {
  final String channelId;
  final String userId;

  const UserKicked({required this.channelId, required this.userId});

  @override
  List<Object?> get props => [channelId, userId];
}

class UserBlocked extends ComprehensiveChatEvent {
  final String channelId;
  final String userId;

  const UserBlocked({required this.channelId, required this.userId});

  @override
  List<Object?> get props => [channelId, userId];
}

class UserUnblocked extends ComprehensiveChatEvent {
  final String channelId;
  final String userId;

  const UserUnblocked({required this.channelId, required this.userId});

  @override
  List<Object?> get props => [channelId, userId];
}

// Channel management events
class ChannelDetailsRequested extends ComprehensiveChatEvent {
  final String channelId;

  const ChannelDetailsRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChannelDashboardRequested extends ComprehensiveChatEvent {
  final String channelId;

  const ChannelDashboardRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChannelStatisticsRequested extends ComprehensiveChatEvent {
  final String channelId;

  const ChannelStatisticsRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class ChannelSettingsUpdated extends ComprehensiveChatEvent {
  final String channelId;
  final Map<String, dynamic> settings;

  const ChannelSettingsUpdated({
    required this.channelId,
    required this.settings,
  });

  @override
  List<Object?> get props => [channelId, settings];
}

class ChannelDeleted extends ComprehensiveChatEvent {
  final String channelId;

  const ChannelDeleted({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

// User management events
class UsersRequested extends ComprehensiveChatEvent {}

class UserProfileRequested extends ComprehensiveChatEvent {
  final String userId;

  const UserProfileRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UserProfileUpdated extends ComprehensiveChatEvent {
  final String userId;
  final Map<String, dynamic> profileData;

  const UserProfileUpdated({
    required this.userId,
    required this.profileData,
  });

  @override
  List<Object?> get props => [userId, profileData];
}

class UserBanned extends ComprehensiveChatEvent {
  final String userId;

  const UserBanned({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UserUnbanned extends ComprehensiveChatEvent {
  final String userId;

  const UserUnbanned({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BannedUsersRequested extends ComprehensiveChatEvent {}

// Service connection events
class SpotifyConnected extends ComprehensiveChatEvent {}

class SpotifyDisconnected extends ComprehensiveChatEvent {}

class LastfmConnected extends ComprehensiveChatEvent {}

class LastfmDisconnected extends ComprehensiveChatEvent {}

class YtmusicConnected extends ComprehensiveChatEvent {}

class YtmusicDisconnected extends ComprehensiveChatEvent {}

class MalConnected extends ComprehensiveChatEvent {}

class MalDisconnected extends ComprehensiveChatEvent {}

// Invitation events
class ChannelInvitationsRequested extends ComprehensiveChatEvent {
  final String channelId;

  const ChannelInvitationsRequested({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class UserInvitationsRequested extends ComprehensiveChatEvent {
  final String userId;

  const UserInvitationsRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class InvitationSent extends ComprehensiveChatEvent {
  final String channelId;
  final String userId;

  const InvitationSent({required this.channelId, required this.userId});

  @override
  List<Object?> get props => [channelId, userId];
}

class InvitationAccepted extends ComprehensiveChatEvent {
  final String invitationId;

  const InvitationAccepted({required this.invitationId});

  @override
  List<Object?> get props => [invitationId];
}

class InvitationDeclined extends ComprehensiveChatEvent {
  final String invitationId;

  const InvitationDeclined({required this.invitationId});

  @override
  List<Object?> get props => [invitationId];
}