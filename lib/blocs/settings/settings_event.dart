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
