import 'package:equatable/equatable.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/models/bud_match.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object> get props => [profile];
}

class ProfileUpdateSuccess extends ProfileState {
  final UserProfile profile;

  const ProfileUpdateSuccess({required this.profile});

  @override
  List<Object> get props => [profile];
}

class ProfileAvatarUpdateSuccess extends ProfileState {
  final String avatarUrl;

  const ProfileAvatarUpdateSuccess({required this.avatarUrl});

  @override
  List<Object> get props => [avatarUrl];
}

class ProfileAuthenticationStatus extends ProfileState {
  final bool isAuthenticated;

  const ProfileAuthenticationStatus({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}

class ProfileLogoutSuccess extends ProfileState {}

class ProfileTopItemsLoaded extends ProfileState {
  final List<dynamic> items;
  final String category;

  const ProfileTopItemsLoaded({required this.items, required this.category});

  @override
  List<Object> get props => [items, category];
}

class ProfileLikedItemsLoaded extends ProfileState {
  final List<dynamic> items;
  final String category;

  const ProfileLikedItemsLoaded({required this.items, required this.category});

  @override
  List<Object> get props => [items, category];
}

class ProfileBudsLoaded extends ProfileState {
  final List<BudMatch> buds;
  final String category;

  const ProfileBudsLoaded({required this.buds, required this.category});

  @override
  List<Object> get props => [buds, category];
}

class ProfileConnectedServicesLoaded extends ProfileState {
  final List<dynamic> services;

  const ProfileConnectedServicesLoaded({required this.services});

  @override
  List<Object> get props => [services];
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure({required this.error});

  @override
  List<Object> get props => [error];
}
