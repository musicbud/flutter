import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/dynamic_config_service.dart';
import '../../../services/dynamic_theme_service.dart';
import '../../../services/dynamic_navigation_service.dart';
import '../../../blocs/settings/settings_bloc.dart';
import '../../../blocs/settings/settings_event.dart';
import '../../../blocs/settings/settings_state.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';
import '../../../blocs/user/user_state.dart';

/// Dynamic settings screen that allows runtime configuration
class DynamicSettingsScreen extends StatefulWidget {
  const DynamicSettingsScreen({super.key});

  @override
  State<DynamicSettingsScreen> createState() => _DynamicSettingsScreenState();
}

class _DynamicSettingsScreenState extends State<DynamicSettingsScreen> {
  final DynamicConfigService _config = DynamicConfigService.instance;
  final DynamicThemeService _theme = DynamicThemeService.instance;
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;
  
  bool _hasTriggeredInitialLoad = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _triggerInitialDataLoad();
  }
  
  void _triggerInitialDataLoad() {
    if (!_hasTriggeredInitialLoad) {
      _hasTriggeredInitialLoad = true;
      // Load settings from BLoC
      context.read<SettingsBloc>().add(LoadSettingsEvent());
      // Load user profile for additional settings
      context.read<UserBloc>().add(LoadMyProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerInitialDataLoad();
    });

    return MultiBlocListener(
      listeners: [
        // Settings BLoC listener for state changes
        BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsLoading) {
              setState(() => _isLoading = true);
            } else if (state is SettingsLoaded) {
              setState(() => _isLoading = false);
              // Update UI based on new settings
            } else if (state is SettingsFailure) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Settings Error: ${state.message}'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
        ),
        // User BLoC listener for profile-related settings
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile Error: ${state.message}'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            } else if (state is UserActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          actions: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _reloadConfig,
                tooltip: 'Reload Configuration',
              ),
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: _showHelpDialog,
              tooltip: 'Help',
            ),
          ],
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (_isLoading && state is SettingsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            
            return RefreshIndicator(
              onRefresh: _refreshSettings,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildAccountSection(state),
                  const Divider(),
                  _buildThemeSection(state),
                  const Divider(),
                  _buildNotificationSection(state),
                  const Divider(),
                  _buildPrivacySection(state),
                  const Divider(),
                  _buildFeatureSection(),
                  const Divider(),
                  _buildServiceConnectionsSection(),
                  const Divider(),
                  _buildAdvancedSection(),
                  const Divider(),
                  _buildDangerZoneSection(),
                ],
              ),
            );
          },
        ),
    );
  }

  Widget _buildThemeSection() {
    return ExpansionTile(
      title: const Text('Theme & Appearance'),
      children: [
        ListTile(
          title: const Text('Theme Mode'),
          subtitle: Text(_theme.currentThemeName),
          trailing: DropdownButton<String>(
            value: _theme.currentThemeName,
            items: const [
              DropdownMenuItem(value: 'light', child: Text('Light')),
              DropdownMenuItem(value: 'dark', child: Text('Dark')),
              DropdownMenuItem(value: 'system', child: Text('System')),
            ],
            onChanged: (value) async {
              if (value != null) {
                await _theme.setTheme(ThemeMode.values.firstWhere((e) => e.toString() == value));
                setState(() {});
              }
            },
          ),
        ),
        SwitchListTile(
          title: const Text('Enable Animations'),
          subtitle: const Text('Enable smooth transitions and animations'),
          value: _theme.animationsEnabled,
          onChanged: (value) async {
            await _theme.setAnimationsEnabled(value);
            setState(() {});
          },
        ),
        SwitchListTile(
          title: const Text('Compact Mode'),
          subtitle: const Text('Reduce spacing and font sizes'),
          value: _theme.compactMode,
          onChanged: (value) async {
            await _theme.setCompactMode(value);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildFeatureSection() {
    final features = [
      'spotify_integration',
      'chat_system',
      'bud_matching',
      'music_discovery',
      'social_features',
    ];

    return ExpansionTile(
      title: const Text('Features'),
      children: features.map((feature) {
        final displayName = feature.replaceAll('_', ' ').split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');

        return SwitchListTile(
          title: Text(displayName),
          value: _config.isFeatureEnabled(feature),
          onChanged: (value) async {
            await _config.setFeatureEnabled(feature, value);
            setState(() {});
          },
        );
      }).toList(),
    );
  }

  Widget _buildUISection() {
    return ExpansionTile(
      title: const Text('User Interface'),
      children: [
        ListTile(
          title: const Text('Language'),
          subtitle: Text(_config.getLanguage()),
          trailing: DropdownButton<String>(
            value: _config.getLanguage(),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'es', child: Text('Spanish')),
              DropdownMenuItem(value: 'fr', child: Text('French')),
              DropdownMenuItem(value: 'de', child: Text('German')),
            ],
            onChanged: (value) async {
              if (value != null) {
                await _config.setLanguage(value);
                setState(() {});
              }
            },
          ),
        ),
        SwitchListTile(
          title: const Text('Show Tutorials'),
          subtitle: const Text('Display helpful tips and tutorials'),
          value: _config.get<bool>('ui.show_tutorials', defaultValue: true),
          onChanged: (value) async {
            await _config.set('ui.show_tutorials', value);
            setState(() {});
          },
        ),
        SwitchListTile(
          title: const Text('Show Onboarding'),
          subtitle: const Text('Show onboarding flow on first launch'),
          value: _config.get<bool>('ui.show_onboarding', defaultValue: true),
          onChanged: (value) async {
            await _config.set('ui.show_onboarding', value);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return ExpansionTile(
      title: const Text('Privacy & Data'),
      children: [
        SwitchListTile(
          title: const Text('Analytics'),
          subtitle: const Text('Help improve the app by sharing usage data'),
          value: _config.isAnalyticsEnabled(),
          onChanged: (value) async {
            await _config.setAnalyticsEnabled(value);
            setState(() {});
          },
        ),
        SwitchListTile(
          title: const Text('Crash Reporting'),
          subtitle: const Text('Automatically report crashes to help fix bugs'),
          value: _config.get<bool>('enable_crash_reporting', defaultValue: true),
          onChanged: (value) async {
            await _config.set('enable_crash_reporting', value);
            setState(() {});
          },
        ),
        SwitchListTile(
          title: const Text('Collect Analytics'),
          subtitle: const Text('Allow collection of analytics data'),
          value: _config.get<bool>('privacy.collect_analytics', defaultValue: true),
          onChanged: (value) async {
            await _config.set('privacy.collect_analytics', value);
            setState(() {});
          },
        ),
        SwitchListTile(
          title: const Text('Share Usage Data'),
          subtitle: const Text('Share anonymized usage data for research'),
          value: _config.get<bool>('privacy.share_usage_data', defaultValue: false),
          onChanged: (value) async {
            await _config.set('privacy.share_usage_data', value);
            setState(() {});
          },
        ),
        SwitchListTile(
          title: const Text('Location Services'),
          subtitle: const Text('Allow location-based features'),
          value: _config.get<bool>('privacy.enable_location', defaultValue: false),
          onChanged: (value) async {
            await _config.set('privacy.enable_location', value);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedSection() {
    return ExpansionTile(
      title: const Text('Advanced'),
      children: [
        ListTile(
          title: const Text('API Endpoint'),
          subtitle: Text(_config.getApiEndpoint()),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editApiEndpoint,
          ),
        ),
        ListTile(
          title: const Text('Cache Duration'),
          subtitle: Text('${_config.getCacheDuration()} seconds'),
          trailing: DropdownButton<int>(
            value: _config.getCacheDuration(),
            items: const [
              DropdownMenuItem(value: 300, child: Text('5 minutes')),
              DropdownMenuItem(value: 1800, child: Text('30 minutes')),
              DropdownMenuItem(value: 3600, child: Text('1 hour')),
              DropdownMenuItem(value: 7200, child: Text('2 hours')),
            ],
            onChanged: (value) async {
              if (value != null) {
                await _config.setCacheDuration(value);
                setState(() {});
              }
            },
          ),
        ),
        ListTile(
          title: const Text('Request Timeout'),
          subtitle: Text('${_config.getTimeout()} seconds'),
          trailing: DropdownButton<int>(
            value: _config.getTimeout(),
            items: const [
              DropdownMenuItem(value: 10, child: Text('10 seconds')),
              DropdownMenuItem(value: 30, child: Text('30 seconds')),
              DropdownMenuItem(value: 60, child: Text('1 minute')),
              DropdownMenuItem(value: 120, child: Text('2 minutes')),
            ],
            onChanged: (value) async {
              if (value != null) {
                await _config.setTimeout(value);
                setState(() {});
              }
            },
          ),
        ),
        ListTile(
          title: const Text('Max Retries'),
          subtitle: Text('${_config.getMaxRetries()} attempts'),
          trailing: DropdownButton<int>(
            value: _config.getMaxRetries(),
            items: const [
              DropdownMenuItem(value: 1, child: Text('1 retry')),
              DropdownMenuItem(value: 3, child: Text('3 retries')),
              DropdownMenuItem(value: 5, child: Text('5 retries')),
              DropdownMenuItem(value: 10, child: Text('10 retries')),
            ],
            onChanged: (value) async {
              if (value != null) {
                await _config.setMaxRetries(value);
                setState(() {});
              }
            },
          ),
        ),
        ListTile(
          title: const Text('Reset Configuration'),
          subtitle: const Text('Reset all settings to defaults'),
          trailing: IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetConfiguration,
          ),
        ),
      ],
    );
  }

  void _editApiEndpoint() {
    final controller = TextEditingController(text: _config.getApiEndpoint());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit API Endpoint'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'API Endpoint',
            hintText: 'https://api.example.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _config.set('api_endpoint', controller.text);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _resetConfiguration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Configuration'),
        content: const Text('Are you sure you want to reset all settings to defaults?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _config.reset();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshSettings() async {
    context.read<SettingsBloc>().add(LoadSettingsEvent());
  }

  void _reloadConfig() async {
    await _config.reload();
    context.read<SettingsBloc>().add(LoadSettingsEvent());
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration reloaded')),
      );
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Account: Manage your profile and account settings\n\n'
                'Theme: Customize the app appearance\n\n'
                'Notifications: Control when and how you receive notifications\n\n'
                'Privacy: Manage your data and privacy preferences\n\n'
                'Features: Enable or disable specific app features\n\n'
                'Services: Connect to external music services\n\n'
                'Advanced: Technical settings for power users',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(SettingsState state) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        return ExpansionTile(
          title: const Text('Account'),
          leading: const Icon(Icons.person),
          children: [
            ListTile(
              title: const Text('Profile'),
              subtitle: const Text('Edit your profile information'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _navigation.navigateTo('/profile/edit'),
            ),
            ListTile(
              title: const Text('Account Settings'),
              subtitle: const Text('Manage your account preferences'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showAccountSettings(),
            ),
            ListTile(
              title: const Text('Data & Storage'),
              subtitle: const Text('Manage your data and storage'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showDataSettings(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeSection(SettingsState state) {
    String currentTheme = 'system';
    if (state is SettingsLoaded) {
      currentTheme = state.theme ?? 'system';
    }

    return ExpansionTile(
      title: const Text('Theme & Appearance'),
      leading: const Icon(Icons.palette),
      children: [
        ListTile(
          title: const Text('Theme Mode'),
          subtitle: Text(currentTheme.toUpperCase()),
          trailing: DropdownButton<String>(
            value: currentTheme,
            items: const [
              DropdownMenuItem(value: 'light', child: Text('Light')),
              DropdownMenuItem(value: 'dark', child: Text('Dark')),
              DropdownMenuItem(value: 'system', child: Text('System')),
            ],
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                  UpdateThemeEvent(theme: value),
                );
              }
            },
          ),
        ),
        SwitchListTile(
          title: const Text('Enable Animations'),
          subtitle: const Text('Enable smooth transitions and animations'),
          value: _theme.animationsEnabled,
          onChanged: (value) async {
            await _theme.setAnimationsEnabled(value);
            setState(() {});
          },
        ),
        SwitchListTile(
          title: const Text('Compact Mode'),
          subtitle: const Text('Reduce spacing and font sizes'),
          value: _theme.compactMode,
          onChanged: (value) async {
            await _theme.setCompactMode(value);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection(SettingsState state) {
    bool notificationsEnabled = true;
    bool pushEnabled = true;
    bool emailEnabled = false;
    bool soundEnabled = true;

    if (state is SettingsLoaded) {
      notificationsEnabled = state.notifications.enabled;
      pushEnabled = state.notifications.pushEnabled;
      emailEnabled = state.notifications.emailEnabled;
      soundEnabled = state.notifications.soundEnabled;
    }

    return ExpansionTile(
      title: const Text('Notifications'),
      leading: const Icon(Icons.notifications),
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          subtitle: const Text('Receive notifications from the app'),
          value: notificationsEnabled,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
              UpdateNotificationSettingsEvent(
                enabled: value,
                pushEnabled: pushEnabled,
                emailEnabled: emailEnabled,
                soundEnabled: soundEnabled,
              ),
            );
          },
        ),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive push notifications'),
          value: pushEnabled && notificationsEnabled,
          onChanged: notificationsEnabled
              ? (value) {
                  context.read<SettingsBloc>().add(
                    UpdateNotificationSettingsEvent(
                      enabled: notificationsEnabled,
                      pushEnabled: value,
                      emailEnabled: emailEnabled,
                      soundEnabled: soundEnabled,
                    ),
                  );
                }
              : null,
        ),
        SwitchListTile(
          title: const Text('Email Notifications'),
          subtitle: const Text('Receive email notifications'),
          value: emailEnabled && notificationsEnabled,
          onChanged: notificationsEnabled
              ? (value) {
                  context.read<SettingsBloc>().add(
                    UpdateNotificationSettingsEvent(
                      enabled: notificationsEnabled,
                      pushEnabled: pushEnabled,
                      emailEnabled: value,
                      soundEnabled: soundEnabled,
                    ),
                  );
                }
              : null,
        ),
        SwitchListTile(
          title: const Text('Sound'),
          subtitle: const Text('Play sounds for notifications'),
          value: soundEnabled && notificationsEnabled,
          onChanged: notificationsEnabled
              ? (value) {
                  context.read<SettingsBloc>().add(
                    UpdateNotificationSettingsEvent(
                      enabled: notificationsEnabled,
                      pushEnabled: pushEnabled,
                      emailEnabled: emailEnabled,
                      soundEnabled: value,
                    ),
                  );
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildPrivacySection(SettingsState state) {
    bool profileVisible = true;
    bool locationVisible = false;
    bool activityVisible = true;

    if (state is SettingsLoaded) {
      profileVisible = state.privacy.profileVisible;
      locationVisible = state.privacy.locationVisible;
      activityVisible = state.privacy.activityVisible;
    }

    return ExpansionTile(
      title: const Text('Privacy & Data'),
      leading: const Icon(Icons.privacy_tip),
      children: [
        SwitchListTile(
          title: const Text('Public Profile'),
          subtitle: const Text('Make your profile visible to others'),
          value: profileVisible,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
              UpdatePrivacySettingsEvent(
                profileVisible: value,
                locationVisible: locationVisible,
                activityVisible: activityVisible,
              ),
            );
          },
        ),
        SwitchListTile(
          title: const Text('Location Services'),
          subtitle: const Text('Allow location-based features'),
          value: locationVisible,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
              UpdatePrivacySettingsEvent(
                profileVisible: profileVisible,
                locationVisible: value,
                activityVisible: activityVisible,
              ),
            );
          },
        ),
        SwitchListTile(
          title: const Text('Activity Sharing'),
          subtitle: const Text('Share your listening activity'),
          value: activityVisible,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
              UpdatePrivacySettingsEvent(
                profileVisible: profileVisible,
                locationVisible: locationVisible,
                activityVisible: value,
              ),
            );
          },
        ),
        SwitchListTile(
          title: const Text('Analytics'),
          subtitle: const Text('Help improve the app by sharing usage data'),
          value: _config.isAnalyticsEnabled(),
          onChanged: (value) async {
            await _config.setAnalyticsEnabled(value);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildServiceConnectionsSection() {
    return ExpansionTile(
      title: const Text('Service Connections'),
      leading: const Icon(Icons.link),
      children: [
        ListTile(
          title: const Text('Spotify'),
          subtitle: const Text('Connect your Spotify account'),
          leading: const Icon(Icons.music_note, color: Colors.green),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            context.read<SettingsBloc>().add(const ConnectSpotify());
          },
        ),
        ListTile(
          title: const Text('YouTube Music'),
          subtitle: const Text('Connect your YouTube Music account'),
          leading: const Icon(Icons.video_library, color: Colors.red),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            context.read<SettingsBloc>().add(const ConnectYTMusic());
          },
        ),
        ListTile(
          title: const Text('Last.fm'),
          subtitle: const Text('Connect your Last.fm account'),
          leading: const Icon(Icons.radio, color: Colors.red),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            context.read<SettingsBloc>().add(const ConnectLastFM());
          },
        ),
        ListTile(
          title: const Text('MyAnimeList'),
          subtitle: const Text('Connect your MyAnimeList account'),
          leading: const Icon(Icons.animation, color: Colors.blue),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            context.read<SettingsBloc>().add(const ConnectMAL());
          },
        ),
      ],
    );
  }

  Widget _buildDangerZoneSection() {
    return ExpansionTile(
      title: const Text('Danger Zone'),
      leading: const Icon(Icons.warning, color: Colors.red),
      children: [
        ListTile(
          title: const Text('Clear Cache'),
          subtitle: const Text('Clear all cached data'),
          leading: const Icon(Icons.clear_all, color: Colors.orange),
          onTap: _clearCache,
        ),
        ListTile(
          title: const Text('Reset Settings'),
          subtitle: const Text('Reset all settings to defaults'),
          leading: const Icon(Icons.restore, color: Colors.orange),
          onTap: _resetConfiguration,
        ),
        ListTile(
          title: const Text('Delete Account'),
          subtitle: const Text('Permanently delete your account'),
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          onTap: _showDeleteAccountDialog,
        ),
      ],
    );
  }

  void _showAccountSettings() {
    // Navigate to account settings or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account settings coming soon')),
    );
  }

  void _showDataSettings() {
    // Navigate to data settings or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data settings coming soon')),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear all cached data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Clear cache logic here
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. Your account and all associated data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Delete account logic here
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion not implemented yet'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
