import 'package:flutter/material.dart';

/// A reusable profile header widget with cover image and avatar
class ProfileHeader extends StatelessWidget {
  final String? coverImageUrl;
  final String? avatarImageUrl;
  final String? fallbackCoverImage;
  final String? fallbackAvatarImage;
  final double coverHeight;
  final double avatarRadius;
  final EdgeInsetsGeometry? avatarPosition;
  final Widget? avatarOverlay;

  const ProfileHeader({
    super.key,
    this.coverImageUrl,
    this.avatarImageUrl,
    this.fallbackCoverImage = 'assets/cover.jpg',
    this.fallbackAvatarImage = 'assets/profile.jpg',
    this.coverHeight = 250,
    this.avatarRadius = 90,
    this.avatarPosition,
    this.avatarOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: coverHeight + (avatarRadius * 2),
      child: Stack(
        children: [
          // Cover Image
          Container(
            height: coverHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _getImageProvider(coverImageUrl, fallbackCoverImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Profile Avatar
          Positioned(
            top: coverHeight - avatarRadius,
            left: avatarPosition != null ? (avatarPosition as EdgeInsets).left : 20,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: _getImageProvider(avatarImageUrl, fallbackAvatarImage!),
                ),
                if (avatarOverlay != null) avatarOverlay!,
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String? networkUrl, String assetPath) {
    if (networkUrl != null && networkUrl.isNotEmpty) {
      try {
        return NetworkImage(networkUrl);
      } catch (e) {
        return AssetImage(assetPath) as ImageProvider;
      }
    }
    return AssetImage(assetPath) as ImageProvider;
  }
}