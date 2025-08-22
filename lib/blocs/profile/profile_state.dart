import '../../domain/models/content_service.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/bud_match.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileAuthenticationStatus extends ProfileState {
  final bool isAuthenticated;

  ProfileAuthenticationStatus({required this.isAuthenticated});
}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  final List<ContentService>? services;

  ProfileLoaded({
    required this.profile,
    this.services,
  });
}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure({required this.error});
}

class ProfileLogoutSuccess extends ProfileState {}

class ProfileTopItemsLoaded extends ProfileState {
  final List<dynamic> items;
  final String category;

  const ProfileTopItemsLoaded({required this.items, required this.category});

  @override
  List<Object?> get props => [items, category];
}

class ProfileLikedItemsLoaded extends ProfileState {
  final List<dynamic> items;
  final String category;

  const ProfileLikedItemsLoaded({required this.items, required this.category});

  @override
  List<Object?> get props => [items, category];
}

class ProfileBudsLoaded extends ProfileState {
  final List<dynamic> buds;
  final String category;

  const ProfileBudsLoaded({required this.buds, required this.category});

  @override
  List<Object?> get props => [buds, category];
}

class ProfileConnectedServicesLoaded extends ProfileState {
  final List<dynamic> services;

  const ProfileConnectedServicesLoaded({required this.services});

  @override
  List<Object?> get props => [services];
}

class ProfileStatsLoaded extends ProfileState {
  final Map<String, dynamic> stats;

  const ProfileStatsLoaded({required this.stats});

  @override
  List<Object?> get props => [stats];
}

class ProfilePreferencesLoaded extends ProfileState {
  final Map<String, dynamic> preferences;

  const ProfilePreferencesLoaded({required this.preferences});

  @override
  List<Object?> get props => [preferences];
}

class ProfileAvatarUpdateSuccess extends ProfileState {
  final String avatarUrl;

  ProfileAvatarUpdateSuccess({required this.avatarUrl});
}

class ProfileUpdateSuccess extends ProfileState {
  final UserProfile profile;

  ProfileUpdateSuccess({required this.profile});
}
