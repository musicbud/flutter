import 'package:equatable/equatable.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object?> get props => [];
}

class MainScreenInitialized extends MainScreenEvent {}

class MainScreenAuthStatusChecked extends MainScreenEvent {}

class MainScreenRefreshRequested extends MainScreenEvent {}
