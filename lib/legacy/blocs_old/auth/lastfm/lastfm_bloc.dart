import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'lastfm_event.dart';
import 'lastfm_state.dart';

class LastFmBloc extends Bloc<LastFmEvent, LastFmState> {
  final AuthRepository _authRepository;

  LastFmBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const LastFmInitial()) {
    on<LastFmAuthUrlRequested>(_onLastFmAuthUrlRequested);
    on<LastFmConnectRequested>(_onLastFmConnectRequested);
    on<LastFmDisconnectRequested>(_onLastFmDisconnectRequested);
  }

  Future<void> _onLastFmAuthUrlRequested(
    LastFmAuthUrlRequested event,
    Emitter<LastFmState> emit,
  ) async {
    emit(const LastFmLoading());
    try {
      final url = await _authRepository.getLastFMAuthUrl();
      emit(LastFmAuthUrlLoaded(url));
    } catch (e) {
      emit(LastFmFailure(e.toString()));
    }
  }

  Future<void> _onLastFmConnectRequested(
    LastFmConnectRequested event,
    Emitter<LastFmState> emit,
  ) async {
    emit(const LastFmLoading());
    try {
      await _authRepository.connectLastFM(event.code);
      emit(const LastFmConnected());
    } catch (e) {
      emit(LastFmFailure(e.toString()));
    }
  }

  Future<void> _onLastFmDisconnectRequested(
    LastFmDisconnectRequested event,
    Emitter<LastFmState> emit,
  ) async {
    emit(const LastFmLoading());
    try {
      await _authRepository.disconnectLastFM();
      emit(const LastFmDisconnected());
    } catch (e) {
      emit(LastFmFailure(e.toString()));
    }
  }
}
