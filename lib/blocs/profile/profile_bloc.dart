import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/bud_repository.dart';
import '../../models/bud_match.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    emit(ProfileLoading());
    try {
      final profile = await _profileRepository.getUserProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.updateProfile(event.profileData);
      emit(ProfileUpdateSuccess());
      add(ProfileRequested()); // Refresh profile data
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileAvatarUpdateRequested(
    ProfileAvatarUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final avatarUrl = await _profileRepository.updateAvatar(event.imageFile);
      emit(ProfileAvatarUpdateSuccess(avatarUrl));
      add(ProfileRequested()); // Refresh profile data
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileAuthenticationChecked(
    ProfileAuthenticationChecked event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      emit(ProfileAuthenticationStatus(token != null));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileTopItemsRequested(
    ProfileTopItemsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final items = await _contentRepository.getTopItems(event.category);
      emit(ProfileTopItemsLoaded(event.category, items));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileLikedItemsRequested(
    ProfileLikedItemsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final items = await _contentRepository.getLikedItems(event.category);
      emit(ProfileLikedItemsLoaded(event.category, items));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileBudsRequested(
    ProfileBudsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final buds = await _getBudsByCategory(event.category);
      emit(ProfileBudsLoaded(event.category, buds));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileConnectedServicesRequested(
    ProfileConnectedServicesRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final services = await _profileRepository.getConnectedServices();
      emit(ProfileConnectedServicesLoaded(services));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<List<BudMatch>> _getBudsByCategory(String category) async {
    switch (category) {
      case 'liked/artists':
        final buds = await _budRepository.getBudsByLikedArtists();
        return buds
            .map((bud) => BudMatch(bud: bud, similarityScore: 0.0))
            .toList();
      case 'liked/tracks':
        final buds = await _budRepository.getBudsByLikedTracks();
        return buds
            .map((bud) => BudMatch(bud: bud, similarityScore: 0.0))
            .toList();
      case 'liked/genres':
        final buds = await _budRepository.getBudsByLikedGenres();
        return buds
            .map((bud) => BudMatch(bud: bud, similarityScore: 0.0))
            .toList();
      case 'top/artists':
        final buds = await _budRepository.getBudsByTopArtists();
        return buds
            .map((bud) => BudMatch(bud: bud, similarityScore: 0.0))
            .toList();
      case 'top/tracks':
        final buds = await _budRepository.getBudsByTopTracks();
        return buds
            .map((bud) => BudMatch(bud: bud, similarityScore: 0.0))
            .toList();
      case 'top/genres':
        final buds = await _budRepository.getBudsByTopGenres();
        return buds
            .map((bud) => BudMatch(bud: bud, similarityScore: 0.0))
            .toList();
      default:
        throw Exception('Invalid category: $category');
    }
  }
}
