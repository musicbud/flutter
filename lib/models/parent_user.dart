class ParentUser {
  final String uid;
  final String username;
  final String email;
  final String? accessToken;
  final DateTime? tokenCreatedAt;

  ParentUser({
    required this.uid,
    required this.username,
    required this.email,
    this.accessToken,
    this.tokenCreatedAt,
  });

  factory ParentUser.fromJson(Map<String, dynamic> json) {
    return ParentUser(
      uid: json['uid'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      accessToken: json['access_token'] as String?,
      tokenCreatedAt: json['token_created_at'] != null
          ? DateTime.parse(json['token_created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'access_token': accessToken,
      'token_created_at': tokenCreatedAt?.toIso8601String(),
    };
  }

  ParentUser copyWith({
    String? uid,
    String? username,
    String? email,
    String? accessToken,
    DateTime? tokenCreatedAt,
  }) {
    return ParentUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
      tokenCreatedAt: tokenCreatedAt ?? this.tokenCreatedAt,
    );
  }
}