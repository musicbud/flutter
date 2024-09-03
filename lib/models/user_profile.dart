class UserProfile {
  final String uid;
  final String username;
  final String email;
  String? photoUrl;  // Changed to non-final

  final String? bio;
  final String? displayName;
  final bool isActive;
  final bool isAuthenticated;

  UserProfile({
    required this.uid,
    required this.username,
    required this.email,
    this.photoUrl,
    this.bio,
    this.displayName,
    required this.isActive,
    required this.isAuthenticated,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'];
    return UserProfile(
      uid: profile['uid'],
      username: profile['username'],
      email: profile['email'],
      photoUrl: profile['photo_url'],
      bio: profile['bio'],
      displayName: profile['display_name'],
      isActive: profile['is_active'],
      isAuthenticated: profile['is_authenticated'],
    );
  }
}
