import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user_profile.dart';
import '../../models/track.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/anime.dart';
import '../../models/manga.dart';

// Events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyProfile extends UserEvent {}

class LoadBudProfile extends UserEvent {
  final String username;

  const LoadBudProfile(this.username);

  @override
  List<Object?> get props => [username];
}

class UpdateMyProfile extends UserEvent {
  final UserProfile profile;

  const UpdateMyProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class LoadLikedItems extends UserEvent {}

class LoadTopItems extends UserEvent {}

class SaveLocation extends UserEvent {
  final double latitude;
  final double longitude;

  const SaveLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class LoadPlayedTracks extends UserEvent {}

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class ProfileLoaded extends UserState {
  final UserProfile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class LikedItemsLoaded extends UserState {
  final List<Artist> likedArtists;
  final List<Track> likedTracks;
  final List<Album> likedAlbums;
  final List<Genre> likedGenres;

  const LikedItemsLoaded({
    required this.likedArtists,
    required this.likedTracks,
    required this.likedAlbums,
    required this.likedGenres,
  });

  @override
  List<Object?> get props => [
        likedArtists,
        likedTracks,
        likedAlbums,
        likedGenres,
      ];
}

class TopItemsLoaded extends UserState {
  final List<Artist> topArtists;
  final List<Track> topTracks;
  final List<Genre> topGenres;
  final List<Anime> topAnime;
  final List<Manga> topManga;

  const TopItemsLoaded({
    required this.topArtists,
    required this.topTracks,
    required this.topGenres,
    required this.topAnime,
    required this.topManga,
  });

  @override
  List<Object?> get props => [
        topArtists,
        topTracks,
        topGenres,
        topAnime,
        topManga,
      ];
}

class PlayedTracksLoaded extends UserState {
  final List<Track> playedTracks;

  const PlayedTracksLoaded(this.playedTracks);

  @override
  List<Object?> get props => [playedTracks];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
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
  }

  Future<void> _onLoadMyProfile(
    LoadMyProfile event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final profile = await _userRepository.getMyProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(UserError(e.toString()));
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
}
