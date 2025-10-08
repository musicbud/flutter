import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsRequested extends SettingsEvent {}

class NotificationSettingsUpdated extends SettingsEvent {
  final bool enabled;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool soundEnabled;

  const NotificationSettingsUpdated({
    required this.enabled,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.soundEnabled,
  });

  @override
  List<Object> get props => [enabled, pushEnabled, emailEnabled, soundEnabled];
}

class PrivacySettingsUpdated extends SettingsEvent {
  final bool profileVisible;
  final bool locationVisible;
  final bool activityVisible;

  const PrivacySettingsUpdated({
    required this.profileVisible,
    required this.locationVisible,
    required this.activityVisible,
  });

  @override
  List<Object> get props => [profileVisible, locationVisible, activityVisible];
}

class ThemeSettingUpdated extends SettingsEvent {
  final String theme; // 'light', 'dark', or 'system'

  const ThemeSettingUpdated(this.theme);

  @override
  List<Object> get props => [theme];
}

class LanguageSettingUpdated extends SettingsEvent {
  final String languageCode;

  const LanguageSettingUpdated(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class LoadSettingsEvent extends SettingsEvent {}

class SaveSettingsEvent extends SettingsEvent {}

class UpdateNotificationSettingsEvent extends SettingsEvent {
  final bool enabled;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool soundEnabled;

  const UpdateNotificationSettingsEvent({
    required this.enabled,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.soundEnabled,
  });

  @override
  List<Object> get props => [enabled, pushEnabled, emailEnabled, soundEnabled];
}

class UpdatePrivacySettingsEvent extends SettingsEvent {
  final bool profileVisible;
  final bool locationVisible;
  final bool activityVisible;

  const UpdatePrivacySettingsEvent({
    required this.profileVisible,
    required this.locationVisible,
    required this.activityVisible,
  });

  @override
  List<Object> get props => [profileVisible, locationVisible, activityVisible];
}

class UpdateThemeEvent extends SettingsEvent {
  final String theme;

  const UpdateThemeEvent(this.theme);

  @override
  List<Object> get props => [theme];
}

class UpdateLanguageEvent extends SettingsEvent {
  final String languageCode;

  const UpdateLanguageEvent(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class ConnectSpotify extends SettingsEvent {
  final String token;
  final String spotifyToken;

  const ConnectSpotify({
    required this.token,
    required this.spotifyToken,
  });

  @override
  List<Object> get props => [token, spotifyToken];
}

class ConnectYTMusic extends SettingsEvent {
  final String token;
  final String ytmusicToken;

  const ConnectYTMusic({
    required this.token,
    required this.ytmusicToken,
  });

  @override
  List<Object> get props => [token, ytmusicToken];
}

class ConnectLastFM extends SettingsEvent {
  final String token;
  final String lastfmToken;

  const ConnectLastFM({
    required this.token,
    required this.lastfmToken,
  });

  @override
  List<Object> get props => [token, lastfmToken];
}

class ConnectMAL extends SettingsEvent {
  final String token;
  final String malToken;

  const ConnectMAL({
    required this.token,
    required this.malToken,
  });

  @override
  List<Object> get props => [token, malToken];
}

class UpdateLikes extends SettingsEvent {
  final String service;
  final String token;

  const UpdateLikes({
    required this.service,
    required this.token,
  });

  @override
  List<Object> get props => [service, token];
}

class GetServiceLoginUrl extends SettingsEvent {
  final String service;

  const GetServiceLoginUrl(this.service);

  @override
  List<Object> get props => [service];
}
