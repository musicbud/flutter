import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'mal_event.dart';
import 'mal_state.dart';

class MALBloc extends Bloc<MALEvent, MALState> {
  final AuthRepository _authRepository;

  MALBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(MALInitial()) {
    on<MALAuthUrlRequested>(_onAuthUrlRequested);
    on<MALConnectRequested>(_onConnectRequested);
    on<MALDisconnectRequested>(_onDisconnectRequested);
  }

  Future<void> _onAuthUrlRequested(
    MALAuthUrlRequested event,
    Emitter<MALState> emit,
  ) async {
    emit(MALLoading());
    try {
      final url = await _authRepository.getMALAuthUrl();
      emit(MALAuthUrlLoaded(url));
    } catch (e) {
      emit(MALFailure(e.toString()));
    }
  }

  Future<void> _onConnectRequested(
    MALConnectRequested event,
    Emitter<MALState> emit,
  ) async {
    emit(MALLoading());
    try {
      await _authRepository.connectMAL(event.code);
      emit(MALConnected());
    } catch (e) {
      emit(MALFailure(e.toString()));
    }
  }

  Future<void> _onDisconnectRequested(
    MALDisconnectRequested event,
    Emitter<MALState> emit,
  ) async {
    emit(MALLoading());
    try {
      await _authRepository.disconnectMAL();
      emit(MALDisconnected());
    } catch (e) {
      emit(MALFailure(e.toString()));
    }
  }
}
