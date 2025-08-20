import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/user_repository.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final UserRepository _userRepository;

  ServiceBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ServiceInitial()) {
    // Spotify
    on<SpotifyAuthUrlRequested>(_onSpotifyAuthUrlRequested);
    on<SpotifyConnectRequested>(_onSpotifyConnectRequested);
    on<SpotifyDisconnectRequested>(_onSpotifyDisconnectRequested);

    // YouTube Music
    on<YTMusicAuthUrlRequested>(_onYTMusicAuthUrlRequested);
    on<YTMusicConnectRequested>(_onYTMusicConnectRequested);
    on<YTMusicDisconnectRequested>(_onYTMusicDisconnectRequested);

    // MyAnimeList
    on<MALAuthUrlRequested>(_onMALAuthUrlRequested);
    on<MALConnectRequested>(_onMALConnectRequested);
    on<MALDisconnectRequested>(_onMALDisconnectRequested);

    // LastFM
    on<LastFMAuthUrlRequested>(_onLastFMAuthUrlRequested);
    on<LastFMConnectRequested>(_onLastFMConnectRequested);
    on<LastFMDisconnectRequested>(_onLastFMDisconnectRequested);
  }

  // Spotify handlers
  Future<void> _onSpotifyAuthUrlRequested(
    SpotifyAuthUrlRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      final url = await _userRepository.getSpotifyAuthUrl();
      emit(SpotifyAuthUrlLoaded(url));
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  Future<void> _onSpotifyConnectRequested(
    SpotifyConnectRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      await _userRepository.connectSpotify(event.code);
      emit(SpotifyConnected());
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  Future<void> _onSpotifyDisconnectRequested(
    SpotifyDisconnectRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      await _userRepository.disconnectSpotify();
      emit(SpotifyDisconnected());
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  // YouTube Music handlers
  Future<void> _onYTMusicAuthUrlRequested(
    YTMusicAuthUrlRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      final url = await _userRepository.getYTMusicAuthUrl();
      emit(YTMusicAuthUrlLoaded(url));
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  Future<void> _onYTMusicConnectRequested(
    YTMusicConnectRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      await _userRepository.connectYTMusic(event.code);
      emit(YTMusicConnected());
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  Future<void> _onYTMusicDisconnectRequested(
    YTMusicDisconnectRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      await _userRepository.disconnectYTMusic();
      emit(YTMusicDisconnected());
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  // MyAnimeList handlers
  Future<void> _onMALAuthUrlRequested(
    MALAuthUrlRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      final url = await _userRepository.getMALAuthUrl();
      emit(MALAuthUrlLoaded(url));
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  Future<void> _onMALConnectRequested(
    MALConnectRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      await _userRepository.connectMAL(event.code);
      emit(MALConnected());
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  Future<void> _onMALDisconnectRequested(
    MALDisconnectRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      await _userRepository.disconnectMAL();
      emit(MALDisconnected());
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  // LastFM handlers
  Future<void> _onLastFMAuthUrlRequested(
    LastFMAuthUrlRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      final url = await _userRepository.getLastFMAuthUrl();
      emit(LastFMAuthUrlLoaded(url));
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  Future<void> _onLastFMConnectRequested(
    LastFMConnectRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      await _userRepository.connectLastFM(event.code);
      emit(LastFMConnected());
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  Future<void> _onLastFMDisconnectRequested(
    LastFMDisconnectRequested event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceLoading());
      await _userRepository.disconnectLastFM();
      emit(LastFMDisconnected());
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }
}
