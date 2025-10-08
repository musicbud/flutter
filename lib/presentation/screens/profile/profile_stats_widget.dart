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
    final designSystemColors = Theme.of(context).designSystemColors!;
    final designSystemSpacing = Theme.of(context).designSystemSpacing!;
    final designSystemTypography = Theme.of(context).designSystemTypography!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Followers', userProfile.followersCount.toString(), designSystemColors, designSystemSpacing, designSystemTypography),
        _buildStatItem('Following', userProfile.followingCount.toString(), designSystemColors, designSystemSpacing, designSystemTypography),
        // TODO: Add tracksCount to UserProfile model
        _buildStatItem('Tracks', '0', designSystemColors, designSystemSpacing, designSystemTypography),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, DesignSystemColors designSystemColors, DesignSystemSpacing designSystemSpacing, DesignSystemTypography designSystemTypography) {
    return Column(
      children: [
        Text(
          value,
          style: designSystemTypography.titleSmall.copyWith(
            color: designSystemColors.error,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: designSystemSpacing.xs),
        Text(
          label,
          style: designSystemTypography.caption.copyWith(
            color: designSystemColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}