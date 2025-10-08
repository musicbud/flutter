import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final NotificationSettings notifications;
  final PrivacySettings privacy;
  final String theme;
  final String languageCode;

  const SettingsLoaded({
    required this.notifications,
    required this.privacy,
    required this.theme,
    required this.languageCode,
  });

  @override
  List<Object> get props => [notifications, privacy, theme, languageCode];

  SettingsLoaded copyWith({
    NotificationSettings? notifications,
    PrivacySettings? privacy,
    String? theme,
    String? languageCode,
  }) {
    return SettingsLoaded(
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      theme: theme ?? this.theme,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

class SettingsFailure extends SettingsState {
  final String error;

  const SettingsFailure(this.error);

  @override
  List<Object> get props => [error];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}

class SettingsSaved extends SettingsState {}

class ServiceConnected extends SettingsState {
  final String service;

  const ServiceConnected(this.service);

  @override
  List<Object> get props => [service];
}

class ServiceConnectionError extends SettingsState {
  final String service;
  final String error;

  const ServiceConnectionError(this.service, this.error);

  @override
  List<Object> get props => [service, error];
}

class LikesUpdated extends SettingsState {
  final String service;

  const LikesUpdated(this.service);

  @override
  List<Object> get props => [service];
}

class LikesUpdateError extends SettingsState {
  final String service;
  final String error;

  const LikesUpdateError(this.service, this.error);

  @override
  List<Object> get props => [service, error];
}

class ServiceLoginUrlReceived extends SettingsState {
  final String service;
  final String url;

  const ServiceLoginUrlReceived(this.service, this.url);

  @override
  List<Object> get props => [service, url];
}

class ServiceLoginUrlError extends SettingsState {
  final String service;
  final String error;

  const ServiceLoginUrlError(this.service, this.error);

  @override
  List<Object> get props => [service, error];
}

class NotificationSettings extends Equatable {
  final bool enabled;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool soundEnabled;

  const NotificationSettings({
    required this.enabled,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.soundEnabled,
  });

  @override
  List<Object> get props => [enabled, pushEnabled, emailEnabled, soundEnabled];

  NotificationSettings copyWith({
    bool? enabled,
    bool? pushEnabled,
    bool? emailEnabled,
    bool? soundEnabled,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

class PrivacySettings extends Equatable {
  final bool profileVisible;
  final bool locationVisible;
  final bool activityVisible;

  const PrivacySettings({
    required this.profileVisible,
    required this.locationVisible,
    required this.activityVisible,
  });

  @override
  List<Object> get props => [profileVisible, locationVisible, activityVisible];

  PrivacySettings copyWith({
    bool? profileVisible,
    bool? locationVisible,
    bool? activityVisible,
  }) {
    return PrivacySettings(
      profileVisible: profileVisible ?? this.profileVisible,
      locationVisible: locationVisible ?? this.locationVisible,
      activityVisible: activityVisible ?? this.activityVisible,
    );
  }
}
