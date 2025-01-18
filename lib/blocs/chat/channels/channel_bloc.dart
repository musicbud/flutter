import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../models/channel.dart';
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
      final channels = await _chatRepository.getChannelList();
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
      final channel = await _chatRepository.createChannel(event.channelData);
      emit(ChannelCreatedSuccess(
          Channel.fromJson(Map<String, dynamic>.from(channel))));
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
      await _chatRepository.joinChannel(event.channelId);
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
      await _chatRepository.requestJoinChannel(event.channelId);
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
      final details = await _chatRepository.getChannelDetails(event.channelId);
      emit(ChannelDetailsLoaded(details));
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
      final dashboard =
          await _chatRepository.getChannelDashboardData(event.channelId);
      emit(ChannelDashboardLoaded(dashboard));
    } catch (e) {
      emit(ChannelFailure(e.toString()));
    }
  }
}
