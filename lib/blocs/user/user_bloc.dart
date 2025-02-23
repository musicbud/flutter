import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitial()) {
    on<LoadMyProfile>(_onLoadMyProfile);
    on<LoadBudProfile>(_onLoadBudProfile);
    on<UpdateMyProfile>(_onUpdateMyProfile);
    on<LoadLikedItems>(_onLoadLikedItems);
    on<LoadTopItems>(_onLoadTopItems);
    on<SaveLocation>(_onSaveLocation);
    on<LoadPlayedTracks>(_onLoadPlayedTracks);
    on<UpdateToken>(_onUpdateToken);
  }

  Future<void> _onLoadMyProfile(
    LoadMyProfile event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final profile = await _userRepository.getUserProfile();
      emit(ProfileLoaded(profile));
    } catch (error) {
      debugPrint(error.toString());
      emit(UserError(error.toString()));
    }
  }

  Future<void> _onLoadBudProfile(
    LoadBudProfile event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final profile = await _userRepository.getBudProfile(event.username);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateMyProfile(
    UpdateMyProfile event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _userRepository.updateMyProfile(event.profile);
      emit(ProfileLoaded(event.profile));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadLikedItems(
    LoadLikedItems event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
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
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadTopItems(
    LoadTopItems event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
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
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onSaveLocation(
    SaveLocation event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _userRepository.saveLocation(event.latitude, event.longitude);
      final playedTracks = await _userRepository.getPlayedTracksWithLocation();
      emit(PlayedTracksLoaded(playedTracks));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadPlayedTracks(
    LoadPlayedTracks event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final playedTracks = await _userRepository.getPlayedTracks();
      emit(PlayedTracksLoaded(playedTracks));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onUpdateToken(
    UpdateToken event,
    Emitter<UserState> emit,
  ) async {
    _userRepository.updateToken(event.token);
    add(LoadMyProfile());
  }
}
