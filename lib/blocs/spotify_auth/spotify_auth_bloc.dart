import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'spotify_auth_event.dart';
import 'spotify_auth_state.dart';

class SpotifyAuthBloc extends Bloc<SpotifyAuthEvent, SpotifyAuthState> {
  final AuthRepository _authRepository;

  SpotifyAuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(SpotifyAuthInitial()) {
    on<SpotifyAuthCodeReceived>(_onSpotifyAuthCodeReceived);
  }

  Future<void> _onSpotifyAuthCodeReceived(
    SpotifyAuthCodeReceived event,
    Emitter<SpotifyAuthState> emit,
  ) async {
    emit(SpotifyAuthLoading());

    try {
      await _authRepository.connectSpotify(event.code);
      emit(SpotifyAuthSuccess());
    } catch (e) {
      emit(SpotifyAuthFailure(e.toString()));
    }
  }
}
