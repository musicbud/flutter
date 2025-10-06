import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/user_profile_repository.dart';
import '../../../domain/repositories/content_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../models/bud_match.dart';
import '../../../models/user_profile.dart';
import '../../../models/parent_user.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserProfileRepository userProfileRepository;
  final ContentRepository contentRepository;
  final UserRepository userRepository;

  ProfileBloc({
    required this.userProfileRepository,
    required this.contentRepository,
    required this.userRepository,
  }) : super(ProfileInitial()) {
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
      emit(ProfileLoading());
      final profile = await userRepository.getUserProfile();
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
      final updateRequest = UserProfileUpdateRequest(
        firstName: event.profileData['first_name'],
        lastName: event.profileData['last_name'],
        birthday: event.profileData['birthday'] != null
            ? DateTime.tryParse(event.profileData['birthday'])
            : null,
        gender: event.profileData['gender'],
        interests: event.profileData['interests'] != null
            ? List<String>.from(event.profileData['interests'])
            : null,
        bio: event.profileData['bio'],
      );
      final profile = await userProfileRepository.updateProfile(updateRequest);
      emit(ProfileUpdateSuccess(profile: profile));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileAvatarUpdateRequested(
    ProfileAvatarUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // TODO: Implement avatar update using appropriate repository
    emit(ProfileFailure(error: 'Avatar update not implemented'));
  }

  Future<void> _onProfileAuthenticationChecked(
    ProfileAuthenticationChecked event,
    Emitter<ProfileState> emit,
  ) async {
    // TODO: Implement authentication check using appropriate repository
    emit(ProfileAuthenticationStatus(isAuthenticated: true));
  }

  Future<void> _onProfileLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // TODO: Implement logout using appropriate repository
    emit(ProfileLogoutSuccess());
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
    // TODO: Implement bud matching using appropriate repository
    emit(ProfileBudsLoaded(buds: const [], category: event.category));
  }

  Future<void> _onProfileConnectedServicesRequested(
    ProfileConnectedServicesRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(const ProfileConnectedServicesLoaded(services: []));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

}
