import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/models/channel.dart';
import 'channel_event.dart';
import 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final ChatRepository _chatRepository;

  ChannelBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChannelInitial()) {
    on<ChannelListRequested>(_onChannelListRequested);
    on<ChannelCreated>(_onChannelCreated);
    on<ChannelJoined>(_onChannelJoined);
    on<ChannelJoinRequested>(_onChannelJoinRequested);
    on<ChannelDetailsRequested>(_onChannelDetailsRequested);
    on<ChannelDashboardRequested>(_onChannelDashboardRequested);
  }

  Future<void> _onChannelListRequested(
    ChannelListRequested event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    try {
      final channels = await _chatRepository.getChannels();
      emit(ChannelListLoaded(channels));
    } catch (e) {
      emit(ChannelFailure(e.toString()));
    }
  }

  Future<void> _onChannelCreated(
    ChannelCreated event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    try {
      final channel = await _chatRepository.createChannel(
        event.channelData['name'],
        event.channelData['description'],
      );
      emit(ChannelCreatedSuccess(channel));
    } catch (e) {
      emit(ChannelFailure(e.toString()));
    }
  }

  Future<void> _onChannelJoined(
    ChannelJoined event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    try {
      await _chatRepository.joinChannel(event.channelId.toString());
      emit(ChannelJoinedSuccess());
    } catch (e) {
      emit(ChannelFailure(e.toString()));
    }
  }

  Future<void> _onChannelJoinRequested(
    ChannelJoinRequested event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    try {
      await _chatRepository.joinChannel(event.channelId.toString());
      emit(ChannelJoinRequestedSuccess());
    } catch (e) {
      emit(ChannelFailure(e.toString()));
    }
  }

  Future<void> _onChannelDetailsRequested(
    ChannelDetailsRequested event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    try {
      final channel =
          await _chatRepository.getChannel(event.channelId.toString());
      emit(ChannelDetailsLoaded(channel));
    } catch (e) {
      emit(ChannelFailure(e.toString()));
    }
  }

  Future<void> _onChannelDashboardRequested(
    ChannelDashboardRequested event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());
    try {
      final statistics = await _chatRepository
          .getChannelStatistics(event.channelId.toString());
      emit(ChannelDashboardLoaded(statistics));
    } catch (e) {
      emit(ChannelFailure(e.toString()));
    }
  }
}
