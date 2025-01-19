import 'package:equatable/equatable.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object> get props => [];
}

class MainScreenInitialized extends MainScreenEvent {}

class MainScreenNavigationRequested extends MainScreenEvent {
  final String route;

  const MainScreenNavigationRequested(this.route);

  @override
  List<Object> get props => [route];
}

class MainScreenAuthStatusChecked extends MainScreenEvent {}

class MainScreenRefreshRequested extends MainScreenEvent {}
