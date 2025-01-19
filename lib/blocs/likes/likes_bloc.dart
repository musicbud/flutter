import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import 'likes_event.dart';
import 'likes_state.dart';

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  final ContentRepository _contentRepository;
  final AuthRepository _authRepository;

  LikesBloc({
    required ContentRepository contentRepository,
    required AuthRepository authRepository,
  })  : _contentRepository = contentRepository,
        _authRepository = authRepository,
        super(const LikesInitial()) {
    on<LikesUpdateRequested>(_onLikesUpdateRequested);
    on<SpotifyConnectionRequested>(_onSpotifyConnectionRequested);
    on<LikesUpdateCancelled>(_onLikesUpdateCancelled);
  }

  Future<void> _onLikesUpdateRequested(
    LikesUpdateRequested event,
    Emitter<LikesState> emit,
  ) async {
    emit(const LikesUpdating());
    try {
      await _contentRepository.updateLikes();
      emit(const LikesUpdateSuccess('Likes updated successfully!'));
    } catch (e) {
      final message = e.toString();
      final needsSpotifyConnection =
          message.contains('No Spotify account found');
      emit(LikesUpdateFailure(
        error: message,
        needsSpotifyConnection: needsSpotifyConnection,
      ));
    }
  }

  Future<void> _onSpotifyConnectionRequested(
    SpotifyConnectionRequested event,
    Emitter<LikesState> emit,
  ) async {
    try {
      await _authRepository.getSpotifyAuthUrl();
      emit(const LikesUpdateSuccess('Please connect your Spotify account'));
    } catch (e) {
      emit(LikesUpdateFailure(
        error: 'Failed to get Spotify auth URL: ${e.toString()}',
      ));
    }
  }

  void _onLikesUpdateCancelled(
    LikesUpdateCancelled event,
    Emitter<LikesState> emit,
  ) {
    emit(const LikesInitial());
  }
}
