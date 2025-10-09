import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/discover_repository.dart';
import 'main_screen_event.dart';
import 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final ProfileRepository _profileRepository;
  final ContentRepository _contentRepository;
  final DiscoverRepository _discoverRepository;

  MainScreenBloc({
    required ProfileRepository profileRepository,
    required ContentRepository contentRepository,
    required DiscoverRepository discoverRepository,
  })  : _profileRepository = profileRepository,
        _contentRepository = contentRepository,
        _discoverRepository = discoverRepository,
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

      // Fetch user profile
      final profile = await _profileRepository.getMyProfile();

      // Fetch recent activity (played tracks)
      final recentActivity = await _contentRepository.getPlayedTracks();

      // Fetch featured content (trending tracks)
      final featuredContent = await _discoverRepository.getTrendingTracks();

      emit(MainScreenAuthenticated(
        username: profile.username,
        userProfile: profile.toJson(),
        recentActivity: recentActivity,
        featuredContent: featuredContent,
      ));
    } catch (error) {
      if (error.toString().contains('401') ||
          error.toString().contains('unauthorized') ||
          error.toString().contains('token') ||
          error.toString().contains('authentication')) {
        emit(const MainScreenUnauthenticated());
      } else {
        // For other errors, still try to show the main screen with limited functionality
        emit(const MainScreenAuthenticated(
          username: 'User',
          userProfile: {'username': 'User', 'id': 'user'},
          recentActivity: [],
          featuredContent: [],
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
      final recentActivity = await _contentRepository.getPlayedTracks();
      final featuredContent = await _discoverRepository.getTrendingTracks();

      emit(MainScreenAuthenticated(
        username: profile.username,
        userProfile: profile.toJson(),
        recentActivity: recentActivity,
        featuredContent: featuredContent,
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
      final recentActivity = await _contentRepository.getPlayedTracks();
      final featuredContent = await _discoverRepository.getTrendingTracks();

      emit(MainScreenAuthenticated(
        username: profile.username,
        userProfile: profile.toJson(),
        recentActivity: recentActivity,
        featuredContent: featuredContent,
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
