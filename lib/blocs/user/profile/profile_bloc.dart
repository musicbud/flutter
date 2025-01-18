import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;

  ProfileBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ProfileInitial()) {
    // Profile operations
    on<MyProfileRequested>(_onMyProfileRequested);
    on<BudProfileRequested>(_onBudProfileRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<UpdateLikesRequested>(_onUpdateLikesRequested);

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

  Future<void> _onMyProfileRequested(
    MyProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final profile = await _userRepository.getMyProfile();
      emit(MyProfileLoaded(profile));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
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

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await _userRepository.updateMyProfile(event.profile);
      emit(ProfileUpdateSuccess());
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }

  Future<void> _onUpdateLikesRequested(
    UpdateLikesRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await _userRepository.updateMyLikes();
      emit(LikesUpdateSuccess());
    } catch (error) {
      emit(ProfileFailure(error.toString()));
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
