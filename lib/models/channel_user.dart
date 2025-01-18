class ChannelUser {
  final int id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final String role;
  final DateTime joinedAt;
  final DateTime? lastActive;

  ChannelUser({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    required this.role,
    required this.joinedAt,
    this.lastActive,
  });

  factory ChannelUser.fromJson(Map<String, dynamic> json) {
    return ChannelUser(
      id: json['id'] as int,
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      lastActive: json['last_active'] != null
          ? DateTime.parse(json['last_active'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'role': role,
      'joined_at': joinedAt.toIso8601String(),
      'last_active': lastActive?.toIso8601String(),
    };
  }
}
