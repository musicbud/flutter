import 'package:flutter/material.dart';
import 'components/settings_option.dart';
import '../../../core/theme/design_system.dart';
// MIGRATED: import '../../../widgets/common/index.dart';
import '../../widgets/enhanced/enhanced_widgets.dart';

class ProfileSettingsWidget extends StatelessWidget {
  const ProfileSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Settings',
          ),
          SizedBox(height: DesignSystem.spacingMD),

          // Settings Options
          SettingsOption(
            title: 'Account Settings',
            subtitle: 'Manage your account preferences',
            icon: Icons.settings,
          ),
          SizedBox(height: DesignSystem.spacingSM),
          SettingsOption(
            title: 'Privacy',
            subtitle: 'Control your privacy settings',
            icon: Icons.privacy_tip,
          ),
          SizedBox(height: DesignSystem.spacingSM),
          SettingsOption(
            title: 'Notifications',
            subtitle: 'Customize notification preferences',
            icon: Icons.notifications,
          ),
          SizedBox(height: DesignSystem.spacingSM),
          SettingsOption(
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            icon: Icons.help,
          ),
        ],
      ),
    );
  }
}
