import 'package:equatable/equatable.dart';
import 'channel_settings.dart';
import 'channel_stats.dart';
import '../../constants/app_constants.dart';

/// A model class representing a chat channel
class Channel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? avatarUrl;
  final ChannelSettings settings;
  final ChannelStats stats;
  final String type; // 'public', 'private', 'direct'
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isJoined;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int? memberCount;

  const Channel({
    required this.id,
    required this.name,
    this.description,
    this.avatarUrl,
    required this.settings,
    required this.stats,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.isJoined,
    this.lastMessage,
    this.lastMessageAt,
    this.memberCount,
  });

  /// Creates a [Channel] from a JSON map
  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      settings: ChannelSettings.fromJson(json['settings'] as Map<String, dynamic>),
      stats: ChannelStats.fromJson(json['stats'] as Map<String, dynamic>),
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isJoined: json['is_joined'] as bool? ?? false,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      memberCount: json['member_count'] as int?,
    );
  }

  /// Converts this [Channel] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar_url': avatarUrl,
      'settings': settings.toJson(),
      'stats': stats.toJson(),
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_joined': isJoined,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'member_count': memberCount,
    };
  }

  /// Factory method to create a new channel with default settings
  factory Channel.create({
    required String name,
    required String description,
    required String type,
    String? avatarUrl,
  }) {
    final now = DateTime.now();
    return Channel(
      id: '', // Will be set by server
      name: name,
      description: description,
      avatarUrl: avatarUrl,
      type: type,
      settings: ChannelSettings(
        channelId: '', // Will be set by server
        isPrivate: type == AppConstants.channelTypePrivate,
      ),
      stats: ChannelStats(
        channelId: '', // Will be set by server
        activeUsers: 0,
        memberCount: 0,
        messageCount: 0,
        lastActivityAt: now,
        // metrics: const {},
      ),
      createdAt: now,
      updatedAt: now,
      isJoined: false,
    );
  }

  /// Returns a copy of this [Channel] with the given fields replaced with new values
  Channel copyWith({
    String? id,
    String? name,
    String? description,
    String? avatarUrl,
    ChannelSettings? settings,
    ChannelStats? stats,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isJoined,
    String? lastMessage,
    DateTime? lastMessageAt,
    int? memberCount,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      settings: settings ?? this.settings,
      stats: stats ?? this.stats,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isJoined: isJoined ?? this.isJoined,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      memberCount: memberCount ?? this.memberCount,
    );
  }

  /// Check if this channel is public
  bool get isPublic => type == AppConstants.channelTypePublic;

  /// Check if this channel is private
  bool get isPrivate => type == AppConstants.channelTypePrivate;

  /// Check if this channel is a direct message
  bool get isDirect => type == AppConstants.channelTypeDirect;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    avatarUrl,
    settings,
    stats,
    type,
    createdAt,
    updatedAt,
    isJoined,
    lastMessage,
    lastMessageAt,
    memberCount,
  ];
}
