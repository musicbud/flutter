import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'ytmusic_event.dart';
import 'ytmusic_state.dart';

class YtMusicBloc extends Bloc<YtMusicEvent, YtMusicState> {
  final AuthRepository _authRepository;

  YtMusicBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const YtMusicInitial()) {
    on<YtMusicAuthUrlRequested>(_onYtMusicAuthUrlRequested);
    on<YtMusicConnectRequested>(_onYtMusicConnectRequested);
    on<YtMusicDisconnectRequested>(_onYtMusicDisconnectRequested);
  }

  Future<void> _onYtMusicAuthUrlRequested(
    YtMusicAuthUrlRequested event,
    Emitter<YtMusicState> emit,
  ) async {
    emit(const YtMusicLoading());
    try {
      final url = await _authRepository.getYTMusicAuthUrl();
      emit(YtMusicAuthUrlLoaded(url));
    } catch (e) {
      emit(YtMusicFailure(e.toString()));
    }
  }

  Future<void> _onYtMusicConnectRequested(
    YtMusicConnectRequested event,
    Emitter<YtMusicState> emit,
  ) async {
    emit(const YtMusicLoading());
    try {
      await _authRepository.connectYTMusic(event.code);
      emit(const YtMusicConnected());
    } catch (e) {
      emit(YtMusicFailure(e.toString()));
    }
  }

  Future<void> _onYtMusicDisconnectRequested(
    YtMusicDisconnectRequested event,
    Emitter<YtMusicState> emit,
  ) async {
    emit(const YtMusicLoading());
    try {
      await _authRepository.disconnectYTMusic();
      emit(const YtMusicDisconnected());
    } catch (e) {
      emit(YtMusicFailure(e.toString()));
    }
  }
}
