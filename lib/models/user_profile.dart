class UserProfile {
  final String username;
  final String email;
  String? photoUrl;
  String? displayName;
  String? bio;
  bool isActive;
  bool isAuthenticated;

  UserProfile({
    required this.username,
    required this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.isActive = false,
    this.isAuthenticated = false,
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

  UserProfile copyWith({
    String? photoUrl,
    String? displayName,
    String? bio,
    bool? isActive,
    bool? isAuthenticated,
  }) {
    return UserProfile(
      username: this.username,
      email: this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      isActive: isActive ?? this.isActive,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  String toString() {
    return 'UserProfile(username: $username, email: $email, photoUrl: $photoUrl, displayName: $displayName, bio: $bio, isActive: $isActive, isAuthenticated: $isAuthenticated)';
  }
}
