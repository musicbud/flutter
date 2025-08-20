import 'package:equatable/equatable.dart';
import '../../domain/models/user_profile.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyProfile extends UserEvent {}

class LoadBudProfile extends UserEvent {
  final String username;

  const LoadBudProfile(this.username);

  @override
  List<Object?> get props => [username];
}

class UpdateMyProfile extends UserEvent {
  final UserProfile profile;

  const UpdateMyProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class LoadLikedItems extends UserEvent {}

class LoadTopItems extends UserEvent {}

class SaveLocation extends UserEvent {
  final double latitude;
  final double longitude;

  const SaveLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class LoadPlayedTracks extends UserEvent {}

class UpdateToken extends UserEvent {
  final String token;

  const UpdateToken({required this.token});

  @override
  List<Object> get props => [token];
}
