import '../../domain/models/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.username,
    super.email,
    super.avatarUrl,
    super.bio,
    super.displayName,
    required super.isActive,
    super.isAuthenticated,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    print('UserProfileModel: Creating from JSON: $json');
    try {
      return UserProfileModel(
        id: json['id']?.toString() ?? json['uid']?.toString() ?? '',
        username: json['username']?.toString() ?? '',
        email: json['email']?.toString(),
        avatarUrl: json['avatar_url']?.toString() ?? json['avatarUrl']?.toString(),
        bio: json['bio']?.toString(),
        displayName: json['display_name']?.toString() ?? json['displayName']?.toString(),
        isActive: json['is_active'] == true || json['isActive'] == true,
        isAuthenticated: json['is_authenticated'] == true || json['isAuthenticated'] == true,
      );
    } catch (e, stackTrace) {
      print('UserProfileModel: Error parsing JSON: $e');
      print('UserProfileModel: Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Converts this [UserProfileModel] to a JSON map
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'bio': bio,
      'display_name': displayName,
      'is_active': isActive,
      'is_authenticated': isAuthenticated,
    };
  }
}
