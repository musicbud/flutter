import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/design_system.dart';
import '../../../blocs/settings/settings_bloc.dart';
import '../../../blocs/settings/settings_event.dart';
import '../../../blocs/settings/settings_state.dart';
import '../../../blocs/auth/auth_bloc.dart';

class EnhancedSettingsScreen extends StatelessWidget {
  const EnhancedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: DesignSystem.headlineSmall,
        ),
        backgroundColor: DesignSystem.surface,
      ),
      body: ListView(
        padding: EdgeInsets.all(DesignSystem.spacingMD),
        children: <Widget>[
          _buildUserSection(context),
          SizedBox(height: DesignSystem.spacingLG),
          _buildAccountSection(context),
          SizedBox(height: DesignSystem.spacingLG),
          _buildMusicSection(context),
          SizedBox(height: DesignSystem.spacingLG),
          _buildPrivacySection(context),
          SizedBox(height: DesignSystem.spacingLG),
          _buildNotificationSection(context),
          SizedBox(height: DesignSystem.spacingLG),
          _buildAppearanceSection(context),
          SizedBox(height: DesignSystem.spacingLG),
          _buildAboutSection(context),
          SizedBox(height: DesignSystem.spacingLG),
          _buildDangerZone(context),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingMD),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: DesignSystem.primary.withAlpha((255 * 0.1).round()),
              child: const Icon(
                Icons.person,
                size: 30,
                color: DesignSystem.primary,
              ),
            ),
            const SizedBox(width: DesignSystem.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Demo User',
                    style: DesignSystem.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    'demo@musicbud.com',
                    style: DesignSystem.bodyMedium.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSettingsSection(
      title: 'Account',
      children: [
        _buildSettingsTile(
          icon: Icons.person_outline,
          title: 'Edit Profile',
          subtitle: 'Update your profile information',
          onTap: () => Navigator.pushNamed(context, '/edit-profile'),
        ),
        _buildSettingsTile(
          icon: Icons.link,
          title: 'Connected Services',
          subtitle: 'Manage your music service connections',
          onTap: () => Navigator.pushNamed(context, '/connect-services'),
        ),
        _buildSettingsTile(
          icon: Icons.security,
          title: 'Privacy & Security',
          subtitle: 'Control your privacy settings',
          onTap: () {
            _showComingSoon(context, 'Privacy & Security');
          },
        ),
      ],
    );
  }

  Widget _buildMusicSection(BuildContext context) {
    return _buildSettingsSection(
      title: 'Music',
      children: [
        SwitchListTile(
          title: const Text('High Quality Audio'),
          subtitle: const Text('Stream music in high quality'),
          value: true, // Default value for now
          onChanged: (value) {
            // TODO: Implement settings update when event is available
            _showComingSoon(context, 'High Quality Audio Settings');
          },
          activeThumbColor: DesignSystem.primary,
        ),
        SwitchListTile(
          title: const Text('Auto-play Similar Music'),
          subtitle: const Text('Continue playing similar music when a song ends'),
          value: false, // Default value for now
          onChanged: (value) {
            _showComingSoon(context, 'Auto-play Settings');
          },
          activeThumbColor: DesignSystem.primary,
        ),
        _buildSettingsTile(
          icon: Icons.equalizer,
          title: 'Audio Equalizer',
          subtitle: 'Customize your sound experience',
          onTap: () {
            _showComingSoon(context, 'Audio Equalizer');
          },
        ),
      ],
    );
  }

  Widget _buildPrivacySection(BuildContext context) {
    return _buildSettingsSection(
      title: 'Privacy',
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            bool showActivity = true;
            if (state is SettingsLoaded) {
              showActivity = state.privacy.activityVisible;
            }
            
            return SwitchListTile(
              title: const Text('Share Listening Activity'),
              subtitle: const Text('Let friends see what you\'re listening to'),
              value: showActivity,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdatePrivacySettingsEvent(
                    profileVisible: state is SettingsLoaded ? state.privacy.profileVisible : true,
                    locationVisible: state is SettingsLoaded ? state.privacy.locationVisible : true,
                    activityVisible: value,
                  ),
                );
              },
              activeThumbColor: DesignSystem.primary,
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            bool privateProfile = false;
            if (state is SettingsLoaded) {
              privateProfile = !state.privacy.profileVisible;
            }
            
            return SwitchListTile(
              title: const Text('Private Profile'),
              subtitle: const Text('Only approved followers can see your profile'),
              value: privateProfile,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdatePrivacySettingsEvent(
                    profileVisible: !value,
                    locationVisible: state is SettingsLoaded ? state.privacy.locationVisible : true,
                    activityVisible: state is SettingsLoaded ? state.privacy.activityVisible : true,
                  ),
                );
              },
              activeThumbColor: DesignSystem.primary,
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection(BuildContext context) {
    return _buildSettingsSection(
      title: 'Notifications',
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            bool pushNotifications = true;
            if (state is SettingsLoaded) {
              pushNotifications = state.notifications.pushEnabled;
            }
            
            return SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Get notified about new matches and messages'),
              value: pushNotifications,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdateNotificationSettingsEvent(
                    enabled: state is SettingsLoaded ? state.notifications.enabled : true,
                    pushEnabled: value,
                    emailEnabled: state is SettingsLoaded ? state.notifications.emailEnabled : false,
                    soundEnabled: state is SettingsLoaded ? state.notifications.soundEnabled : true,
                  ),
                );
              },
              activeThumbColor: DesignSystem.primary,
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            bool emailNotifications = false;
            if (state is SettingsLoaded) {
              emailNotifications = state.notifications.emailEnabled;
            }
            
            return SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive updates and news via email'),
              value: emailNotifications,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdateNotificationSettingsEvent(
                    enabled: state is SettingsLoaded ? state.notifications.enabled : true,
                    pushEnabled: state is SettingsLoaded ? state.notifications.pushEnabled : true,
                    emailEnabled: value,
                    soundEnabled: state is SettingsLoaded ? state.notifications.soundEnabled : true,
                  ),
                );
              },
              activeThumbColor: DesignSystem.primary,
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return _buildSettingsSection(
      title: 'Appearance',
      children: [
        _buildSettingsTile(
          icon: Icons.palette,
          title: 'Theme',
          subtitle: 'Choose your preferred theme',
          trailing: Text(
            'Dark',
            style: DesignSystem.bodyMedium.copyWith(color: Colors.grey),
          ),
          onTap: () {
            _showThemeSelector(context);
          },
        ),
        _buildSettingsTile(
          icon: Icons.text_fields,
          title: 'Font Size',
          subtitle: 'Adjust text size for better readability',
          trailing: Text(
            'Medium',
            style: DesignSystem.bodyMedium.copyWith(color: Colors.grey),
          ),
          onTap: () {
            _showComingSoon(context, 'Font Size');
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSettingsSection(
      title: 'About',
      children: [
        _buildSettingsTile(
          icon: Icons.info_outline,
          title: 'App Version',
          subtitle: 'Version 1.0.0 (Beta)',
          onTap: () {
            _showAboutDialog(context);
          },
        ),
        _buildSettingsTile(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get help or contact support',
          onTap: () {
            _showComingSoon(context, 'Help & Support');
          },
        ),
        _buildSettingsTile(
          icon: Icons.description,
          title: 'Terms of Service',
          subtitle: 'Read our terms and conditions',
          onTap: () {
            _showComingSoon(context, 'Terms of Service');
          },
        ),
        _buildSettingsTile(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          subtitle: 'Learn how we protect your data',
          onTap: () {
            _showComingSoon(context, 'Privacy Policy');
          },
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return _buildSettingsSection(
      title: 'Account Actions',
      children: [
        _buildSettingsTile(
          icon: Icons.logout,
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          titleColor: Colors.orange,
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
        _buildSettingsTile(
          icon: Icons.delete_forever,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          titleColor: Colors.red,
          onTap: () {
            _showDeleteAccountDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: DesignSystem.spacingMD),
          child: Text(
            title,
            style: DesignSystem.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: DesignSystem.primary,
            ),
          ),
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              child: Text(
                'Choose Theme',
                style: DesignSystem.bodyLarge.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('System'),
              trailing: const Icon(Icons.check),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MusicBud',
      applicationVersion: '1.0.0 (Beta)',
      applicationIcon: const Icon(
        Icons.music_note,
        size: 48,
        color: DesignSystem.primary,
      ),
      children: [
        const Text(
          'MusicBud helps you discover new music and connect with others who share your taste.',
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon(context, 'Account Deletion');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        backgroundColor: DesignSystem.primary,
      ),
    );
  }
}