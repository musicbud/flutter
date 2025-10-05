import 'package:equatable/equatable.dart';
import '../../../domain/models/user_profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Profile operations
class MyProfileRequested extends ProfileEvent {}

class BudProfileRequested extends ProfileEvent {
  final String username;

  const BudProfileRequested(this.username);

  @override
  List<Object> get props => [username];
}

class ProfileUpdateRequested extends ProfileEvent {
  final UserProfile profile;

  const ProfileUpdateRequested(this.profile);

  @override
  List<Object> get props => [profile];
}

class UpdateLikesRequested extends ProfileEvent {}

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
