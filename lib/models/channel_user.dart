import 'package:equatable/equatable.dart';
import '../../constants/app_constants.dart';

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

  /// Creates a copy of this [ChannelUser] with the given fields replaced with new values
  ChannelUser copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    String? role,
    bool? isOnline,
    DateTime? joinedAt,
    DateTime? lastActive,
    Map<String, bool>? permissions,
  }) {
    return ChannelUser(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isOnline: isOnline ?? this.isOnline,
      joinedAt: joinedAt ?? this.joinedAt,
      lastActive: lastActive ?? this.lastActive,
      permissions: permissions ?? this.permissions,
    );
  }

  /// Check if this user is the owner of the channel
  bool get isOwner => role == AppConstants.channelRoleOwner;

  /// Check if this user is an admin of the channel
  bool get isAdmin => role == AppConstants.channelRoleAdmin;

  /// Check if this user is a moderator of the channel
  bool get isModerator => role == AppConstants.channelRoleModerator;

  /// Check if this user is a regular member of the channel
  bool get isMember => role == AppConstants.channelRoleMember;

  /// Check if this user has moderator privileges or higher
  bool get hasModeratorPrivileges => isOwner || isAdmin || isModerator;

  /// Check if this user has admin privileges or higher
  bool get hasAdminPrivileges => isOwner || isAdmin;

  /// Get the role hierarchy level (higher number = more permissions)
  int get roleLevel {
    switch (role) {
      case 'owner':
        return 4;
      case 'admin':
        return 3;
      case 'moderator':
        return 2;
      case 'member':
        return 1;
      default:
        return 0;
    }
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
