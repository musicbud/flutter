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
  bool _darkModeEnabled = true;
  bool _autoPlayEnabled = false;
  bool _highQualityEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Dark';

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
  ];

  final List<String> _themes = [
    'Light',
    'Dark',
    'Auto',
  ];

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: appTheme.gradients.backgroundGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: appTheme.typography.headlineH5.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.sm),
                    Text(
                      'Customize your MusicBud experience',
                      style: appTheme.typography.bodyMedium.copyWith(
                        color: appTheme.colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Account Settings Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: appTheme.typography.headlineH7.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),

                    _buildSettingsCard(
                      'Profile Settings',
                      'Manage your account and profile information',
                      Icons.person,
                      appTheme.colors.accentBlue,
                      () {
                        // Navigate to profile settings
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildSettingsCard(
                      'Privacy & Security',
                      'Control your privacy settings and security options',
                      Icons.privacy_tip,
                      appTheme.colors.accentGreen,
                      () {
                        // Navigate to privacy settings
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildSettingsCard(
                      'Subscription',
                      'Manage your premium subscription and billing',
                      Icons.star,
                      appTheme.colors.accentOrange,
                      () {
                        // Navigate to subscription
                      },
                      appTheme,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Preferences Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferences',
                      style: appTheme.typography.headlineH7.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),

                    _buildToggleCard(
                      'Notifications',
                      'Receive push notifications for new music and updates',
                      Icons.notifications,
                      appTheme.colors.primaryRed,
                      _notificationsEnabled,
                      (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildToggleCard(
                      'Dark Mode',
                      'Use dark theme for better viewing experience',
                      Icons.dark_mode,
                      appTheme.colors.accentPurple,
                      _darkModeEnabled,
                      (value) {
                        setState(() {
                          _darkModeEnabled = value;
                        });
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildToggleCard(
                      'Auto Play',
                      'Automatically play next track in queue',
                      Icons.play_circle,
                      appTheme.colors.accentBlue,
                      _autoPlayEnabled,
                      (value) {
                        setState(() {
                          _autoPlayEnabled = value;
                        });
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildToggleCard(
                      'High Quality Audio',
                      'Stream music in high quality (uses more data)',
                      Icons.high_quality,
                      appTheme.colors.accentGreen,
                      _highQualityEnabled,
                      (value) {
                        setState(() {
                          _highQualityEnabled = value;
                        });
                      },
                      appTheme,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Appearance Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: appTheme.typography.headlineH7.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),

                    _buildSelectionCard(
                      'Language',
                      'Choose your preferred language',
                      Icons.language,
                      appTheme.colors.accentBlue,
                      _selectedLanguage,
                      _languages,
                      (value) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildSelectionCard(
                      'Theme',
                      'Select your preferred app theme',
                      Icons.palette,
                      appTheme.colors.accentPurple,
                      _selectedTheme,
                      _themes,
                      (value) {
                        setState(() {
                          _selectedTheme = value;
                        });
                      },
                      appTheme,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Storage Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storage & Data',
                      style: appTheme.typography.headlineH7.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),

                    _buildSettingsCard(
                      'Storage Usage',
                      'Manage your downloaded music and cache',
                      Icons.storage,
                      appTheme.colors.accentOrange,
                      () {
                        // Navigate to storage settings
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildSettingsCard(
                      'Data Usage',
                      'Monitor and control your data consumption',
                      Icons.data_usage,
                      appTheme.colors.accentGreen,
                      () {
                        // Navigate to data usage
                      },
                      appTheme,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Support Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support & Feedback',
                      style: appTheme.typography.headlineH7.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),

                    _buildSettingsCard(
                      'Help Center',
                      'Get help and find answers to common questions',
                      Icons.help,
                      appTheme.colors.accentBlue,
                      () {
                        // Navigate to help center
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildSettingsCard(
                      'Contact Support',
                      'Get in touch with our support team',
                      Icons.support_agent,
                      appTheme.colors.accentGreen,
                      () {
                        // Navigate to contact support
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildSettingsCard(
                      'Send Feedback',
                      'Help us improve by sending your feedback',
                      Icons.feedback,
                      appTheme.colors.accentPurple,
                      () {
                        // Navigate to feedback
                      },
                      appTheme,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),

            // About Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: appTheme.typography.headlineH7.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),

                    _buildSettingsCard(
                      'App Version',
                      'MusicBud v2.1.0',
                      Icons.info,
                      appTheme.colors.textMuted,
                      () {
                        // Show version info
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildSettingsCard(
                      'Terms of Service',
                      'Read our terms and conditions',
                      Icons.description,
                      appTheme.colors.textMuted,
                      () {
                        // Navigate to terms
                      },
                      appTheme,
                    ),
                    SizedBox(height: appTheme.spacing.sm),

                    _buildSettingsCard(
                      'Privacy Policy',
                      'Learn about our privacy practices',
                      Icons.policy,
                      appTheme.colors.textMuted,
                      () {
                        // Navigate to privacy policy
                      },
                      appTheme,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Logout Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: OutlineButton(
                  text: 'Logout',
                  onPressed: () {
                    // Handle logout
                  },
                  icon: Icons.logout,
                  size: ModernButtonSize.large,
                  isFullWidth: true,
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    String title,
    String subtitle,
    IconData icon,
    Color accentColor,
    VoidCallback onTap,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.secondary,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.sm),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
          ),
          SizedBox(width: appTheme.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTheme.typography.titleSmall.copyWith(
                    color: appTheme.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  subtitle,
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: appTheme.colors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard(
    String title,
    String subtitle,
    IconData icon,
    Color accentColor,
    bool value,
    ValueChanged<bool> onChanged,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.secondary,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.sm),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
          ),
          SizedBox(width: appTheme.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTheme.typography.titleSmall.copyWith(
                    color: appTheme.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  subtitle,
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: appTheme.colors.primaryRed,
            activeTrackColor: appTheme.colors.primaryRed.withValues(alpha: 0.3),
            inactiveThumbColor: appTheme.colors.textMuted,
            inactiveTrackColor: appTheme.colors.surfaceLight,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard(
    String title,
    String subtitle,
    IconData icon,
    Color accentColor,
    String selectedValue,
    List<String> options,
    ValueChanged<String> onChanged,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.secondary,
      onTap: () {
        _showSelectionDialog(title, options, selectedValue, onChanged, appTheme);
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.sm),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
          ),
          SizedBox(width: appTheme.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTheme.typography.titleSmall.copyWith(
                    color: appTheme.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  subtitle,
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                selectedValue,
                style: appTheme.typography.bodySmall.copyWith(
                  color: appTheme.colors.textSecondary,
                ),
              ),
              SizedBox(width: appTheme.spacing.xs),
              Icon(
                Icons.chevron_right,
                color: appTheme.colors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSelectionDialog(
    String title,
    List<String> options,
    String selectedValue,
    ValueChanged<String> onChanged,
    AppTheme appTheme,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.colors.surfaceDark,
          title: Text(
            title,
            style: appTheme.typography.titleMedium.copyWith(
              color: appTheme.colors.textPrimary,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option == selectedValue;

                return ListTile(
                  title: Text(
                    option,
                    style: appTheme.typography.bodyMedium.copyWith(
                      color: isSelected
                          ? appTheme.colors.primaryRed
                          : appTheme.colors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: appTheme.colors.primaryRed,
                        )
                      : null,
                  onTap: () {
                    onChanged(option);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            ModernTextButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              size: ModernButtonSize.small,
            ),
          ],
        );
      },
    );
  }
}