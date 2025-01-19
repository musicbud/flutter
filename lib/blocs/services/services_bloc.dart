import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'services_event.dart';
import 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final AuthRepository _authRepository;

  ServicesBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ServicesInitial()) {
    on<ServicesStatusRequested>(_onServicesStatusRequested);
    on<ServiceAuthUrlRequested>(_onServiceAuthUrlRequested);
    on<ServiceTokenSubmitted>(_onServiceTokenSubmitted);
    on<ServiceDisconnectRequested>(_onServiceDisconnectRequested);
  }

  Future<void> _onServicesStatusRequested(
    ServicesStatusRequested event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      final services = await _authRepository.getConnectedServices();
      emit(ServicesStatusLoaded(services));
    } catch (e) {
      emit(ServicesFailure(e.toString()));
    }
  }

  Future<void> _onServiceAuthUrlRequested(
    ServiceAuthUrlRequested event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      String url;
      switch (event.service) {
        case 'spotify':
          url = await _authRepository.getSpotifyAuthUrl();
          break;
        case 'ytmusic':
          url = await _authRepository.getYTMusicAuthUrl();
          break;
        case 'lastfm':
          url = await _authRepository.getLastFMAuthUrl();
          break;
        case 'mal':
          url = await _authRepository.getMALAuthUrl();
          break;
        default:
          throw Exception('Unsupported service: ${event.service}');
      }
      emit(ServiceAuthUrlLoaded(url: url, service: event.service));
    } catch (e) {
      emit(ServicesFailure(e.toString()));
    }
  }

  Future<void> _onServiceTokenSubmitted(
    ServiceTokenSubmitted event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      switch (event.service) {
        case 'spotify':
          await _authRepository.connectSpotify(event.token);
          break;
        case 'ytmusic':
          await _authRepository.connectYTMusic(event.token);
          break;
        case 'mal':
          await _authRepository.connectMAL(event.token);
          break;
        case 'lastfm':
          await _authRepository.connectLastFM(event.token);
          break;
      }
      final services = await _authRepository.getConnectedServices();
      emit(ServicesStatusLoaded(services));
    } catch (e) {
      emit(ServicesFailure(e.toString()));
    }
  }

  Future<void> _onServiceDisconnectRequested(
    ServiceDisconnectRequested event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      Map<String, dynamic> data;
      switch (event.service) {
        case 'spotify':
          data = await _authRepository.disconnectSpotify();
          break;
        case 'ytmusic':
          data = await _authRepository.disconnectYTMusic();
          break;
        case 'lastfm':
          data = await _authRepository.disconnectLastFM();
          break;
        case 'mal':
          data = await _authRepository.disconnectMAL();
          break;
        default:
          throw Exception('Unsupported service: ${event.service}');
      }
      emit(ServiceDisconnected(service: event.service, data: data));
    } catch (e) {
      emit(ServicesFailure(e.toString()));
    }
  }
}
