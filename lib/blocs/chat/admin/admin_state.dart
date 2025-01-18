import 'package:equatable/equatable.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminFailure extends AdminState {
  final String error;

  const AdminFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AdminStatusLoaded extends AdminState {
  final bool isAdmin;

  const AdminStatusLoaded(this.isAdmin);

  @override
  List<Object> get props => [isAdmin];
}

class ModeratorAddedSuccess extends AdminState {}

class ModeratorRemovedSuccess extends AdminState {}

class AdminAddedSuccess extends AdminState {}

class AdminRemovedSuccess extends AdminState {}

class UserKickedSuccess extends AdminState {}

class UserBlockedSuccess extends AdminState {}

class UserUnblockedSuccess extends AdminState {}
