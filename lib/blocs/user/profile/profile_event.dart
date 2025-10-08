import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Profile operations
class GetProfile extends ProfileEvent {
  final String? service;
  final String? token;

  const GetProfile({this.service, this.token});

  @override
  List<Object?> get props => [service, token];
}

class BudProfileRequested extends ProfileEvent {
  final String username;

  const BudProfileRequested(this.username);

  @override
  List<Object> get props => [username];
}

class UpdateProfile extends ProfileEvent {
  final String? bio;
  final String? displayName;

  const UpdateProfile({this.bio, this.displayName});

  @override
  List<Object?> get props => [bio, displayName];
}

class SyncLikes extends ProfileEvent {}

// Liked items
class LikedArtistsRequested extends ProfileEvent {}

class LikedTracksRequested extends ProfileEvent {}

class LikedAlbumsRequested extends ProfileEvent {}

class LikedGenresRequested extends ProfileEvent {}

// Top items
class TopArtistsRequested extends ProfileEvent {}

class TopTracksRequested extends ProfileEvent {}

class TopGenresRequested extends ProfileEvent {}

class TopAnimeRequested extends ProfileEvent {}

class TopMangaRequested extends ProfileEvent {}
