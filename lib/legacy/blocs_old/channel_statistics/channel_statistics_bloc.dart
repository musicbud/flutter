import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import 'channel_statistics_event.dart';
import 'channel_statistics_state.dart';

class ChannelStatisticsBloc
    extends Bloc<ChannelStatisticsEvent, ChannelStatisticsState> {
  final ChatRepository _chatRepository;

  ChannelStatisticsBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChannelStatisticsInitial()) {
    on<ChannelStatisticsRequested>(_onChannelStatisticsRequested);
    on<ChannelStatisticsRefreshRequested>(_onChannelStatisticsRefreshRequested);
  }

  Future<void> _onChannelStatisticsRequested(
    ChannelStatisticsRequested event,
    Emitter<ChannelStatisticsState> emit,
  ) async {
    try {
      emit(ChannelStatisticsLoading());
      final statistics = await _chatRepository
          .getChannelStatistics(event.channelId.toString());
      emit(ChannelStatisticsLoaded(statistics));
    } catch (error) {
      emit(ChannelStatisticsFailure(error.toString()));
    }
  }

  Future<void> _onChannelStatisticsRefreshRequested(
    ChannelStatisticsRefreshRequested event,
    Emitter<ChannelStatisticsState> emit,
  ) async {
    try {
      final statistics = await _chatRepository
          .getChannelStatistics(event.channelId.toString());
      emit(ChannelStatisticsLoaded(statistics));
    } catch (error) {
      emit(ChannelStatisticsFailure(error.toString()));
    }
  }
}
