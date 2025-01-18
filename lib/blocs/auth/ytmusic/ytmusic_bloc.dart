import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'ytmusic_event.dart';
import 'ytmusic_state.dart';

class YTMusicBloc extends Bloc<YTMusicEvent, YTMusicState> {
  final AuthRepository _authRepository;

  YTMusicBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(YTMusicInitial()) {
    on<YTMusicAuthUrlRequested>(_onAuthUrlRequested);
    on<YTMusicConnectRequested>(_onConnectRequested);
    on<YTMusicDisconnectRequested>(_onDisconnectRequested);
  }

  Future<void> _onAuthUrlRequested(
    YTMusicAuthUrlRequested event,
    Emitter<YTMusicState> emit,
  ) async {
    emit(YTMusicLoading());
    try {
      final url = await _authRepository.getYTMusicAuthUrl();
      emit(YTMusicAuthUrlLoaded(url));
    } catch (e) {
      emit(YTMusicFailure(e.toString()));
    }
  }

  Future<void> _onConnectRequested(
    YTMusicConnectRequested event,
    Emitter<YTMusicState> emit,
  ) async {
    emit(YTMusicLoading());
    try {
      await _authRepository.connectYTMusic(event.code);
      emit(YTMusicConnected());
    } catch (e) {
      emit(YTMusicFailure(e.toString()));
    }
  }

  Future<void> _onDisconnectRequested(
    YTMusicDisconnectRequested event,
    Emitter<YTMusicState> emit,
  ) async {
    emit(YTMusicLoading());
    try {
      await _authRepository.disconnectYTMusic();
      emit(YTMusicDisconnected());
    } catch (e) {
      emit(YTMusicFailure(e.toString()));
    }
  }
}
