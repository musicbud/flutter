class UserProfile {
  final String username;
  final String email;
  final String? photoUrl;
  final String? displayName;
  final String? bio;
  final bool isActive;
  final bool isAuthenticated;

  UserProfile({
    required this.username,
    required this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    required this.isActive,
    required this.isAuthenticated,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photo_url'],
      displayName: json['display_name'],
      bio: json['bio'],
      isActive: json['is_active'] ?? false,
      isAuthenticated: json['is_authenticated'] ?? false,
    );
  }

  get uid => null;

  // You can add a toJson method if needed
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'photo_url': photoUrl,
      'display_name': displayName,
      'bio': bio,
      'is_active': isActive,
      'is_authenticated': isAuthenticated,
    };
  }

  UserProfile copyWith({
    String? username,
    String? email,
    String? photoUrl,
    String? displayName,
    String? bio,
    bool? isActive,
    bool? isAuthenticated,
  }) {
    return UserProfile(
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      isActive: isActive ?? this.isActive,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
