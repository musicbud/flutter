import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({required UserRepository userRepository}) 
      : _userRepository = userRepository,
        super(UserInitial()) {
    on<LoadMyProfile>(_onLoadMyProfile);
    on<LoadLikedItems>(_onLoadLikedItems);
    on<LoadTopItems>(_onLoadTopItems);
    on<LoadPlayedTracks>(_onLoadPlayedTracks);
    on<UpdateMyProfile>(_onUpdateMyProfile);
  }

  Future<void> _onLoadLikedItems(
    LoadLikedItems event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      // Make real API calls through repository
      final likedArtists = await _userRepository.getLikedArtists();
      final likedTracks = await _userRepository.getLikedTracks();
      final likedAlbums = await _userRepository.getLikedAlbums();
      final likedGenres = await _userRepository.getLikedGenres();

      emit(LikedItemsLoaded(
        likedArtists: likedArtists,
        likedTracks: likedTracks,
        likedAlbums: likedAlbums,
        likedGenres: likedGenres,
      ));
    } catch (e) {
      emit(UserError('Failed to load liked items: $e'));
    }
  }

  Future<void> _onLoadTopItems(
    LoadTopItems event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      // Make real API calls through repository
      final topArtists = await _userRepository.getTopArtists();
      final topTracks = await _userRepository.getTopTracks();
      final topGenres = await _userRepository.getTopGenres();
      final topAnime = await _userRepository.getTopAnime();
      final topManga = await _userRepository.getTopManga();

      emit(TopItemsLoaded(
        topArtists: topArtists,
        topTracks: topTracks,
        topGenres: topGenres,
        topAnime: topAnime,
        topManga: topManga,
      ));
    } catch (e) {
      emit(UserError('Failed to load top items: $e'));
    }
  }

  Future<void> _onLoadMyProfile(
    LoadMyProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      // Make real API call through repository
      final profile = await _userRepository.getUserProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(UserError('Failed to load user profile: $e'));
    }
  }

  Future<void> _onLoadPlayedTracks(
    LoadPlayedTracks event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      // Make real API call through repository
      final playedTracks = await _userRepository.getPlayedTracks();
      emit(PlayedTracksLoaded(playedTracks));
    } catch (e) {
      emit(UserError('Failed to load played tracks: $e'));
    }
  }

  Future<void> _onUpdateMyProfile(
    UpdateMyProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    
    try {
      // Make real API call through repository to update profile
      await _userRepository.updateMyProfile(event.profile);
      // Return the updated profile since the method doesn't return anything
      emit(ProfileLoaded(event.profile));
    } catch (e) {
      emit(UserError('Failed to update profile: $e'));
    }
  }
}