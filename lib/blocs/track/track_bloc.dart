import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/bud_repository.dart';
import 'track_event.dart';
import 'track_state.dart';

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final ContentRepository _contentRepository;
  final BudRepository _budRepository;

  TrackBloc({
    required ContentRepository contentRepository,
    required BudRepository budRepository,
  })  : _contentRepository = contentRepository,
        _budRepository = budRepository,
        super(TrackInitial()) {
    on<TrackBudsRequested>(_onTrackBudsRequested);
    on<TrackLikeToggled>(_onTrackLikeToggled);
    on<TrackPlayRequested>(_onTrackPlayRequested);
  }

  Future<void> _onTrackBudsRequested(
    TrackBudsRequested event,
    Emitter<TrackState> emit,
  ) async {
    emit(TrackLoading());
    try {
      final buds = await _budRepository.getBudsByTrack(event.trackId);
      emit(TrackBudsLoaded(buds));
    } catch (e) {
      emit(TrackFailure(e.toString()));
    }
  }

  Future<void> _onTrackLikeToggled(
    TrackLikeToggled event,
    Emitter<TrackState> emit,
  ) async {
    emit(TrackLoading());
    try {
      final isLiked = await _contentRepository.toggleTrackLike(event.trackId);
      emit(TrackLikeStatusChanged(isLiked));
    } catch (e) {
      emit(TrackFailure(e.toString()));
    }
  }

  Future<void> _onTrackPlayRequested(
    TrackPlayRequested event,
    Emitter<TrackState> emit,
  ) async {
    emit(TrackLoading());
    try {
      final track = await _contentRepository.playTrack(
        event.trackId,
        deviceId: event.deviceId,
      );
      emit(TrackPlayStarted(track));
    } catch (e) {
      emit(TrackFailure(e.toString()));
    }
  }
}
