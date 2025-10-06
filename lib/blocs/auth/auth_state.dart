import 'package:equatable/equatable.dart';
import '../../models/auth_user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  final String? message;

  const AuthAuthenticated(this.user, {this.message});

  @override
  List<Object?> get props => [user, message];
}

class AuthUnauthenticated extends AuthState {
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState {
  final String message;
  final bool isNetworkError;

  const AuthError(this.message, {this.isNetworkError = false});

  @override
  List<Object> get props => [message, isNetworkError];
}

class AuthEmailVerificationSent extends AuthState {
  const AuthEmailVerificationSent();
}

class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}

class AuthProfileUpdateSuccess extends AuthState {
  final AuthUser user;

  const AuthProfileUpdateSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthPasswordUpdateSuccess extends AuthState {
  const AuthPasswordUpdateSuccess();
}
