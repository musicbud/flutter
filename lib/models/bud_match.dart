import 'package:equatable/equatable.dart';

/// A model class representing a match with another user (bud) based on common interests
class BudMatch extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? email;
  final String? avatarUrl;
  final double matchScore;
  final int commonArtists;
  final int commonTracks;
  final int commonGenres;
  
  // Additional properties needed by dynamic_buds_screen
  final String? displayName;
  final String? bio;
  final String? profileImageUrl;

  const BudMatch({
    required this.id,
    required this.userId,
    required this.username,
    this.email,
    this.avatarUrl,
    required this.matchScore,
    required this.commonArtists,
    required this.commonTracks,
    required this.commonGenres,
    this.displayName,
    this.bio,
    this.profileImageUrl,
  });

  /// Creates a [BudMatch] from a JSON map
  factory BudMatch.fromJson(Map<String, dynamic> json) {
    // Handle backend response structure from Postman collection
    // Backend can return user data directly or nested in 'bud' key
    final budData = json['bud'] as Map<String, dynamic>? ?? json;
    
    final id = budData['uid'] as String? ?? budData['bud_uid'] as String? ?? budData['id'] as String? ?? '';
    final userId = budData['uid'] as String? ?? budData['bud_uid'] as String? ?? budData['id'] as String? ?? '';
    final username = budData['username'] as String? ?? budData['display_name'] as String? ?? 'Unknown User';
    final email = budData['email'] as String?;
    
    // Additional properties
    final displayName = budData['display_name'] as String? ?? budData['displayName'] as String? ?? username;
    final bio = budData['bio'] as String? ?? budData['description'] as String?;
    final profileImageUrl = budData['profile_image_url'] as String? ?? budData['profileImageUrl'] as String? ?? budData['avatar_url'] as String?;

    // Handle avatar URL - backend returns images array, take first one
    String? avatarUrl = budData['avatar_url'] as String?;
    if (avatarUrl == null && budData['images'] is List && (budData['images'] as List).isNotEmpty) {
      final images = budData['images'] as List;
      if (images.isNotEmpty && images[0] is String) {
        avatarUrl = images[0] as String;
      } else if (images.isNotEmpty && images[0] is Map<String, dynamic>) {
        avatarUrl = images[0]['url'] as String?;
      }
    }

    // Extract common counts from response
    final commonArtists = budData['commonArtistsCount'] as int? ?? 
                          budData['common_artists_count'] as int? ?? 
                          (budData['commonArtists'] as List?)?.length ?? 0;
    final commonTracks = budData['commonTracksCount'] as int? ?? 
                         budData['common_tracks_count'] as int? ?? 
                         (budData['commonTracks'] as List?)?.length ?? 0;
    final commonGenres = budData['commonGenresCount'] as int? ?? 
                         budData['common_genres_count'] as int? ?? 
                         (budData['commonGenres'] as List?)?.length ?? 0;

    // Calculate match score based on common items if not provided
    double matchScore = 0.0;
    if (json['similarity_score'] != null) {
      matchScore = (json['similarity_score'] as num).toDouble();
    } else {
      // Calculate a simple match score based on common items
      final totalCommon = commonArtists + commonTracks + commonGenres;
      matchScore = totalCommon > 0 ? (totalCommon / 10.0).clamp(0.0, 1.0) : 0.0;
    }

    return BudMatch(
      id: id,
      userId: userId,
      username: username,
      email: email,
      avatarUrl: avatarUrl,
      matchScore: matchScore,
      commonArtists: commonArtists,
      commonTracks: commonTracks,
      commonGenres: commonGenres,
      displayName: displayName,
      bio: bio,
      profileImageUrl: profileImageUrl,
    );
  }

  /// Converts this [BudMatch] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'match_score': matchScore,
      'common_artists': commonArtists,
      'common_tracks': commonTracks,
      'common_genres': commonGenres,
      'display_name': displayName,
      'bio': bio,
      'profile_image_url': profileImageUrl,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        username,
        email,
        avatarUrl,
        matchScore,
        commonArtists,
        commonTracks,
        commonGenres,
        displayName,
        bio,
        profileImageUrl,
      ];
}
