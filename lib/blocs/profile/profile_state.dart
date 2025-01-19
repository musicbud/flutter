import '../../domain/models/content_service.dart';
import '../../models/user_profile.dart';
import '../../models/bud_match.dart';

abstract class ProfileState {}

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

  ProfileTopItemsLoaded({
    required this.items,
    required this.category,
  });
}

class ProfileLikedItemsLoaded extends ProfileState {
  final List<dynamic> items;
  final String category;

  ProfileLikedItemsLoaded({
    required this.items,
    required this.category,
  });
}

class ProfileBudsLoaded extends ProfileState {
  final List<BudMatch> buds;
  final String category;

  ProfileBudsLoaded({
    required this.buds,
    required this.category,
  });
}

class ProfileConnectedServicesLoaded extends ProfileState {
  final List<ContentService> services;

  ProfileConnectedServicesLoaded({required this.services});
}

class ProfileAvatarUpdateSuccess extends ProfileState {
  final String avatarUrl;

  ProfileAvatarUpdateSuccess({required this.avatarUrl});
}

class ProfileUpdateSuccess extends ProfileState {
  final UserProfile profile;

  ProfileUpdateSuccess({required this.profile});
}
