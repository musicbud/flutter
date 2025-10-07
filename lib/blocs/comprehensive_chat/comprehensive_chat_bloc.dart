import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/services_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../models/channel.dart';
import '../../models/channel_details.dart';
import '../../models/channel_dashboard.dart';
import '../../models/channel_invitation.dart';
import '../../models/channel_statistics.dart';
import '../../models/channel_settings.dart';
import '../../models/channel_stats.dart';
import 'comprehensive_chat_event.dart';
import 'comprehensive_chat_state.dart';

class ComprehensiveChatBloc extends Bloc<ComprehensiveChatEvent, ComprehensiveChatState> {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  final ServicesRepository _servicesRepository;
  final AuthRepository _authRepository;

  ComprehensiveChatBloc({
    required ChatRepository chatRepository,
    required UserRepository userRepository,
    required ServicesRepository servicesRepository,
    required AuthRepository authRepository,
  })  : _chatRepository = chatRepository,
        _userRepository = userRepository,
        _servicesRepository = servicesRepository,
        _authRepository = authRepository,
        super(ComprehensiveChatInitial()) {

    // Authentication events
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RefreshTokenRequested>(_onRefreshTokenRequested);

    // Chat events
    on<ChannelsRequested>(_onChannelsRequested);
    on<ChannelCreated>(_onChannelCreated);
    on<ChannelJoined>(_onChannelJoined);
    on<ChannelLeft>(_onChannelLeft);
    on<ChannelJoinRequested>(_onChannelJoinRequested);
    on<MessagesRequested>(_onMessagesRequested);
    on<MessageSent>(_onMessageSent);
    on<MessageDeleted>(_onMessageDeleted);

    // Admin events
    on<AdminStatusChecked>(_onAdminStatusChecked);
    on<AdminAdded>(_onAdminAdded);
    on<AdminRemoved>(_onAdminRemoved);
    on<ModeratorAdded>(_onModeratorAdded);
    on<ModeratorRemoved>(_onModeratorRemoved);
    on<UserKicked>(_onUserKicked);
    on<UserBlocked>(_onUserBlocked);
    on<UserUnblocked>(_onUserUnblocked);

    // Channel management events
    on<ChannelDetailsRequested>(_onChannelDetailsRequested);
    on<ChannelDashboardRequested>(_onChannelDashboardRequested);
    on<ChannelStatisticsRequested>(_onChannelStatisticsRequested);
    on<ChannelSettingsUpdated>(_onChannelSettingsUpdated);
    on<ChannelDeleted>(_onChannelDeleted);

    // User management events
    on<UsersRequested>(_onUsersRequested);
    on<UserProfileRequested>(_onUserProfileRequested);
    on<UserProfileUpdated>(_onUserProfileUpdated);
    on<UserBanned>(_onUserBanned);
    on<UserUnbanned>(_onUserUnbanned);
    on<BannedUsersRequested>(_onBannedUsersRequested);

    // Service connection events
    on<SpotifyConnected>(_onSpotifyConnected);
    on<SpotifyDisconnected>(_onSpotifyDisconnected);
    on<LastfmConnected>(_onLastfmConnected);
    on<LastfmDisconnected>(_onLastfmDisconnected);
    on<YtmusicConnected>(_onYtmusicConnected);
    on<YtmusicDisconnected>(_onYtmusicDisconnected);
    on<MalConnected>(_onMalConnected);
    on<MalDisconnected>(_onMalDisconnected);

    // Invitation events
    on<ChannelInvitationsRequested>(_onChannelInvitationsRequested);
    on<UserInvitationsRequested>(_onUserInvitationsRequested);
    on<InvitationSent>(_onInvitationSent);
    on<InvitationAccepted>(_onInvitationAccepted);
    on<InvitationDeclined>(_onInvitationDeclined);
  }

  // Authentication event handlers
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final result = await _authRepository.login(event.username, event.password);
      emit(LoginSuccess(result));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final result = await _authRepository.register(event.username, event.email, event.password);
      emit(RegisterSuccess(result));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _authRepository.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onRefreshTokenRequested(
    RefreshTokenRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final result = await _authRepository.refreshToken();
      emit(RefreshTokenSuccess({'token': result}));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  // Chat event handlers
  Future<void> _onChannelsRequested(
    ChannelsRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final channels = await _chatRepository.getChannels();
      emit(ChannelsLoaded(channels));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onChannelCreated(
    ChannelCreated event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      // TODO: Convert channelData to Channel model when repository returns proper type
      // final channelData = await _chatRepository.createChannel(event.name, event.description);
      // final channel = Channel.fromJson(channelData);
      final newChannel = Channel.create(
        name: event.name,
        description: event.description,
        isPublic: true,
      );
      emit(ChannelCreatedSuccess(newChannel));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onChannelJoined(
    ChannelJoined event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.joinChannel(event.channelId);
      emit(ChannelJoinedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onChannelLeft(
    ChannelLeft event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.leaveChannel(event.channelId);
      emit(ChannelLeftSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onChannelJoinRequested(
    ChannelJoinRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.requestJoinChannel(event.channelId);
      emit(ChannelJoinRequestedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onMessagesRequested(
    MessagesRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final messages = await _chatRepository.getChannelMessages(
        event.channelId,
        limit: event.limit,
        before: event.before,
      );
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onMessageSent(
    MessageSent event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final message = await _chatRepository.sendChannelMessage(
        event.channelId,
        event.content,
      );
      emit(MessageSentSuccess(message));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onMessageDeleted(
    MessageDeleted event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.deleteMessage(event.channelId, event.messageId);
      emit(MessageDeletedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  // Admin event handlers
  Future<void> _onAdminStatusChecked(
    AdminStatusChecked event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final isAdmin = await _chatRepository.isChannelAdmin(event.channelId);
      emit(AdminStatusLoaded(isAdmin));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onAdminAdded(
    AdminAdded event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.makeAdmin(event.channelId, event.userId);
      emit(AdminAddedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onAdminRemoved(
    AdminRemoved event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.removeAdmin(event.channelId, event.userId);
      emit(AdminRemovedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onModeratorAdded(
    ModeratorAdded event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.addModerator(event.channelId, event.userId);
      emit(ModeratorAddedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onModeratorRemoved(
    ModeratorRemoved event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.removeModerator(event.channelId, event.userId);
      emit(ModeratorRemovedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onUserKicked(
    UserKicked event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.kickUser(event.channelId, event.userId);
      emit(UserKickedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onUserBlocked(
    UserBlocked event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.blockUser(event.channelId, event.userId);
      emit(UserBlockedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onUserUnblocked(
    UserUnblocked event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.unblockUser(event.channelId, event.userId);
      emit(UserUnblockedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  // Channel management event handlers
  Future<void> _onChannelDetailsRequested(
    ChannelDetailsRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      // TODO: Convert detailsData to ChannelDetails model when repository returns proper type
      // final detailsData = await _chatRepository.getChannelDetails(event.channelId);
      // final details = ChannelDetails.fromJson(detailsData);
      emit(ChannelDetailsLoaded(ChannelDetails(
        channel: Channel(
          id: event.channelId,
          name: 'Channel',
          description: null,
          isPublic: true,
          settings: ChannelSettings(
            channelId: event.channelId,
            isPrivate: false,
          ),
          stats: ChannelStats(
            channelId: event.channelId,
            memberCount: 0,
            messageCount: 0,
            activeUsers: 0,
            lastActivityAt: DateTime.now(),
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isJoined: false,
        ),
        members: const [],
        moderators: const [],
        admins: const [],
        totalMessages: 0,
        activeMembers: 0,
      )));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onChannelDashboardRequested(
    ChannelDashboardRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      // TODO: Convert dashboardData to ChannelDashboard model when repository returns proper type
      // final dashboardData = await _chatRepository.getChannelDashboardData(event.channelId);
      // final dashboard = ChannelDashboard.fromJson(dashboardData);
      emit(const ChannelDashboardLoaded(ChannelDashboard(
        recentMessages: [],
        activeUsers: [],
        messageStats: {},
        userStats: {},
      )));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onChannelStatisticsRequested(
    ChannelStatisticsRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      // TODO: Convert statisticsData to ChannelStatistics model when repository returns proper type
      // final statisticsData = await _chatRepository.getChannelStatistics(event.channelId);
      // final statistics = ChannelStatistics.fromJson(statisticsData);
      emit(const ChannelStatisticsLoaded(ChannelStatistics(
        totalMessages: 0,
        totalMembers: 0,
        activeMembers: 0,
        messagesLastDay: 0,
        messagesLastWeek: 0,
        messagesLastMonth: 0,
        messagesByHour: {},
        messagesByDay: {},
        messagesByUser: {},
      )));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onChannelSettingsUpdated(
    ChannelSettingsUpdated event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    try {
      final channel = await _chatRepository.getChannel(event.channelId);
      await _chatRepository.updateChannel(
        event.channelId,
        channel.name,
        channel.description ?? '',
      );
      emit(ChannelSettingsUpdatedSuccess(
        channelId: event.channelId,
        settings: event.settings,
      ));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onChannelDeleted(
    ChannelDeleted event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.deleteChannel(event.channelId.toString());
      emit(ChannelDeletedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  // User management event handlers
  Future<void> _onUsersRequested(
    UsersRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final users = await _chatRepository.getUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onUserProfileRequested(
    UserProfileRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final profile = await _userRepository.getUserProfile();
      emit(UserProfileLoaded(profile));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onUserProfileUpdated(
    UserProfileUpdated event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _userRepository.updateUserProfile(event.userId, event.profileData);
      emit(UserProfileUpdatedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onUserBanned(
    UserBanned event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _userRepository.banUser(event.userId);
      emit(UserBannedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onUserUnbanned(
    UserUnbanned event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _userRepository.unbanUser(event.userId);
      emit(UserUnbannedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onBannedUsersRequested(
    BannedUsersRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final bannedUsers = await _userRepository.getBannedUsers();
      emit(BannedUsersLoaded(bannedUsers));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  // Service connection event handlers
  Future<void> _onSpotifyConnected(
    SpotifyConnected event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _servicesRepository.connectSpotify('');
      emit(const SpotifyConnectedSuccess({'status': 'connected'}));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onSpotifyDisconnected(
    SpotifyDisconnected event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _servicesRepository.disconnectSpotify();
      emit(const SpotifyDisconnectedSuccess({'status': 'disconnected'}));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onLastfmConnected(
    LastfmConnected event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _servicesRepository.connectLastFM('');
      emit(const LastfmConnectedSuccess({'status': 'connected'}));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onLastfmDisconnected(
    LastfmDisconnected event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _servicesRepository.disconnectLastFM();
      emit(const LastfmDisconnectedSuccess({'status': 'disconnected'}));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onYtmusicConnected(
    YtmusicConnected event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _servicesRepository.connectYTMusic('');
      emit(const YtmusicConnectedSuccess({'status': 'connected'}));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onYtmusicDisconnected(
    YtmusicDisconnected event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _servicesRepository.disconnectYTMusic();
      emit(const YtmusicDisconnectedSuccess({'status': 'disconnected'}));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onMalConnected(
    MalConnected event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _servicesRepository.connectMAL('');
      emit(const MalConnectedSuccess({'status': 'connected'}));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onMalDisconnected(
    MalDisconnected event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _servicesRepository.disconnectMAL();
      emit(const MalDisconnectedSuccess({'status': 'disconnected'}));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  // Invitation event handlers
  Future<void> _onChannelInvitationsRequested(
    ChannelInvitationsRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final invitations = await _chatRepository.getChannelInvitations(event.channelId);
      // Convert dynamic list to List<ChannelInvitation>
      final typedInvitations = invitations.map((invitation) =>
        ChannelInvitation.fromJson(invitation)
      ).toList();
      emit(ChannelInvitationsLoaded(typedInvitations));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onUserInvitationsRequested(
    UserInvitationsRequested event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      final invitations = await _chatRepository.getUserInvitations(event.userId);
      // Convert dynamic list to List<ChannelInvitation>
      final typedInvitations = invitations.map((invitation) =>
        ChannelInvitation.fromJson(invitation)
      ).toList();
      emit(UserInvitationsLoaded(typedInvitations));
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onInvitationSent(
    InvitationSent event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.sendInvitation(event.channelId, event.userId);
      emit(InvitationSentSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onInvitationAccepted(
    InvitationAccepted event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.acceptInvitation(event.invitationId);
      emit(InvitationAcceptedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }

  Future<void> _onInvitationDeclined(
    InvitationDeclined event,
    Emitter<ComprehensiveChatState> emit,
  ) async {
    emit(ComprehensiveChatLoading());
    try {
      await _chatRepository.declineInvitation(event.invitationId);
      emit(InvitationDeclinedSuccess());
    } catch (e) {
      emit(ComprehensiveChatError(e.toString()));
    }
  }
}