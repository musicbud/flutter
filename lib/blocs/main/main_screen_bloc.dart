import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'main_screen_event.dart';
import 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final ProfileRepository _profileRepository;

  MainScreenBloc({
    required ProfileRepository profileRepository,
  })  : _profileRepository = profileRepository,
        super(MainScreenInitial()) {
    on<MainScreenInitialized>(_onMainScreenInitialized);
    on<MainScreenAuthStatusChecked>(_onMainScreenAuthStatusChecked);
    on<MainScreenRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onMainScreenInitialized(
    MainScreenInitialized event,
    Emitter<MainScreenState> emit,
  ) async {
    try {
      final profile = await _profileRepository.getMyProfile();
      emit(MainScreenAuthenticated(
        username: profile.username,
        userProfile: profile.toJson(),
      ));
    } catch (error) {
      emit(MainScreenUnauthenticated());
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
    emit(MainScreenLoading());
    try {
      final profile = await _profileRepository.getMyProfile();
      emit(MainScreenAuthenticated(
        username: profile.username,
        userProfile: profile.toJson(),
      ));
    } catch (e) {
      emit(MainScreenFailure(e.toString()));
    }
  }

  Future<void> _checkAuthStatus(Emitter<MainScreenState> emit) async {
    try {
      emit(MainScreenLoading());

      // Get user profile
      final userProfile = await _profileRepository.getMyProfile();
      emit(MainScreenAuthenticated(
        username: userProfile.username,
        userProfile: userProfile.toJson(),
      ));
    } catch (error) {
      emit(MainScreenUnauthenticated());
    }
  }
}
