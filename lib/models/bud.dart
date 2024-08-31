class Bud {
  final String? uid;
  final String username;  // Make this non-nullable
  final String? email;
  final String? photoUrl;
  final String? bio;
  final String? displayName;
  final bool isActive;
  final bool isAuthenticated;

  Bud({
    this.uid,
    required this.username,  // Make this required
    this.email,
    this.photoUrl,
    this.bio,
    this.displayName,
    required this.isActive,
    required this.isAuthenticated,
  });

  factory Bud.fromJson(Map<String, dynamic> json) {
    return Bud(
      uid: json['uid']?.toString(),
      username: json['username']?.toString() ?? 'Unknown User',  // Provide a default value
      email: json['email']?.toString(),
      photoUrl: json['photo_url']?.toString(),
      bio: json['bio']?.toString(),
      displayName: json['display_name']?.toString(),
      isActive: json['is_active'] ?? false,
      isAuthenticated: json['is_authenticated'] ?? false,
    );
  }
}
