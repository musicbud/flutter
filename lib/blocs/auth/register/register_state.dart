import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterConnectivityStatus extends RegisterState {
  final bool isConnected;

  const RegisterConnectivityStatus(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}

class RegisterServerStatus extends RegisterState {
  final bool isReachable;
  final String? error;
  final String? message;

  const RegisterServerStatus({
    required this.isReachable,
    this.error,
    this.message,
  });

  @override
  List<Object?> get props => [isReachable, error, message];
}

class RegisterSuccess extends RegisterState {
  final Map<String, dynamic> data;

  const RegisterSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object> get props => [error];
}
