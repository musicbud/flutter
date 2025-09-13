import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'main_screen_event.dart';
import 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final ProfileRepository _profileRepository;

  MainScreenBloc({
    required ProfileRepository profileRepository,
  })  : _profileRepository = profileRepository,
        super(const MainScreenInitial()) {
    on<MainScreenInitialized>(_onMainScreenInitialized);
    on<MainScreenAuthStatusChecked>(_onMainScreenAuthStatusChecked);
    on<MainScreenRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onMainScreenInitialized(
    MainScreenInitialized event,
    Emitter<MainScreenState> emit,
  ) async {
    try {
      emit(const MainScreenLoading());

      // Check if we have a token first
      final profile = await _profileRepository.getMyProfile();
      emit(MainScreenAuthenticated(
        username: profile.username,
        userProfile: profile.toJson(),
      ));
    } catch (error) {
      if (error.toString().contains('401') ||
          error.toString().contains('unauthorized') ||
          error.toString().contains('token') ||
          error.toString().contains('authentication')) {
        emit(const MainScreenUnauthenticated());
      } else {
        // For other errors, still try to show the main screen with limited functionality
        emit(MainScreenAuthenticated(
          username: 'User',
          userProfile: const {'username': 'User', 'id': 'user'},
        ));
      }
    }
  }

  Future<void> _onMainScreenAuthStatusChecked(
    MainScreenAuthStatusChecked event,
    Emitter<MainScreenState> emit,
  ) async {
    await _checkAuthStatus(emit);
  }

  Future<void> _onRefreshRequested(
    MainScreenRefreshRequested event,
    Emitter<MainScreenState> emit,
  ) async {
    emit(const MainScreenLoading());
    try {
      final profile = await _profileRepository.getMyProfile();
      emit(MainScreenAuthenticated(
        username: profile.username,
        userProfile: profile.toJson(),
      ));
    } catch (error) {
      if (error.toString().contains('401') ||
          error.toString().contains('unauthorized')) {
        emit(const MainScreenUnauthenticated());
      } else {
        emit(MainScreenFailure(error.toString()));
      }
    }
  }

  Future<void> _checkAuthStatus(Emitter<MainScreenState> emit) async {
    try {
      final profile = await _profileRepository.getMyProfile();
      emit(MainScreenAuthenticated(
        username: profile.username,
        userProfile: profile.toJson(),
      ));
    } catch (error) {
      if (error.toString().contains('401') ||
          error.toString().contains('unauthorized')) {
        emit(const MainScreenUnauthenticated());
      } else {
        emit(MainScreenFailure(error.toString()));
      }
    }
  }
}
