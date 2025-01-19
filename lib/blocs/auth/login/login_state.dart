import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> data;

  const LoginSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

class LoginConnectivityStatus extends LoginState {
  final bool isConnected;

  const LoginConnectivityStatus({required this.isConnected});

  @override
  List<Object> get props => [isConnected];
}

class LoginServerStatus extends LoginState {
  final bool isReachable;
  final String? error;
  final String? message;

  const LoginServerStatus({
    required this.isReachable,
    this.error,
    this.message,
  });

  @override
  List<Object?> get props => [isReachable, error, message];
}
