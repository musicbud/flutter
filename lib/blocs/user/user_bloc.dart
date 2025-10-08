import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  UserBloc({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  }) : _userRepository = userRepository,
       _authRepository = authRepository,
       super(UserInitial()) {
    on<LoadMyProfile>(_onLoadMyProfile);
    on<LoadBudProfile>(_onLoadBudProfile);
    on<UpdateMyProfile>(_onUpdateMyProfile);
    on<LoadLikedItems>(_onLoadLikedItems);
    on<LoadTopItems>(_onLoadTopItems);
    on<SaveLocation>(_onSaveLocation);
    on<LoadPlayedTracks>(_onLoadPlayedTracks);
    on<UpdateToken>(_onUpdateToken);
    on<LoginRequest>(_onLoginRequest);
    on<RegisterRequest>(_onRegisterRequest);
    on<GetServiceLoginUrl>(_onGetServiceLoginUrl);
    on<ConnectService>(_onConnectService);
    on<RefreshSpotifyToken>(_onRefreshSpotifyToken);
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
      // Location saving is not supported by the API, so we'll just load played tracks
      final playedTracks = await _userRepository.getPlayedTracks();
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

  Future<void> _onLoginRequest(
    LoginRequest event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _authRepository.login(event.username, event.password);
      emit(LoginSuccess());
    } catch (error) {
      debugPrint(error.toString());
      emit(LoginFailure(error.toString()));
    }
  }

  Future<void> _onRegisterRequest(
    RegisterRequest event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _authRepository.register(event.username, event.email, event.password);
      emit(RegisterSuccess());
    } catch (error) {
      debugPrint(error.toString());
      emit(RegisterFailure(error.toString()));
    }
  }

  Future<void> _onGetServiceLoginUrl(
    GetServiceLoginUrl event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final url = await _authRepository.getServiceLoginUrl(event.service);
      emit(ServiceLoginUrlReceived(url));
    } catch (error) {
      debugPrint(error.toString());
      emit(ServiceLoginUrlError(error.toString()));
    }
  }

  Future<void> _onConnectService(
    ConnectService event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      switch (event.service) {
        case 'spotify':
          await _authRepository.connectSpotify(event.code);
          break;
        case 'ytmusic':
          await _authRepository.connectYTMusic(event.code);
          break;
        case 'lastfm':
          await _authRepository.connectLastFM(event.code);
          break;
        case 'mal':
          await _authRepository.connectMAL(event.code);
          break;
        default:
          throw Exception('Unsupported service: ${event.service}');
      }
      emit(ServiceConnected(event.service));
    } catch (error) {
      debugPrint(error.toString());
      emit(ServiceConnectionError(event.service, error.toString()));
    }
  }

  Future<void> _onRefreshSpotifyToken(
    RefreshSpotifyToken event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _authRepository.refreshSpotifyToken();
      emit(SpotifyTokenRefreshed());
    } catch (error) {
      debugPrint(error.toString());
      emit(SpotifyTokenRefreshError(error.toString()));
    }
  }
}
