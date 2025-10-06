import 'package:flutter/material.dart';
import '../../widgets/common/section_header.dart';
import 'components/settings_option.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/index.dart';

class ProfileSettingsWidget extends StatelessWidget {
  const ProfileSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Settings',
          ),
          SizedBox(height: appTheme.spacing.md),

          // Settings Options
          const SettingsOption(
            title: 'Account Settings',
            subtitle: 'Manage your account preferences',
            icon: Icons.settings,
          ),
          SizedBox(height: appTheme.spacing.sm),
          const SettingsOption(
            title: 'Privacy',
            subtitle: 'Control your privacy settings',
            icon: Icons.privacy_tip,
          ),
          SizedBox(height: appTheme.spacing.sm),
          const SettingsOption(
            title: 'Notifications',
            subtitle: 'Customize notification preferences',
            icon: Icons.notifications,
          ),
          SizedBox(height: appTheme.spacing.sm),
          const SettingsOption(
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            icon: Icons.help,
          ),
        ],
      ),
    );
  }
}