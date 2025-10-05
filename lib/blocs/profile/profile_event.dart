import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileRequested extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final Map<String, dynamic> profileData;

  const ProfileUpdateRequested(this.profileData);

  @override
  List<Object> get props => [profileData];
}

class ProfileAvatarUpdateRequested extends ProfileEvent {
  final XFile imageFile;

  const ProfileAvatarUpdateRequested(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class ProfileAuthenticationChecked extends ProfileEvent {}

class ProfileLogoutRequested extends ProfileEvent {}

class ProfileTopItemsRequested extends ProfileEvent {
  final String category; // 'tracks', 'artists', 'genres', 'anime', 'manga'

  const ProfileTopItemsRequested(this.category);

  @override
  List<Object> get props => [category];
}

class ProfileLikedItemsRequested extends ProfileEvent {
  final String category; // 'tracks', 'artists', 'genres', 'albums'

  const ProfileLikedItemsRequested(this.category);

  @override
  List<Object> get props => [category];
}

class ProfilePlayedTracksRequested extends ProfileEvent {}

class ProfileBudsRequested extends ProfileEvent {
  final String category; // 'liked/artists', 'liked/tracks', etc.

  const ProfileBudsRequested(this.category);

  @override
  List<Object> get props => [category];
}

class ProfileConnectedServicesRequested extends ProfileEvent {}
