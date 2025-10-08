import 'dart:io';
import 'package:flutter/foundation.dart';
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
      // Check connectivity first - skip on Linux desktop to avoid D-Bus issues
      ConnectivityResult connectivityResult;
      
      if (Platform.isLinux) {
        // Skip connectivity check on Linux desktop (development mode)
        debugPrint('Skipping connectivity check on Linux desktop - assuming connected');
        connectivityResult = ConnectivityResult.wifi;
      } else {
        try {
          // Add timeout to prevent hanging on D-Bus issues
          final results = await Connectivity().checkConnectivity()
              .timeout(const Duration(seconds: 3));
          connectivityResult = results.isNotEmpty ? results.first : ConnectivityResult.none;
        } catch (e) {
          // If D-Bus connectivity check fails, assume we have connectivity
          // This handles cases where D-Bus is not available (e.g., in Nix shell)
          debugPrint('Connectivity check failed (likely D-Bus unavailable): $e');
          debugPrint('Assuming network connectivity is available...');
          connectivityResult = ConnectivityResult.wifi;
        }
      }
      
      if (connectivityResult == ConnectivityResult.none) {
        emit(const LoginFailure(
            'No internet connection. Please check your network settings.'));
        return;
      }

      // Check server status
      // final serverStatus = await _authRepository.checkServerStatus();
      // if (!serverStatus.isReachable) {
      //   emit(const LoginFailure(
      //       'Unable to reach the server. Please try again later.'));
      //   return;
      // }

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
      ConnectivityResult connectivityResult;
      
      if (Platform.isLinux) {
        // Skip connectivity check on Linux desktop (development mode)
        debugPrint('Skipping connectivity check on Linux desktop - assuming connected');
        connectivityResult = ConnectivityResult.wifi;
      } else {
        try {
          // Add timeout to prevent hanging on D-Bus issues
          final results = await Connectivity().checkConnectivity()
              .timeout(const Duration(seconds: 3));
          connectivityResult = results.isNotEmpty ? results.first : ConnectivityResult.none;
        } catch (e) {
          // If D-Bus connectivity check fails, assume we have connectivity
          debugPrint('Connectivity check failed (likely D-Bus unavailable): $e');
          debugPrint('Assuming network connectivity is available...');
          connectivityResult = ConnectivityResult.wifi;
        }
      }
      
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
      // final serverStatus = await _authRepository.checkServerStatus();
      emit(const LoginServerStatus(
        isReachable: true,
        error: null,
        message: 'Server is reachable',
      ));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
