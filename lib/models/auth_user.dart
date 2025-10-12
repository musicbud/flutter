class AuthUser {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime lastLogin;

  const AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.roles = const ['user'],
    required this.createdAt,
    required this.lastLogin,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] ?? '').toString(),
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      roles: (json['roles'] as List<dynamic>?)?.cast<String>() ?? ['user'],
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: DateTime.parse(json['lastLogin'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'roles': roles,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  AuthUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    List<String>? roles,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      roles: roles ?? this.roles,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
