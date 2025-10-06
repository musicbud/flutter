import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/channel_repository.dart';
import '../../../models/channel.dart';
import '../../../models/channel_user.dart';
import '../../../models/channel_stats.dart';
import 'channel_event.dart';
import 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final ChannelRepository repository;

  ChannelBloc({required this.repository}) : super(ChannelInitial()) {
    on<GetChannelsEvent>(_onGetChannels);
    on<GetChannelByIdEvent>(_onGetChannelById);
    on<CreateChannelEvent>(_onCreateChannel);
    on<UpdateChannelEvent>(_onUpdateChannel);
    on<DeleteChannelEvent>(_onDeleteChannel);
    on<JoinChannelEvent>(_onJoinChannel);
    on<LeaveChannelEvent>(_onLeaveChannel);
    on<GetChannelMembersEvent>(_onGetChannelMembers);
    on<AddModeratorEvent>(_onAddModerator);
    on<RemoveModeratorEvent>(_onRemoveModerator);
    on<UpdateChannelSettingsEvent>(_onUpdateChannelSettings);
    on<MuteChannelEvent>(_onMuteChannel);
    on<UnmuteChannelEvent>(_onUnmuteChannel);
    on<GetChannelStatsEvent>(_onGetChannelStats);
  }

  Future<void> _onGetChannels(
    GetChannelsEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.getChannels(
      limit: event.limit,
      offset: event.offset,
    );
    result.fold(
      (failure) => emit(const ChannelError('Failed to load channels')),
      (channels) => emit(ChannelsLoaded(channels as List<Channel>)),
    );
  }

  Future<void> _onGetChannelById(
    GetChannelByIdEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.getChannelById(event.id);
    result.fold(
      (failure) => emit(const ChannelError('Failed to load channel')),
      (channel) => emit(SingleChannelLoaded(channel as Channel)),
    );
  }

  Future<void> _onCreateChannel(
    CreateChannelEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.createChannel(event.channel);
    result.fold(
      (failure) => emit(const ChannelError('Failed to create channel')),
      (channel) => emit(SingleChannelLoaded(channel as Channel)),
    );
  }

  Future<void> _onUpdateChannel(
    UpdateChannelEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.updateChannel(event.channel.id, event.channel);
    result.fold(
      (failure) => emit(const ChannelError('Failed to update channel')),
      (channel) => emit(SingleChannelLoaded(channel as Channel)),
    );
  }

  Future<void> _onDeleteChannel(
    DeleteChannelEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.deleteChannel(event.id);
    result.fold(
      (failure) => emit(const ChannelError('Failed to delete channel')),
      (_) => emit(const ChannelOperationSuccess('Channel deleted successfully')),
    );
  }

  Future<void> _onJoinChannel(
    JoinChannelEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.joinChannel(event.channelId);
    result.fold(
      (failure) => emit(const ChannelError('Failed to join channel')),
      (_) => emit(const ChannelOperationSuccess('Joined channel successfully')),
    );
  }

  Future<void> _onLeaveChannel(
    LeaveChannelEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.leaveChannel(event.channelId);
    result.fold(
      (failure) => emit(const ChannelError('Failed to leave channel')),
      (_) => emit(const ChannelOperationSuccess('Left channel successfully')),
    );
  }

  Future<void> _onGetChannelMembers(
    GetChannelMembersEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.getChannelMembers(event.channelId);
    result.fold(
      (failure) => emit(const ChannelError('Failed to load channel members')),
      (members) => emit(ChannelMembersLoaded(members.map((id) => ChannelUser(id: id, username: id, role: 'member', joinedAt: DateTime.now())).toList())),
    );
  }

  Future<void> _onAddModerator(
    AddModeratorEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.addModerator(event.channelId, event.userId);
    result.fold(
      (failure) => emit(const ChannelError('Failed to add moderator')),
      (_) => emit(const ChannelOperationSuccess('Moderator added successfully')),
    );
  }

  Future<void> _onRemoveModerator(
    RemoveModeratorEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.removeModerator(event.channelId, event.userId);
    result.fold(
      (failure) => emit(const ChannelError('Failed to remove moderator')),
      (_) => emit(const ChannelOperationSuccess('Moderator removed successfully')),
    );
  }

  Future<void> _onUpdateChannelSettings(
    UpdateChannelSettingsEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.updateChannelSettings(
      event.channelId,
      event.settings,
    );
    result.fold(
      (failure) => emit(const ChannelError('Failed to update channel settings')),
      (_) => emit(const ChannelOperationSuccess('Settings updated successfully')),
    );
  }

  Future<void> _onMuteChannel(
    MuteChannelEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.muteChannel(event.channelId);
    result.fold(
      (failure) => emit(const ChannelError('Failed to mute channel')),
      (_) => emit(const ChannelOperationSuccess('Channel muted successfully')),
    );
  }

  Future<void> _onUnmuteChannel(
    UnmuteChannelEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.unmuteChannel(event.channelId);
    result.fold(
      (failure) => emit(const ChannelError('Failed to unmute channel')),
      (_) => emit(const ChannelOperationSuccess('Channel unmuted successfully')),
    );
  }

  Future<void> _onGetChannelStats(
    GetChannelStatsEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    final result = await repository.getChannelStats(event.channelId);
    result.fold(
      (failure) => emit(const ChannelError('Failed to load channel stats')),
      (stats) => emit(ChannelStatsLoaded(stats as ChannelStats)),
    );
  }
}
