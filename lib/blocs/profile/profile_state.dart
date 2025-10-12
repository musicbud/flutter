import 'package:equatable/equatable.dart';
import '../../../models/user_profile.dart';
import '../../../models/bud_match.dart';

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

// Specific states for different types of content
class TopTracksLoaded extends ProfileState {
  final List<dynamic> tracks;

  const TopTracksLoaded({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class TopArtistsLoaded extends ProfileState {
  final List<dynamic> artists;

  const TopArtistsLoaded({required this.artists});

  @override
  List<Object> get props => [artists];
}

class TopGenresLoaded extends ProfileState {
  final List<dynamic> genres;

  const TopGenresLoaded({required this.genres});

  @override
  List<Object> get props => [genres];
}

class LikedTracksLoaded extends ProfileState {
  final List<dynamic> tracks;

  const LikedTracksLoaded({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class LikedArtistsLoaded extends ProfileState {
  final List<dynamic> artists;

  const LikedArtistsLoaded({required this.artists});

  @override
  List<Object> get props => [artists];
}

class LikedGenresLoaded extends ProfileState {
  final List<dynamic> genres;

  const LikedGenresLoaded({required this.genres});

  @override
  List<Object> get props => [genres];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}
