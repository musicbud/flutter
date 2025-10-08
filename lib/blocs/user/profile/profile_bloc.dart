import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../domain/repositories/user_profile_repository.dart';
import '../../../models/user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final UserProfileRepository _userProfileRepository;

  ProfileBloc({
    required UserRepository userRepository,
    required UserProfileRepository userProfileRepository,
  }) : _userRepository = userRepository,
       _userProfileRepository = userProfileRepository,
       super(ProfileInitial()) {
    // Profile operations
    on<GetProfile>(_onGetProfile);
    on<BudProfileRequested>(_onBudProfileRequested);
    on<UpdateProfile>(_onUpdateProfile);
    on<SyncLikes>(_onSyncLikes);

    // Liked items
    on<LikedArtistsRequested>(_onLikedArtistsRequested);
    on<LikedTracksRequested>(_onLikedTracksRequested);
    on<LikedAlbumsRequested>(_onLikedAlbumsRequested);
    on<LikedGenresRequested>(_onLikedGenresRequested);

    // Top items
    on<TopArtistsRequested>(_onTopArtistsRequested);
    on<TopTracksRequested>(_onTopTracksRequested);
    on<TopGenresRequested>(_onTopGenresRequested);
    on<TopAnimeRequested>(_onTopAnimeRequested);
    on<TopMangaRequested>(_onTopMangaRequested);
  }

  Future<void> _onGetProfile(
    GetProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final profile = await _userProfileRepository.getMyProfile(
        service: event.service,
        token: event.token,
      );
      emit(ProfileLoaded(profile));
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
  }

  Future<void> _onBudProfileRequested(
    BudProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final profile = await _userRepository.getBudProfile(event.username);
      emit(BudProfileLoaded(profile));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final updateRequest = UserProfileUpdateRequest(
        bio: event.bio,
        firstName: event.displayName?.split(' ').first,
        lastName: event.displayName != null && event.displayName!.split(' ').length > 1
            ? event.displayName!.split(' ').skip(1).join(' ')
            : null,
      );
      final profile = await _userProfileRepository.updateProfile(updateRequest);
      emit(ProfileUpdated(profile));
    } catch (error) {
      emit(ProfileUpdateError(error.toString()));
    }
  }

  Future<void> _onSyncLikes(
    SyncLikes event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await _userProfileRepository.updateLikes({});
      emit(LikesSynced());
    } catch (error) {
      emit(LikesSyncError(error.toString()));
    }
  }

  Future<void> _onLikedArtistsRequested(
    LikedArtistsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final artists = await _userRepository.getLikedArtists();
      emit(LikedArtistsLoaded(artists));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }

  Future<void> _onLikedTracksRequested(
    LikedTracksRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final tracks = await _userRepository.getLikedTracks();
      emit(LikedTracksLoaded(tracks));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }

  Future<void> _onLikedAlbumsRequested(
    LikedAlbumsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final albums = await _userRepository.getLikedAlbums();
      emit(LikedAlbumsLoaded(albums));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }

  Future<void> _onLikedGenresRequested(
    LikedGenresRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final genres = await _userRepository.getLikedGenres();
      emit(LikedGenresLoaded(genres));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }

  Future<void> _onTopArtistsRequested(
    TopArtistsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final artists = await _userRepository.getTopArtists();
      emit(TopArtistsLoaded(artists));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }

  Future<void> _onTopTracksRequested(
    TopTracksRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final tracks = await _userRepository.getTopTracks();
      emit(TopTracksLoaded(tracks));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }

  Future<void> _onTopGenresRequested(
    TopGenresRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final genres = await _userRepository.getTopGenres();
      emit(TopGenresLoaded(genres));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }

  Future<void> _onTopAnimeRequested(
    TopAnimeRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final anime = await _userRepository.getTopAnime();
      emit(TopAnimeLoaded(anime));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }

  Future<void> _onTopMangaRequested(
    TopMangaRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final manga = await _userRepository.getTopManga();
      emit(TopMangaLoaded(manga));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }
}
