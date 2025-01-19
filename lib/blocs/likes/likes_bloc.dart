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
        super(LikesInitial()) {
    on<LikesUpdateRequested>(_onLikesUpdateRequested);
    on<SpotifyConnectionRequested>(_onSpotifyConnectionRequested);
    on<LikesUpdateCancelled>(_onLikesUpdateCancelled);
  }

  Future<void> _onLikesUpdateRequested(
    LikesUpdateRequested event,
    Emitter<LikesState> emit,
  ) async {
    emit(LikesUpdating());
    try {
      final result = await _contentRepository.updateLikes(event.channelId);
      if (result['status'] == 'success') {
        emit(LikesUpdateSuccess(
            result['message'] ?? 'Likes updated successfully!'));
      } else {
        final message = result['message'] ?? 'Failed to update likes';
        final needsSpotifyConnection =
            message.contains('No Spotify account found');
        emit(LikesUpdateFailure(
          error: message,
          needsSpotifyConnection: needsSpotifyConnection,
        ));
      }
    } catch (e) {
      emit(LikesUpdateFailure(error: e.toString()));
    }
  }

  Future<void> _onSpotifyConnectionRequested(
    SpotifyConnectionRequested event,
    Emitter<LikesState> emit,
  ) async {
    try {
      final authUrl = await _authRepository.getSpotifyAuthUrl();
      // Handle Spotify auth URL - this might need to be handled differently
      // depending on your app's navigation/routing setup
    } catch (e) {
      emit(LikesUpdateFailure(
          error: 'Failed to get Spotify auth URL: ${e.toString()}'));
    }
  }

  void _onLikesUpdateCancelled(
    LikesUpdateCancelled event,
    Emitter<LikesState> emit,
  ) {
    emit(LikesInitial());
  }
}
