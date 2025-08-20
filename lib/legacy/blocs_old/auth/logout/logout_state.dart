import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutInProgress extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutFailure extends LogoutState {
  final String error;

  const LogoutFailure(this.error);

  @override
  List<Object> get props => [error];
}
