import 'package:flutter/material.dart';
import 'components/settings_option.dart';
import '../../../core/theme/design_system.dart';
import '../../../widgets/common/index.dart';

class ProfileSettingsWidget extends StatelessWidget {
  const ProfileSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final designSystemSpacing = Theme.of(context).designSystemSpacing!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Settings',
          ),
          SizedBox(height: designSystemSpacing.md),

          // Settings Options
          const SettingsOption(
            title: 'Account Settings',
            subtitle: 'Manage your account preferences',
            icon: Icons.settings,
          ),
          SizedBox(height: designSystemSpacing.sm),
          const SettingsOption(
            title: 'Privacy',
            subtitle: 'Control your privacy settings',
            icon: Icons.privacy_tip,
          ),
          SizedBox(height: designSystemSpacing.sm),
          const SettingsOption(
            title: 'Notifications',
            subtitle: 'Customize notification preferences',
            icon: Icons.notifications,
          ),
          SizedBox(height: designSystemSpacing.sm),
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