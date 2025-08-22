import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoPlayEnabled = true;
  bool _highQualityAudio = false;
  String _selectedLanguage = 'English';
  String _selectedRegion = 'United States';

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.background,
      appBar: AppBar(
        backgroundColor: appTheme.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: appTheme.colors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(appTheme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            _buildSectionHeader('Account', Icons.person, appTheme),
            SizedBox(height: appTheme.spacing.md),
            _buildSettingTile(
              'Edit Profile',
              'Update your personal information',
              Icons.edit,
              () {},
              appTheme,
            ),
            _buildSettingTile(
              'Privacy Settings',
              'Control your privacy and security',
              Icons.privacy_tip,
              () {},
              appTheme,
            ),
            _buildSettingTile(
              'Connected Services',
              'Manage your music service connections',
              Icons.link,
              () {},
              appTheme,
            ),

            SizedBox(height: appTheme.spacing.xl),

            // App Settings
            _buildSectionHeader('App Settings', Icons.settings, appTheme),
            SizedBox(height: appTheme.spacing.md),
            _buildSwitchTile(
              'Notifications',
              'Receive push notifications',
              Icons.notifications,
              _notificationsEnabled,
              (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              appTheme,
            ),
            _buildSwitchTile(
              'Dark Mode',
              'Use dark theme',
              Icons.dark_mode,
              _darkModeEnabled,
              (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
              appTheme,
            ),
            _buildSwitchTile(
              'Auto-play',
              'Automatically play next track',
              Icons.play_circle,
              _autoPlayEnabled,
              (value) {
                setState(() {
                  _autoPlayEnabled = value;
                });
              },
              appTheme,
            ),
            _buildSwitchTile(
              'High Quality Audio',
              'Stream in high quality (uses more data)',
              Icons.high_quality,
              _highQualityAudio,
              (value) {
                setState(() {
                  _highQualityAudio = value;
                });
              },
              appTheme,
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Language & Region
            _buildSectionHeader('Language & Region', Icons.language, appTheme),
            SizedBox(height: appTheme.spacing.md),
            _buildDropdownTile(
              'Language',
              _selectedLanguage,
              ['English', 'Spanish', 'French', 'German', 'Japanese'],
              (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              appTheme,
            ),
            _buildDropdownTile(
              'Region',
              _selectedRegion,
              ['United States', 'United Kingdom', 'Canada', 'Australia', 'Germany'],
              (value) {
                setState(() {
                  _selectedRegion = value!;
                });
              },
              appTheme,
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Support & About
            _buildSectionHeader('Support & About', Icons.help, appTheme),
            SizedBox(height: appTheme.spacing.md),
            _buildSettingTile(
              'Help & Support',
              'Get help and contact support',
              Icons.help_outline,
              () {},
              appTheme,
            ),
            _buildSettingTile(
              'Terms of Service',
              'Read our terms and conditions',
              Icons.description,
              () {},
              appTheme,
            ),
            _buildSettingTile(
              'Privacy Policy',
              'Read our privacy policy',
              Icons.privacy_tip_outlined,
              () {},
              appTheme,
            ),
            _buildSettingTile(
              'About MusicBud',
              'App version and information',
              Icons.info_outline,
              () {},
              appTheme,
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Danger Zone
            _buildSectionHeader('Danger Zone', Icons.warning, appTheme),
            SizedBox(height: appTheme.spacing.md),
            _buildDangerTile(
              'Delete Account',
              'Permanently delete your account and data',
              Icons.delete_forever,
              () {
                _showDeleteAccountDialog(context, appTheme);
              },
              appTheme,
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () {
                  _showLogoutDialog(context, appTheme);
                },
                text: 'Logout',
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.large,
                icon: Icons.logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, AppTheme appTheme) {
    return Row(
      children: [
        Icon(
          icon,
          color: appTheme.colors.primaryRed,
          size: 24,
        ),
        SizedBox(width: appTheme.spacing.sm),
        Text(
          title,
          style: appTheme.typography.titleMedium.copyWith(
            color: appTheme.colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    AppTheme appTheme,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: appTheme.spacing.sm),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(appTheme.spacing.sm),
          decoration: BoxDecoration(
            color: appTheme.colors.primaryRed.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(appTheme.radius.md),
          ),
          child: Icon(
            icon,
            color: appTheme.colors.primaryRed,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: appTheme.typography.bodyMedium.copyWith(
            color: appTheme.colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: appTheme.typography.bodySmall.copyWith(
            color: appTheme.colors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: appTheme.colors.textSecondary,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    AppTheme appTheme,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: appTheme.spacing.sm),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(appTheme.spacing.sm),
          decoration: BoxDecoration(
            color: appTheme.colors.primaryRed.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(appTheme.radius.md),
          ),
          child: Icon(
            icon,
            color: appTheme.colors.primaryRed,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: appTheme.typography.bodyMedium.copyWith(
            color: appTheme.colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: appTheme.typography.bodySmall.copyWith(
            color: appTheme.colors.textSecondary,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: appTheme.colors.primaryRed,
        ),
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
    AppTheme appTheme,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: appTheme.spacing.sm),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(appTheme.spacing.sm),
          decoration: BoxDecoration(
            color: appTheme.colors.primaryRed.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(appTheme.radius.md),
          ),
          child: Icon(
            Icons.language,
            color: appTheme.colors.primaryRed,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: appTheme.typography.bodyMedium.copyWith(
            color: appTheme.colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: appTheme.typography.bodySmall.copyWith(
            color: appTheme.colors.textSecondary,
          ),
        ),
        trailing: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDangerTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    AppTheme appTheme,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: appTheme.spacing.sm),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(appTheme.spacing.sm),
          decoration: BoxDecoration(
            color: appTheme.colors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(appTheme.radius.md),
          ),
          child: Icon(
            icon,
            color: appTheme.colors.error,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: appTheme.typography.bodyMedium.copyWith(
            color: appTheme.colors.error,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: appTheme.typography.bodySmall.copyWith(
            color: appTheme.colors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: appTheme.colors.error,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AppTheme appTheme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.colors.background,
          title: Text(
            'Delete Account',
            style: appTheme.typography.headlineH6.copyWith(
              color: appTheme.colors.error,
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
            style: appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.textPrimary,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: appTheme.typography.bodyMedium.copyWith(
                  color: appTheme.colors.textSecondary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: appTheme.typography.bodyMedium.copyWith(
                  color: appTheme.colors.error,
                ),
              ),
              onPressed: () {
                // Handle account deletion
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AppTheme appTheme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.colors.background,
          title: Text(
            'Logout',
            style: appTheme.typography.headlineH6.copyWith(
              color: appTheme.colors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.textPrimary,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: appTheme.typography.bodyMedium.copyWith(
                  color: appTheme.colors.textSecondary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Logout',
                style: appTheme.typography.bodyMedium.copyWith(
                  color: appTheme.colors.primaryRed,
                ),
              ),
              onPressed: () {
                // Handle logout
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}