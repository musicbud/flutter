import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/mock_data_service.dart';

// Simple Auth Events
abstract class SimpleAuthEvent extends Equatable {
  const SimpleAuthEvent();
  @override
  List<Object?> get props => [];
}

class SimpleLoginRequested extends SimpleAuthEvent {
  final String username;
  final String password;

  const SimpleLoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class SimpleLogoutRequested extends SimpleAuthEvent {}

class SimpleCheckAuthStatus extends SimpleAuthEvent {}

class SimpleRegisterRequested extends SimpleAuthEvent {
  final String username;
  final String email;
  final String password;

  const SimpleRegisterRequested({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

// Simple Auth States
abstract class SimpleAuthState extends Equatable {
  const SimpleAuthState();
  @override
  List<Object?> get props => [];
}

class SimpleAuthInitial extends SimpleAuthState {}

class SimpleAuthLoading extends SimpleAuthState {}

class SimpleAuthAuthenticated extends SimpleAuthState {
  final Map<String, dynamic> user;
  final String token;

  const SimpleAuthAuthenticated({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];
}

class SimpleAuthUnauthenticated extends SimpleAuthState {}

class SimpleAuthError extends SimpleAuthState {
  final String message;

  const SimpleAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class SimpleAuthRegistrationSuccess extends SimpleAuthState {
  final Map<String, dynamic> user;

  const SimpleAuthRegistrationSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

// Simple AuthBloc
class SimpleAuthBloc extends Bloc<SimpleAuthEvent, SimpleAuthState> {
  SimpleAuthBloc() : super(SimpleAuthInitial()) {
    on<SimpleLoginRequested>(_onLoginRequested);
    on<SimpleLogoutRequested>(_onLogoutRequested);
    on<SimpleCheckAuthStatus>(_onCheckAuthStatus);
    on<SimpleRegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
    SimpleLoginRequested event,
    Emitter<SimpleAuthState> emit,
  ) async {
    try {
      emit(SimpleAuthLoading());
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Simple validation - accept any non-empty credentials
      if (event.username.isNotEmpty && event.password.isNotEmpty) {
        final user = MockDataService.generateUserProfile(userId: 'mock_user_123');
        const token = 'mock_jwt_token_here';
        
        emit(SimpleAuthAuthenticated(user: user, token: token));
      } else {
        emit(const SimpleAuthError('Invalid username or password'));
      }
    } catch (e) {
      emit(SimpleAuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    SimpleLogoutRequested event,
    Emitter<SimpleAuthState> emit,
  ) async {
    try {
      emit(SimpleAuthLoading());
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate cleanup
      emit(SimpleAuthUnauthenticated());
    } catch (e) {
      emit(SimpleAuthError('Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _onCheckAuthStatus(
    SimpleCheckAuthStatus event,
    Emitter<SimpleAuthState> emit,
  ) async {
    try {
      emit(SimpleAuthLoading());
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate token check
      
      // For demo purposes, randomly return authenticated or not
      // In real app, you'd check stored token validity
      if (DateTime.now().millisecondsSinceEpoch % 3 == 0) {
        final user = MockDataService.generateUserProfile(userId: 'mock_user_123');
        const token = 'mock_jwt_token_here';
        emit(SimpleAuthAuthenticated(user: user, token: token));
      } else {
        emit(SimpleAuthUnauthenticated());
      }
    } catch (e) {
      emit(SimpleAuthError('Auth check failed: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterRequested(
    SimpleRegisterRequested event,
    Emitter<SimpleAuthState> emit,
  ) async {
    try {
      emit(SimpleAuthLoading());
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Simple validation
      if (event.username.isNotEmpty && 
          event.email.contains('@') && 
          event.password.length >= 6) {
        
        final user = MockDataService.generateUserProfile(userId: 'new_user_${DateTime.now().millisecondsSinceEpoch}');
        
        // Override generated data with user input
        final registeredUser = Map<String, dynamic>.from(user);
        registeredUser['username'] = event.username;
        registeredUser['email'] = event.email;
        registeredUser['displayName'] = event.username;
        
        emit(SimpleAuthRegistrationSuccess(user: registeredUser));
        
        // Auto-login after registration
        await Future.delayed(const Duration(milliseconds: 500));
        const token = 'mock_jwt_token_for_new_user';
        emit(SimpleAuthAuthenticated(user: registeredUser, token: token));
      } else {
        String errorMessage = 'Registration failed: ';
        if (event.username.isEmpty) {
          errorMessage += 'Username is required. ';
        }
        if (!event.email.contains('@')) {
          errorMessage += 'Valid email is required. ';
        }
        if (event.password.length < 6) {
          errorMessage += 'Password must be at least 6 characters.';
        }
        emit(SimpleAuthError(errorMessage));
      }
    } catch (e) {
      emit(SimpleAuthError('Registration failed: ${e.toString()}'));
    }
  }
}