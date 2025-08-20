import 'package:flutter/material.dart';

/// A reusable profile information section widget
class ProfileInfoSection extends StatelessWidget {
  final String? username;
  final String? bio;
  final String? location;
  final List<ProfileStat> stats;
  final EdgeInsetsGeometry? padding;
  final TextStyle? usernameStyle;
  final TextStyle? bioStyle;
  final TextStyle? locationStyle;
  final TextStyle? statsStyle;

  const ProfileInfoSection({
    Key? key,
    this.username,
    this.bio,
    this.location,
    this.stats = const [],
    this.padding,
    this.usernameStyle,
    this.bioStyle,
    this.locationStyle,
    this.statsStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username
          if (username != null) ...[
            Text(
              username!,
              style: usernameStyle ?? const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
          ],

          // Bio
          if (bio != null && bio!.isNotEmpty) ...[
            Text(
              bio!,
              style: bioStyle ?? const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Location
          if (location != null) ...[
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70),
                const SizedBox(width: 5),
                Text(
                  location!,
                  style: locationStyle ?? const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          // Stats
          if (stats.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: stats.map((stat) => _buildStatItem(stat)).toList(),
            ),
            const Divider(thickness: 3, color: Colors.white24),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(ProfileStat stat) {
    return Column(
      children: [
        Text(
          stat.value,
          style: statsStyle ?? const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          stat.label,
          style: statsStyle?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ) ?? const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// Data class for profile statistics
class ProfileStat {
  final String label;
  final String value;

  const ProfileStat({
    required this.label,
    required this.value,
  });
}