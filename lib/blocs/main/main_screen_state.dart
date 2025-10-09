import 'package:equatable/equatable.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object?> get props => [];
}

class MainScreenInitial extends MainScreenState {
  const MainScreenInitial();
}

class MainScreenLoading extends MainScreenState {
  const MainScreenLoading();
}

class MainScreenAuthenticated extends MainScreenState {
  final String username;
  final Map<String, dynamic> userProfile;
  final List<dynamic> recentActivity;
  final List<Map<String, dynamic>> featuredContent;

  const MainScreenAuthenticated({
    required this.username,
    required this.userProfile,
    this.recentActivity = const [],
    this.featuredContent = const [],
  });

  @override
  List<Object> get props => [username, userProfile, recentActivity, featuredContent];
}

class MainScreenUnauthenticated extends MainScreenState {
  const MainScreenUnauthenticated();
}

class MainScreenFailure extends MainScreenState {
  final String error;

  const MainScreenFailure(this.error);

  @override
  List<Object> get props => [error];
}
