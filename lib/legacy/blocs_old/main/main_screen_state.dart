import 'package:equatable/equatable.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object?> get props => [];
}

class MainScreenInitial extends MainScreenState {}

class MainScreenLoading extends MainScreenState {}

class MainScreenAuthenticated extends MainScreenState {
  final String username;
  final Map<String, dynamic> userProfile;

  const MainScreenAuthenticated({
    required this.username,
    required this.userProfile,
  });

  @override
  List<Object> get props => [username, userProfile];
}

class MainScreenUnauthenticated extends MainScreenState {}

class MainScreenFailure extends MainScreenState {
  final String error;

  const MainScreenFailure(this.error);

  @override
  List<Object> get props => [error];
}
