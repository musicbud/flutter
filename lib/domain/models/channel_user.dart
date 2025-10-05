import 'package:equatable/equatable.dart';

/// A model class representing a user in a chat channel
class ChannelUser extends Equatable {
  final String id;
  final String username;
  final String? avatarUrl;
  final String role; // 'owner', 'admin', 'moderator', 'member'
  final bool isOnline;
  final DateTime joinedAt;
  final DateTime? lastActive;
  final Map<String, bool> permissions;

  const ChannelUser({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.role,
    this.isOnline = false,
    required this.joinedAt,
    this.lastActive,
    this.permissions = const {},
  });

  /// Creates a [ChannelUser] from a JSON map
  factory ChannelUser.fromJson(Map<String, dynamic> json) {
    return ChannelUser(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      isOnline: json['is_online'] as bool? ?? false,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      lastActive: json['last_active'] != null
          ? DateTime.parse(json['last_active'] as String)
          : null,
      permissions: Map<String, bool>.from(json['permissions'] as Map? ?? {}),
    );
  }

  /// Converts this [ChannelUser] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'role': role,
      'is_online': isOnline,
      'joined_at': joinedAt.toIso8601String(),
      'last_active': lastActive?.toIso8601String(),
      'permissions': permissions,
    };
  }

  @override
  List<Object?> get props => [
        id,
        username,
        avatarUrl,
        role,
        isOnline,
        joinedAt,
        lastActive,
        permissions,
      ];
}
