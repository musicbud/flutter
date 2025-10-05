import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'launcher_event.dart';
import 'launcher_state.dart';

class LauncherBloc extends Bloc<LauncherEvent, LauncherState> {
  final AuthRepository _authRepository;

  LauncherBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(LauncherInitial()) {
    on<LauncherAuthStatusChecked>(_onLauncherAuthStatusChecked);
    on<LauncherNavigateToSignup>(_onLauncherNavigateToSignup);
    on<LauncherNavigateToLogin>(_onLauncherNavigateToLogin);
    on<LauncherNavigateToHome>(_onLauncherNavigateToHome);
  }

  Future<void> _onLauncherAuthStatusChecked(
    LauncherAuthStatusChecked event,
    Emitter<LauncherState> emit,
  ) async {
    emit(LauncherLoading());
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      if (isAuthenticated) {
        emit(LauncherAuthenticated());
      } else {
        emit(LauncherUnauthenticated());
      }
    } catch (e) {
      emit(LauncherFailure(e.toString()));
    }
  }

  void _onLauncherNavigateToSignup(
    LauncherNavigateToSignup event,
    Emitter<LauncherState> emit,
  ) {
    emit(LauncherNavigatingToSignup());
  }

  void _onLauncherNavigateToLogin(
    LauncherNavigateToLogin event,
    Emitter<LauncherState> emit,
  ) {
    emit(LauncherNavigatingToLogin());
  }

  void _onLauncherNavigateToHome(
    LauncherNavigateToHome event,
    Emitter<LauncherState> emit,
  ) {
    emit(LauncherNavigatingToHome());
  }
}
