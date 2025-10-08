import 'package:equatable/equatable.dart';
import '../../models/user_profile.dart';

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

// Authentication Events
class LoginRequest extends UserEvent {
  final String username;
  final String password;

  const LoginRequest({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class RegisterRequest extends UserEvent {
  final String username;
  final String email;
  final String password;

  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}

class GetServiceLoginUrl extends UserEvent {
  final String service;

  const GetServiceLoginUrl({required this.service});

  @override
  List<Object> get props => [service];
}

class ConnectService extends UserEvent {
  final String service;
  final String code;

  const ConnectService({required this.service, required this.code});

  @override
  List<Object> get props => [service, code];
}

class RefreshSpotifyToken extends UserEvent {}
