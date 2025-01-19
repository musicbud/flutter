import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const RegisterRequested({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

class LogoutRequested extends AuthEvent {}

class TokenRefreshRequested extends AuthEvent {}

class ConnectService extends AuthEvent {
  final String service;
  final String code;

  const ConnectService({required this.service, required this.code});

  @override
  List<Object?> get props => [service, code];
}

class DisconnectService extends AuthEvent {
  final String service;

  const DisconnectService(this.service);

  @override
  List<Object?> get props => [service];
}

class GetServiceAuthUrl extends AuthEvent {
  final String service;

  const GetServiceAuthUrl(this.service);

  @override
  List<Object?> get props => [service];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  final Map<String, bool> connectedServices;

  const Authenticated({
    required this.token,
    this.connectedServices = const {},
  });

  @override
  List<Object?> get props => [token, connectedServices];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class ServiceAuthUrlReceived extends AuthState {
  final String service;
  final String url;

  const ServiceAuthUrlReceived({
    required this.service,
    required this.url,
  });

  @override
  List<Object?> get props => [service, url];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
    on<ConnectService>(_onConnectService);
    on<DisconnectService>(_onDisconnectService);
    on<GetServiceAuthUrl>(_onGetServiceAuthUrl);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final result =
          await _authRepository.login(event.username, event.password);
      emit(Authenticated(token: result['token']));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final result = await _authRepository.register(
        event.username,
        event.email,
        event.password,
      );
      emit(Authenticated(token: result['token']));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      await _authRepository.logout();
      emit(Unauthenticated());
    } catch (e) {
      // Even if logout fails, we should still clear the local state
      emit(Unauthenticated());
    }
  }

  Future<void> _onTokenRefreshRequested(
    TokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final token = await _authRepository.refreshToken();
      emit(Authenticated(token: token));
    } catch (e) {
      // If token refresh fails, user needs to login again
      emit(Unauthenticated());
    }
  }

  Future<void> _onConnectService(
    ConnectService event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      switch (event.service) {
        case 'spotify':
          await _authRepository.connectSpotify(event.code);
          break;
        case 'ytmusic':
          await _authRepository.connectYTMusic(event.code);
          break;
        case 'mal':
          await _authRepository.connectMAL(event.code);
          break;
        case 'lastfm':
          await _authRepository.connectLastFM(event.code);
          break;
      }
      if (state is Authenticated) {
        final currentState = state as Authenticated;
        emit(currentState.copyWith(
          connectedServices: Map.from(currentState.connectedServices)
            ..[event.service] = true,
        ));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onDisconnectService(
    DisconnectService event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      switch (event.service) {
        case 'spotify':
          await _authRepository.disconnectSpotify();
          break;
        case 'ytmusic':
          await _authRepository.disconnectYTMusic();
          break;
        case 'mal':
          await _authRepository.disconnectMAL();
          break;
        case 'lastfm':
          await _authRepository.disconnectLastFM();
          break;
      }
      if (state is Authenticated) {
        final currentState = state as Authenticated;
        emit(currentState.copyWith(
          connectedServices: Map.from(currentState.connectedServices)
            ..[event.service] = false,
        ));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGetServiceAuthUrl(
    GetServiceAuthUrl event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      String url = '';
      switch (event.service) {
        case 'spotify':
          url = await _authRepository.getSpotifyAuthUrl();
          break;
        case 'ytmusic':
          url = await _authRepository.getYTMusicAuthUrl();
          break;
        case 'mal':
          url = await _authRepository.getMALAuthUrl();
          break;
        case 'lastfm':
          url = await _authRepository.getLastFMAuthUrl();
          break;
      }
      emit(ServiceAuthUrlReceived(service: event.service, url: url));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

extension on Authenticated {
  Authenticated copyWith({
    String? token,
    Map<String, bool>? connectedServices,
  }) {
    return Authenticated(
      token: token ?? this.token,
      connectedServices: connectedServices ?? this.connectedServices,
    );
  }
}
