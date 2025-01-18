import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'lastfm_event.dart';
import 'lastfm_state.dart';

class LastFMBloc extends Bloc<LastFMEvent, LastFMState> {
  final AuthRepository _authRepository;

  LastFMBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LastFMInitial()) {
    on<LastFMAuthUrlRequested>(_onAuthUrlRequested);
    on<LastFMConnectRequested>(_onConnectRequested);
    on<LastFMDisconnectRequested>(_onDisconnectRequested);
  }

  Future<void> _onAuthUrlRequested(
    LastFMAuthUrlRequested event,
    Emitter<LastFMState> emit,
  ) async {
    emit(LastFMLoading());
    try {
      final url = await _authRepository.getLastFMAuthUrl();
      emit(LastFMAuthUrlLoaded(url));
    } catch (e) {
      emit(LastFMFailure(e.toString()));
    }
  }

  Future<void> _onConnectRequested(
    LastFMConnectRequested event,
    Emitter<LastFMState> emit,
  ) async {
    emit(LastFMLoading());
    try {
      await _authRepository.connectLastFM(event.code);
      emit(LastFMConnected());
    } catch (e) {
      emit(LastFMFailure(e.toString()));
    }
  }

  Future<void> _onDisconnectRequested(
    LastFMDisconnectRequested event,
    Emitter<LastFMState> emit,
  ) async {
    emit(LastFMLoading());
    try {
      await _authRepository.disconnectLastFM();
      emit(LastFMDisconnected());
    } catch (e) {
      emit(LastFMFailure(e.toString()));
    }
  }
}
