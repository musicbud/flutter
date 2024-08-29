class UserProfile {
  final String uid;
  final String username;
  final String? email;
  final String? photoUrl;
  final String? bio;
  final String? displayName;
  final bool isActive;
  final bool isAuthenticated;
  final String accessToken;

  UserProfile({
    required this.uid,
    required this.username,
    this.email,
    this.photoUrl,
    this.bio,
    this.displayName,
    required this.isActive,
    required this.isAuthenticated,
    required this.accessToken,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>;
    return UserProfile(
      uid: profile['uid'] as String,
      username: profile['username'] as String,
      email: profile['email'] as String?,
      photoUrl: profile['photo_url'] as String?,
      bio: profile['bio'] as String?,
      displayName: profile['display_name'] as String?,
      isActive: profile['is_active'] as bool,
      isAuthenticated: profile['is_authenticated'] as bool,
      accessToken: profile['access_token'] as String,
    );
  }
}
