import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/user_profile_repository.dart';
import '../../../domain/repositories/content_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../models/user_profile.dart';
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
    on<GetProfile>(_onGetProfile);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileAvatarUpdateRequested>(_onProfileAvatarUpdateRequested);
    on<ProfileAuthenticationChecked>(_onProfileAuthenticationChecked);
    on<ProfileLogoutRequested>(_onProfileLogoutRequested);
    on<ProfileTopItemsRequested>(_onProfileTopItemsRequested);
    on<ProfileLikedItemsRequested>(_onProfileLikedItemsRequested);
    on<ProfileBudsRequested>(_onProfileBudsRequested);
    on<ProfileConnectedServicesRequested>(_onProfileConnectedServicesRequested);
    
    // New specific handlers
    on<TopTracksRequested>(_onTopTracksRequested);
    on<TopArtistsRequested>(_onTopArtistsRequested);
    on<TopGenresRequested>(_onTopGenresRequested);
    on<LikedTracksRequested>(_onLikedTracksRequested);
    on<LikedArtistsRequested>(_onLikedArtistsRequested);
    on<LikedGenresRequested>(_onLikedGenresRequested);
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
    emit(const ProfileFailure(error: 'Avatar update not implemented'));
  }

  Future<void> _onProfileAuthenticationChecked(
    ProfileAuthenticationChecked event,
    Emitter<ProfileState> emit,
  ) async {
    // TODO: Implement authentication check using appropriate repository
    emit(const ProfileAuthenticationStatus(isAuthenticated: true));
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

  Future<void> _onGetProfile(
    GetProfile event,
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

  Future<void> _onTopTracksRequested(
    TopTracksRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final tracks = await contentRepository.getTopItems('tracks');
      emit(TopTracksLoaded(tracks: tracks));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onTopArtistsRequested(
    TopArtistsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final artists = await contentRepository.getTopItems('artists');
      emit(TopArtistsLoaded(artists: artists));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onTopGenresRequested(
    TopGenresRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final genres = await contentRepository.getTopItems('genres');
      emit(TopGenresLoaded(genres: genres));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onLikedTracksRequested(
    LikedTracksRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final tracks = await contentRepository.getLikedItems('tracks');
      emit(LikedTracksLoaded(tracks: tracks));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onLikedArtistsRequested(
    LikedArtistsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final artists = await contentRepository.getLikedItems('artists');
      emit(LikedArtistsLoaded(artists: artists));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onLikedGenresRequested(
    LikedGenresRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final genres = await contentRepository.getLikedItems('genres');
      emit(LikedGenresLoaded(genres: genres));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

}
