import 'package:equatable/equatable.dart';

/// Settings model for user preferences
class SettingsModel extends Equatable {
  final String userId;
  final NotificationSettings notifications;
  final PrivacySettings privacy;
  final AppearanceSettings appearance;
  final PlaybackSettings playback;
  final DateTime updatedAt;

  const SettingsModel({
    required this.userId,
    required this.notifications,
    required this.privacy,
    required this.appearance,
    required this.playback,
    required this.updatedAt,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      userId: json['user_id'] as String,
      notifications: NotificationSettings.fromJson(json['notifications'] as Map<String, dynamic>),
      privacy: PrivacySettings.fromJson(json['privacy'] as Map<String, dynamic>),
      appearance: AppearanceSettings.fromJson(json['appearance'] as Map<String, dynamic>),
      playback: PlaybackSettings.fromJson(json['playback'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'notifications': notifications.toJson(),
      'privacy': privacy.toJson(),
      'appearance': appearance.toJson(),
      'playback': playback.toJson(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  SettingsModel copyWith({
    String? userId,
    NotificationSettings? notifications,
    PrivacySettings? privacy,
    AppearanceSettings? appearance,
    PlaybackSettings? playback,
    DateTime? updatedAt,
  }) {
    return SettingsModel(
      userId: userId ?? this.userId,
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      appearance: appearance ?? this.appearance,
      playback: playback ?? this.playback,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [userId, notifications, privacy, appearance, playback, updatedAt];
}

class NotificationSettings extends Equatable {
  final bool enabled;
  final bool newMatches;
  final bool messages;
  final bool likes;
  final bool comments;

  const NotificationSettings({
    required this.enabled,
    required this.newMatches,
    required this.messages,
    required this.likes,
    required this.comments,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      enabled: json['enabled'] as bool? ?? true,
      newMatches: json['new_matches'] as bool? ?? true,
      messages: json['messages'] as bool? ?? true,
      likes: json['likes'] as bool? ?? true,
      comments: json['comments'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'new_matches': newMatches,
      'messages': messages,
      'likes': likes,
      'comments': comments,
    };
  }

  @override
  List<Object?> get props => [enabled, newMatches, messages, likes, comments];
}

class PrivacySettings extends Equatable {
  final bool profileVisible;
  final bool showOnlineStatus;
  final bool allowMessages;
  final String whoCanSeeActivity;

  const PrivacySettings({
    required this.profileVisible,
    required this.showOnlineStatus,
    required this.allowMessages,
    required this.whoCanSeeActivity,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      profileVisible: json['profile_visible'] as bool? ?? true,
      showOnlineStatus: json['show_online_status'] as bool? ?? true,
      allowMessages: json['allow_messages'] as bool? ?? true,
      whoCanSeeActivity: json['who_can_see_activity'] as String? ?? 'everyone',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_visible': profileVisible,
      'show_online_status': showOnlineStatus,
      'allow_messages': allowMessages,
      'who_can_see_activity': whoCanSeeActivity,
    };
  }

  @override
  List<Object?> get props => [profileVisible, showOnlineStatus, allowMessages, whoCanSeeActivity];
}

class AppearanceSettings extends Equatable {
  final String theme;
  final String language;
  final bool compactMode;

  const AppearanceSettings({
    required this.theme,
    required this.language,
    required this.compactMode,
  });

  factory AppearanceSettings.fromJson(Map<String, dynamic> json) {
    return AppearanceSettings(
      theme: json['theme'] as String? ?? 'dark',
      language: json['language'] as String? ?? 'en',
      compactMode: json['compact_mode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'language': language,
      'compact_mode': compactMode,
    };
  }

  @override
  List<Object?> get props => [theme, language, compactMode];
}

class PlaybackSettings extends Equatable {
  final int quality;
  final bool autoplay;
  final bool crossfade;
  final int crossfadeDuration;

  const PlaybackSettings({
    required this.quality,
    required this.autoplay,
    required this.crossfade,
    required this.crossfadeDuration,
  });

  factory PlaybackSettings.fromJson(Map<String, dynamic> json) {
    return PlaybackSettings(
      quality: json['quality'] as int? ?? 320,
      autoplay: json['autoplay'] as bool? ?? true,
      crossfade: json['crossfade'] as bool? ?? false,
      crossfadeDuration: json['crossfade_duration'] as int? ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quality': quality,
      'autoplay': autoplay,
      'crossfade': crossfade,
      'crossfade_duration': crossfadeDuration,
    };
  }

  @override
  List<Object?> get props => [quality, autoplay, crossfade, crossfadeDuration];
}
