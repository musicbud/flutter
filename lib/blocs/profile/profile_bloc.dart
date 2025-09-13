import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/bud_repository.dart';
import '../../domain/models/bud_match.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final ContentRepository contentRepository;
  final BudRepository budRepository;

  ProfileBloc({
    required this.profileRepository,
    required this.contentRepository,
    required this.budRepository,
  }) : super(const ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileAvatarUpdateRequested>(_onProfileAvatarUpdateRequested);
    on<ProfileAuthenticationChecked>(_onProfileAuthenticationChecked);
    on<ProfileLogoutRequested>(_onProfileLogoutRequested);
    on<ProfileTopItemsRequested>(_onProfileTopItemsRequested);
    on<ProfileLikedItemsRequested>(_onProfileLikedItemsRequested);
    on<ProfileBudsRequested>(_onProfileBudsRequested);
    on<ProfileConnectedServicesRequested>(_onProfileConnectedServicesRequested);
    on<ProfileRefreshRequested>(_onProfileRefreshRequested);
    on<ProfileStatsRequested>(_onProfileStatsRequested);
    on<ProfilePreferencesRequested>(_onProfilePreferencesRequested);
  }

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(const ProfileLoading());
      final profile = await profileRepository.getUserProfile();
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await profileRepository.updateProfile(event.profileData);
      final profile = await profileRepository.getUserProfile();
      emit(ProfileUpdateSuccess(profile: profile));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileAvatarUpdateRequested(
    ProfileAvatarUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final avatarUrl = await profileRepository.updateAvatar(event.imageFile);
      emit(ProfileAvatarUpdateSuccess(avatarUrl: avatarUrl));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileAuthenticationChecked(
    ProfileAuthenticationChecked event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final isAuthenticated = await profileRepository.isAuthenticated();
      emit(ProfileAuthenticationStatus(isAuthenticated: isAuthenticated));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await profileRepository.logout();
      emit(const ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileTopItemsRequested(
    ProfileTopItemsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final items = await contentRepository.getTopItems(event.category);
      emit(ProfileTopItemsLoaded(items: items, category: event.category));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileLikedItemsRequested(
    ProfileLikedItemsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final items = await contentRepository.getLikedItems(event.category);
      emit(ProfileLikedItemsLoaded(items: items, category: event.category));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileBudsRequested(
    ProfileBudsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final buds = await _getBudsByCategory(event.category);
      emit(ProfileBudsLoaded(buds: buds, category: event.category));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileConnectedServicesRequested(
    ProfileConnectedServicesRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final services = await profileRepository.getConnectedServices();
      emit(ProfileConnectedServicesLoaded(services: services));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final profile = await profileRepository.getUserProfile();
      final services = await profileRepository.getConnectedServices();
      emit(ProfileLoaded(profile: profile, services: services));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileStatsRequested(
    ProfileStatsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // This would need to be implemented in the repository
      final stats = <String, dynamic>{
        'totalTracks': 0,
        'totalArtists': 0,
        'totalGenres': 0,
        'totalBuds': 0,
      };
      emit(ProfileStatsLoaded(stats: stats));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfilePreferencesRequested(
    ProfilePreferencesRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // This would need to be implemented in the repository
      final preferences = <String, dynamic>{
        'notifications': true,
        'privacy': 'public',
        'language': 'en',
      };
      emit(ProfilePreferencesLoaded(preferences: preferences));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<List<BudMatch>> _getBudsByCategory(String category) async {
    switch (category) {
      case 'liked/artists':
        return await budRepository.getBudsByLikedArtists();
      case 'liked/tracks':
        return await budRepository.getBudsByLikedTracks();
      case 'liked/genres':
        return await budRepository.getBudsByLikedGenres();
      case 'top/artists':
        return await budRepository.getBudsByTopArtists();
      case 'top/tracks':
        return await budRepository.getBudsByTopTracks();
      case 'top/genres':
        return await budRepository.getBudsByTopGenres();
      default:
        throw Exception('Invalid category: $category');
    }
  }
}
