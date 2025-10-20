import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/providers/token_provider.dart';

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

class GetServiceAuthUrl extends AuthEvent {
  final String service;

  const GetServiceAuthUrl(this.service);

  @override
  List<Object?> get props => [service];
}

class RefreshServiceToken extends AuthEvent {
  final String service;

  const RefreshServiceToken(this.service);

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

class Unauthenticated extends AuthState {}

class AuthSuccess extends AuthState {
  const AuthSuccess();
}

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
  final TokenProvider _tokenProvider;

  AuthBloc({
    required AuthRepository authRepository,
    required TokenProvider tokenProvider,
  }) : _authRepository = authRepository,
       _tokenProvider = tokenProvider,
       super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
    on<ConnectService>(_onConnectService);
    on<GetServiceAuthUrl>(_onGetServiceAuthUrl);
    on<RefreshServiceToken>(_onRefreshServiceToken);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final result =
          await _authRepository.login(event.username, event.password);
      // Store tokens securely
      await _tokenProvider.updateTokens(
        result.accessToken, 
        result.refreshToken ?? '', // Use empty string if null
      );
      emit(Authenticated(token: result.accessToken));
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
      await _authRepository.register(
        event.username,
        event.email,
        event.password,
      );
      // For register, we don't get a token immediately, so we emit success without token
      emit(const AuthSuccess());
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
      // Clear stored tokens
      await _tokenProvider.clearTokens();
      emit(Unauthenticated());
    } catch (e) {
      // Even if logout fails, we should still clear the local state and tokens
      await _tokenProvider.clearTokens();
      emit(Unauthenticated());
    }
  }

  Future<void> _onTokenRefreshRequested(
    TokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final result = await _authRepository.refreshToken();
      // Update only the access token, keep the same refresh token
      await _tokenProvider.updateAccessToken(result.accessToken);
      emit(Authenticated(token: result.accessToken));
    } catch (e) {
      // If token refresh fails, clear tokens and user needs to login again
      await _tokenProvider.clearTokens();
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

  Future<void> _onGetServiceAuthUrl(
    GetServiceAuthUrl event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final url = await _authRepository.getServiceAuthUrl();
      emit(ServiceAuthUrlReceived(service: event.service, url: url));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRefreshServiceToken(
    RefreshServiceToken event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      switch (event.service) {
        case 'spotify':
          await _authRepository.refreshSpotifyToken();
          break;
        case 'ytmusic':
          await _authRepository.refreshYTMusicToken();
          break;
        default:
          throw Exception('Unsupported service for token refresh: ${event.service}');
      }
      emit(const AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
