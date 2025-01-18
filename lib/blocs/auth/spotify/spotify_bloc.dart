import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'spotify_event.dart';
import 'spotify_state.dart';

class SpotifyBloc extends Bloc<SpotifyEvent, SpotifyState> {
  final AuthRepository _authRepository;

  SpotifyBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SpotifyInitial()) {
    on<SpotifyAuthUrlRequested>(_onAuthUrlRequested);
    on<SpotifyConnectRequested>(_onConnectRequested);
    on<SpotifyDisconnectRequested>(_onDisconnectRequested);
  }

  Future<void> _onAuthUrlRequested(
    SpotifyAuthUrlRequested event,
    Emitter<SpotifyState> emit,
  ) async {
    emit(SpotifyLoading());
    try {
      final url = await _authRepository.getSpotifyAuthUrl();
      emit(SpotifyAuthUrlLoaded(url));
    } catch (e) {
      emit(SpotifyFailure(e.toString()));
    }
  }

  Future<void> _onConnectRequested(
    SpotifyConnectRequested event,
    Emitter<SpotifyState> emit,
  ) async {
    emit(SpotifyLoading());
    try {
      await _authRepository.connectSpotify(event.code);
      emit(SpotifyConnected());
    } catch (e) {
      emit(SpotifyFailure(e.toString()));
    }
  }

  Future<void> _onDisconnectRequested(
    SpotifyDisconnectRequested event,
    Emitter<SpotifyState> emit,
  ) async {
    emit(SpotifyLoading());
    try {
      await _authRepository.disconnectSpotify();
      emit(SpotifyDisconnected());
    } catch (e) {
      emit(SpotifyFailure(e.toString()));
    }
  }
}
