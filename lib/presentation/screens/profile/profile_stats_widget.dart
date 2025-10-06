import 'package:flutter/material.dart';
import '../../../domain/models/user_profile.dart';
import '../../../core/theme/app_theme.dart';

class ProfileStatsWidget extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileStatsWidget({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Followers', userProfile.followersCount?.toString() ?? '0', appTheme),
        _buildStatItem('Following', '856', appTheme),
        _buildStatItem('Tracks', '324', appTheme),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, AppTheme appTheme) {
    return Column(
      children: [
        Text(
          value,
          style: appTheme.typography.headlineH7.copyWith(
            color: appTheme.colors.primaryRed,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: appTheme.spacing.xs),
        Text(
          label,
          style: appTheme.typography.caption.copyWith(
            color: appTheme.colors.textMuted,
          ),
        ),
      ],
    );
  }
}