import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/bud_repository.dart';
import '../../domain/models/bud_match.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final ContentRepository _contentRepository;
  final BudRepository _budRepository;

  ProfileBloc({
    required ProfileRepository profileRepository,
    required ContentRepository contentRepository,
    required BudRepository budRepository,
  })  : _profileRepository = profileRepository,
        _contentRepository = contentRepository,
        _budRepository = budRepository,
        super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileAvatarUpdateRequested>(_onProfileAvatarUpdateRequested);
    on<ProfileAuthenticationChecked>(_onProfileAuthenticationChecked);
    on<ProfileLogoutRequested>(_onProfileLogoutRequested);
    on<ProfileTopItemsRequested>(_onProfileTopItemsRequested);
    on<ProfileLikedItemsRequested>(_onProfileLikedItemsRequested);
    on<ProfileBudsRequested>(_onProfileBudsRequested);
    on<ProfileConnectedServicesRequested>(_onProfileConnectedServicesRequested);
  }

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final profile = await _profileRepository.getUserProfile();
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
      await _profileRepository.updateProfile(event.profileData);
      final profile = await _profileRepository.getUserProfile();
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
      final avatarUrl = await _profileRepository.updateAvatar(event.imageFile);
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
      final isAuthenticated = await _profileRepository.isAuthenticated();
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
      await _profileRepository.logout();
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileTopItemsRequested(
    ProfileTopItemsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final items = await _contentRepository.getTopItems(event.category);
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
      final items = await _contentRepository.getLikedItems(event.category);
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
      final services = await _profileRepository.getConnectedServices();
      emit(ProfileConnectedServicesLoaded(services: services));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<List<BudMatch>> _getBudsByCategory(String category) async {
    switch (category) {
      case 'liked/artists':
        return await _budRepository.getBudsByLikedArtists();
      case 'liked/tracks':
        return await _budRepository.getBudsByLikedTracks();
      case 'liked/genres':
        return await _budRepository.getBudsByLikedGenres();
      case 'top/artists':
        return await _budRepository.getBudsByTopArtists();
      case 'top/tracks':
        return await _budRepository.getBudsByTopTracks();
      case 'top/genres':
        return await _budRepository.getBudsByTopGenres();
      default:
        throw Exception('Invalid category: $category');
    }
  }
}
