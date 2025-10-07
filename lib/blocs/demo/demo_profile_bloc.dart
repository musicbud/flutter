import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/demo_profile_repository.dart';
import 'demo_profile_event.dart';
import 'demo_profile_state.dart';

class DemoProfileBloc extends Bloc<DemoProfileEvent, DemoProfileState> {
  final DemoProfileRepository repository;
  StreamSubscription? _profileSubscription;
  StreamSubscription? _statsSubscription;

  DemoProfileBloc({required this.repository}) : super(const DemoProfileInitial()) {
    on<DemoProfileRequested>(_onProfileRequested);
    on<DemoProfileUpdated>(_onProfileUpdated);
    on<DemoPreferencesUpdated>(_onPreferencesUpdated);
    on<DemoInterestsUpdated>(_onInterestsUpdated);
    on<DemoPremiumToggled>(_onPremiumToggled);
    on<DemoBadgesUpdated>(_onBadgesUpdated);
    on<DemoStatsRequested>(_onStatsRequested);

    // Subscribe to profile updates
    _profileSubscription = repository.profileUpdates.listen(
      (profile) {
        // TODO: Handle profile updates
      },
    );

    // Subscribe to stats updates
    _statsSubscription = repository.statsUpdates.listen(
      (stats) {
        // TODO: Handle stats updates
      },
    );
  }

  Future<void> _onProfileRequested(
    DemoProfileRequested event,
    Emitter<DemoProfileState> emit,
  ) async {
    try {
      emit(const DemoProfileLoading());
      
      final profile = await repository.getProfile();
      final stats = await repository.getStats();
      
      emit(DemoProfileLoaded(
        profile: profile,
        stats: stats,
      ));
    } catch (e) {
      emit(DemoProfileError(e.toString()));
    }
  }

  Future<void> _onProfileUpdated(
    DemoProfileUpdated event,
    Emitter<DemoProfileState> emit,
  ) async {
    if (state is! DemoProfileLoaded) return;
    final currentState = state as DemoProfileLoaded;

    try {
      emit(DemoProfileUpdating(currentState.profile));
      
      final updatedProfile = await repository.updateProfile(event.data);
      
      emit(DemoProfileUpdateSuccess(
        profile: updatedProfile,
        message: 'Profile updated successfully',
      ));
      
      emit(currentState.copyWith(
        profile: updatedProfile,
        isEditing: false,
      ));
    } catch (e) {
      emit(DemoProfileError(e.toString()));
      emit(currentState);
    }
  }

  Future<void> _onPreferencesUpdated(
    DemoPreferencesUpdated event,
    Emitter<DemoProfileState> emit,
  ) async {
    if (state is! DemoProfileLoaded) return;
    final currentState = state as DemoProfileLoaded;

    try {
      await repository.updatePreferences(event.preferences);
      
      emit(currentState.copyWith(
        profile: currentState.profile.copyWith(
          preferences: event.preferences,
        ),
      ));
    } catch (e) {
      emit(DemoProfileError(e.toString()));
      emit(currentState);
    }
  }

  Future<void> _onInterestsUpdated(
    DemoInterestsUpdated event,
    Emitter<DemoProfileState> emit,
  ) async {
    if (state is! DemoProfileLoaded) return;
    final currentState = state as DemoProfileLoaded;

    try {
      await repository.updateInterests(event.interests);
      
      emit(currentState.copyWith(
        profile: currentState.profile.copyWith(
          interests: event.interests,
        ),
      ));
    } catch (e) {
      emit(DemoProfileError(e.toString()));
      emit(currentState);
    }
  }

  Future<void> _onPremiumToggled(
    DemoPremiumToggled event,
    Emitter<DemoProfileState> emit,
  ) async {
    if (state is! DemoProfileLoaded) return;
    final currentState = state as DemoProfileLoaded;

    try {
      await repository.togglePremium();
      
      emit(currentState.copyWith(
        profile: currentState.profile.copyWith(
          isPremium: !currentState.profile.isPremium,
        ),
      ));
    } catch (e) {
      emit(DemoProfileError(e.toString()));
      emit(currentState);
    }
  }

  Future<void> _onBadgesUpdated(
    DemoBadgesUpdated event,
    Emitter<DemoProfileState> emit,
  ) async {
    if (state is! DemoProfileLoaded) return;
    final currentState = state as DemoProfileLoaded;

    try {
      await repository.updateBadges(event.badges);
      
      emit(currentState.copyWith(
        profile: currentState.profile.copyWith(
          badges: event.badges,
        ),
      ));
    } catch (e) {
      emit(DemoProfileError(e.toString()));
      emit(currentState);
    }
  }

  Future<void> _onStatsRequested(
    DemoStatsRequested event,
    Emitter<DemoProfileState> emit,
  ) async {
    if (state is! DemoProfileLoaded) return;
    final currentState = state as DemoProfileLoaded;

    try {
      final stats = await repository.getStats();
      emit(currentState.copyWith(stats: stats));
    } catch (e) {
      emit(DemoProfileError(e.toString()));
      emit(currentState);
    }
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    _statsSubscription?.cancel();
    return super.close();
  }
}
