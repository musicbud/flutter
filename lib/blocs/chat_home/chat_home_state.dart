import 'package:equatable/equatable.dart';

abstract class ChatHomeState extends Equatable {
  const ChatHomeState();

  @override
  List<Object> get props => [];
}

class ChatHomeInitial extends ChatHomeState {}

class ChatHomeLoading extends ChatHomeState {}

class ChatHomeLoaded extends ChatHomeState {
  final int currentTabIndex;
  final bool isAuthenticated;
  final String username;

  const ChatHomeLoaded({
    required this.currentTabIndex,
    required this.isAuthenticated,
    required this.username,
  });

  @override
  List<Object> get props => [currentTabIndex, isAuthenticated, username];
}

class ChatHomeFailure extends ChatHomeState {
  final String error;

  const ChatHomeFailure(this.error);

  @override
  List<Object> get props => [error];
}
