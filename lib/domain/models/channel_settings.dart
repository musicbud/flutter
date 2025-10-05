import 'package:equatable/equatable.dart';

/// Channel settings model
class ChannelSettings extends Equatable {
  final String channelId;
  final bool isPrivate;
  final bool allowInvites;
  final bool muteNotifications;
  final bool allowChat;
  final int? maxParticipants;
  final String? description;
  final List<String> allowedRoles;
  final Map<String, dynamic> customSettings;
  final Map<String, dynamic> additionalSettings;

  const ChannelSettings({
    required this.channelId,
    this.isPrivate = false,
    this.allowInvites = true,
    this.muteNotifications = false,
    this.allowChat = true,
    this.maxParticipants,
    this.description,
    this.allowedRoles = const [],
    this.customSettings = const {},
    this.additionalSettings = const {},
  });

  factory ChannelSettings.fromJson(Map<String, dynamic> json) {
    return ChannelSettings(
      channelId: json['channel_id'] as String,
      isPrivate: json['is_private'] as bool? ?? false,
      allowInvites: json['allow_invites'] as bool? ?? true,
      muteNotifications: json['mute_notifications'] as bool? ?? false,
      allowChat: json['allow_chat'] as bool? ?? true,
      maxParticipants: json['max_participants'] as int?,
      description: json['description'] as String?,
      allowedRoles: (json['allowed_roles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      customSettings: json['custom_settings'] as Map<String, dynamic>? ?? const {},
      additionalSettings: json['additional_settings'] as Map<String, dynamic>? ?? const {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'is_private': isPrivate,
      'allow_invites': allowInvites,
      'mute_notifications': muteNotifications,
      'allow_chat': allowChat,
      if (maxParticipants != null) 'max_participants': maxParticipants,
      if (description != null) 'description': description,
      'allowed_roles': allowedRoles,
      'custom_settings': customSettings,
      'additional_settings': additionalSettings,
    };
  }

  ChannelSettings copyWith({
    String? channelId,
    bool? isPrivate,
    bool? allowInvites,
    bool? muteNotifications,
    bool? allowChat,
    int? maxParticipants,
    String? description,
    List<String>? allowedRoles,
    Map<String, dynamic>? customSettings,
    Map<String, dynamic>? additionalSettings,
  }) {
    return ChannelSettings(
      channelId: channelId ?? this.channelId,
      isPrivate: isPrivate ?? this.isPrivate,
      allowInvites: allowInvites ?? this.allowInvites,
      muteNotifications: muteNotifications ?? this.muteNotifications,
      allowChat: allowChat ?? this.allowChat,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      description: description ?? this.description,
      allowedRoles: allowedRoles ?? this.allowedRoles,
      customSettings: customSettings ?? this.customSettings,
      additionalSettings: additionalSettings ?? this.additionalSettings,
    );
  }

  @override
  List<Object?> get props => [
        channelId,
        isPrivate,
        allowInvites,
        muteNotifications,
        allowChat,
        maxParticipants,
        description,
        allowedRoles,
        customSettings,
        additionalSettings,
      ];
}
