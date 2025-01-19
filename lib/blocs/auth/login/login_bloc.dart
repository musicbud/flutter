import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginConnectivityChecked>(_onLoginConnectivityChecked);
    on<LoginServerStatusChecked>(_onLoginServerStatusChecked);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      // Check connectivity first
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        emit(const LoginFailure(
            'No internet connection. Please check your network settings.'));
        return;
      }

      // Check server status
      final serverStatus = await _authRepository.checkServerStatus();
      if (!serverStatus.isReachable) {
        emit(const LoginFailure(
            'Unable to reach the server. Please try again later.'));
        return;
      }

      // Proceed with login
      final data = await _authRepository.login(
        event.username,
        event.password,
      );
      emit(LoginSuccess(data));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onLoginConnectivityChecked(
    LoginConnectivityChecked event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      emit(LoginConnectivityStatus(
        isConnected: connectivityResult != ConnectivityResult.none,
      ));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onLoginServerStatusChecked(
    LoginServerStatusChecked event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final serverStatus = await _authRepository.checkServerStatus();
      emit(LoginServerStatus(
        isReachable: serverStatus.isReachable,
        error: serverStatus.error,
        message: serverStatus.message,
      ));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
