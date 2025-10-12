import 'package:equatable/equatable.dart';

/// Admin model representing admin user data
class Admin extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final List<String> permissions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final Map<String, dynamic>? metadata;

  const Admin({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.avatarUrl,
    required this.permissions,
    required this.isActive,
    required this.createdAt,
    this.lastLogin,
    this.metadata,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] ?? json['uid'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      displayName: json['display_name'] ?? json['displayName'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
      permissions: List<String>.from(json['permissions'] ?? []),
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      createdAt: DateTime.tryParse(json['created_at'] ?? json['createdAt'] ?? '') ?? DateTime.now(),
      lastLogin: json['last_login'] != null || json['lastLogin'] != null
          ? DateTime.tryParse(json['last_login'] ?? json['lastLogin'] ?? '')
          : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'permissions': permissions,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'metadata': metadata,
    };
  }

  Admin copyWith({
    String? id,
    String? username,
    String? email,
    String? displayName,
    String? avatarUrl,
    List<String>? permissions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
    Map<String, dynamic>? metadata,
  }) {
    return Admin(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        displayName,
        avatarUrl,
        permissions,
        isActive,
        createdAt,
        lastLogin,
        metadata,
      ];

  @override
  String toString() {
    return 'Admin(id: $id, username: $username, email: $email, displayName: $displayName)';
  }
}

/// Admin statistics model
class AdminStats extends Equatable {
  final int totalAdmins;
  final int activeAdmins;
  final int inactiveAdmins;
  final int recentLogins;
  final Map<String, int> permissionsCount;
  final DateTime lastUpdated;

  const AdminStats({
    required this.totalAdmins,
    required this.activeAdmins,
    required this.inactiveAdmins,
    required this.recentLogins,
    required this.permissionsCount,
    required this.lastUpdated,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalAdmins: json['total_admins'] ?? json['totalAdmins'] ?? 0,
      activeAdmins: json['active_admins'] ?? json['activeAdmins'] ?? 0,
      inactiveAdmins: json['inactive_admins'] ?? json['inactiveAdmins'] ?? 0,
      recentLogins: json['recent_logins'] ?? json['recentLogins'] ?? 0,
      permissionsCount: Map<String, int>.from(json['permissions_count'] ?? json['permissionsCount'] ?? {}),
      lastUpdated: DateTime.tryParse(json['last_updated'] ?? json['lastUpdated'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_admins': totalAdmins,
      'active_admins': activeAdmins,
      'inactive_admins': inactiveAdmins,
      'recent_logins': recentLogins,
      'permissions_count': permissionsCount,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        totalAdmins,
        activeAdmins,
        inactiveAdmins,
        recentLogins,
        permissionsCount,
        lastUpdated,
      ];
}

/// Admin action model for audit logs
class AdminAction extends Equatable {
  final String id;
  final String adminId;
  final String action;
  final String description;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const AdminAction({
    required this.id,
    required this.adminId,
    required this.action,
    required this.description,
    this.metadata,
    required this.timestamp,
  });

  factory AdminAction.fromJson(Map<String, dynamic> json) {
    return AdminAction(
      id: json['id'] ?? '',
      adminId: json['admin_id'] ?? json['adminId'] ?? '',
      action: json['action'] ?? '',
      description: json['description'] ?? '',
      metadata: json['metadata'],
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'action': action,
      'description': description,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        adminId,
        action,
        description,
        metadata,
        timestamp,
      ];
}