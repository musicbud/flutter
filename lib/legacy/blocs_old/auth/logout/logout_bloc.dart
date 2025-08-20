import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRepository _authRepository;

  LogoutBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutInProgress());
    try {
      await _authRepository.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
