import 'package:equatable/equatable.dart';

abstract class LauncherState extends Equatable {
  const LauncherState();

  @override
  List<Object?> get props => [];
}

class LauncherInitial extends LauncherState {}

class LauncherLoading extends LauncherState {}

class LauncherAuthenticated extends LauncherState {}

class LauncherUnauthenticated extends LauncherState {}

class LauncherNavigatingToSignup extends LauncherState {}

class LauncherNavigatingToLogin extends LauncherState {}

class LauncherNavigatingToHome extends LauncherState {}

class LauncherFailure extends LauncherState {
  final String error;

  const LauncherFailure(this.error);

  @override
  List<Object> get props => [error];
}
