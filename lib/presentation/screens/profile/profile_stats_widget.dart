import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../core/theme/design_system.dart';

class ProfileStatsWidget extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileStatsWidget({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Followers', userProfile.followersCount.toString()),
        _buildStatItem('Following', userProfile.followingCount.toString()),
        // TODO: Add tracksCount to UserProfile model
        _buildStatItem('Tracks', '0'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: DesignSystem.titleSmall.copyWith(
            color: DesignSystem.error,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingXS),
        Text(
          label,
          style: DesignSystem.caption.copyWith(
            color: DesignSystem.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}