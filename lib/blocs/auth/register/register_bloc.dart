import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;
  final Connectivity _connectivity = Connectivity();

  RegisterBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(RegisterInitial()) {
    on<RegisterConnectivityChecked>(_onConnectivityChecked);
    on<RegisterServerStatusChecked>(_onServerStatusChecked);
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onConnectivityChecked(
    RegisterConnectivityChecked event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final isConnected = connectivityResult != ConnectivityResult.none;
      emit(RegisterConnectivityStatus(isConnected));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  Future<void> _onServerStatusChecked(
    RegisterServerStatusChecked event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final status = await _authRepository.checkServerStatus();
      emit(RegisterServerStatus(
        isReachable: status.isReachable,
        error: status.error,
        message: status.message,
      ));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final data = await _authRepository.register(
        event.username,
        event.email,
        event.password,
      );
      emit(RegisterSuccess(data));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
