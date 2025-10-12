import 'package:equatable/equatable.dart';

/// Settings data model
class SettingsData extends Equatable {
  final String languageCode;
  final bool notifications;
  final String theme;
  final PrivacySettings privacy;

  const SettingsData({
    required this.languageCode,
    required this.notifications,
    required this.theme,
    required this.privacy,
  });

  factory SettingsData.defaultSettings() {
    return const SettingsData(
      languageCode: 'en',
      notifications: true,
      theme: 'system',
      privacy: PrivacySettings(
        profileVisibility: 'public',
        showOnlineStatus: true,
        allowFriendRequests: true,
        allowMessages: true,
      ),
    );
  }

  factory SettingsData.fromJson(Map<String, dynamic> json) {
    return SettingsData(
      languageCode: json['language_code'] ?? 'en',
      notifications: json['notifications'] ?? true,
      theme: json['theme'] ?? 'system',
      privacy: PrivacySettings.fromJson(json['privacy'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      'notifications': notifications,
      'theme': theme,
      'privacy': privacy.toJson(),
    };
  }

  SettingsData copyWith({
    String? languageCode,
    bool? notifications,
    String? theme,
    PrivacySettings? privacy,
  }) {
    return SettingsData(
      languageCode: languageCode ?? this.languageCode,
      notifications: notifications ?? this.notifications,
      theme: theme ?? this.theme,
      privacy: privacy ?? this.privacy,
    );
  }

  @override
  List<Object?> get props => [languageCode, notifications, theme, privacy];
}

/// Privacy settings model
class PrivacySettings extends Equatable {
  final String profileVisibility;
  final bool showOnlineStatus;
  final bool allowFriendRequests;
  final bool allowMessages;

  const PrivacySettings({
    required this.profileVisibility,
    required this.showOnlineStatus,
    required this.allowFriendRequests,
    required this.allowMessages,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      profileVisibility: json['profile_visibility'] ?? 'public',
      showOnlineStatus: json['show_online_status'] ?? true,
      allowFriendRequests: json['allow_friend_requests'] ?? true,
      allowMessages: json['allow_messages'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_visibility': profileVisibility,
      'show_online_status': showOnlineStatus,
      'allow_friend_requests': allowFriendRequests,
      'allow_messages': allowMessages,
    };
  }

  PrivacySettings copyWith({
    String? profileVisibility,
    bool? showOnlineStatus,
    bool? allowFriendRequests,
    bool? allowMessages,
  }) {
    return PrivacySettings(
      profileVisibility: profileVisibility ?? this.profileVisibility,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      allowFriendRequests: allowFriendRequests ?? this.allowFriendRequests,
      allowMessages: allowMessages ?? this.allowMessages,
    );
  }

  @override
  List<Object?> get props => [
        profileVisibility,
        showOnlineStatus,
        allowFriendRequests,
        allowMessages,
      ];
}