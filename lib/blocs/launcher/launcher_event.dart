import 'package:equatable/equatable.dart';

abstract class LauncherEvent extends Equatable {
  const LauncherEvent();

  @override
  List<Object?> get props => [];
}

class LauncherAuthStatusChecked extends LauncherEvent {}

class LauncherNavigateToSignup extends LauncherEvent {}

class LauncherNavigateToLogin extends LauncherEvent {}

class LauncherNavigateToHome extends LauncherEvent {}
