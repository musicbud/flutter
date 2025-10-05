import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../blocs/settings/settings_event.dart';
import '../../blocs/settings/settings_state.dart';
import '../widgets/loading_indicator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    context.read<SettingsBloc>().add(SettingsRequested());
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsFailure) {
            _showErrorSnackBar(state.error);
          }
        },
        builder: (context, state) {
          if (state is SettingsInitial) {
            _loadSettings();
            return const LoadingIndicator();
          }

          if (state is SettingsLoading) {
            return const LoadingIndicator();
          }

          if (state is SettingsLoaded) {
            return ListView(
              children: [
                _buildNotificationSettings(state.notifications),
                const Divider(),
                _buildPrivacySettings(state.privacy),
                const Divider(),
                _buildThemeSettings(state.theme),
                const Divider(),
                _buildLanguageSettings(state.languageCode),
              ],
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }

  Widget _buildNotificationSettings(NotificationSettings settings) {
    return ExpansionTile(
      leading: const Icon(Icons.notifications),
      title: const Text('Notifications'),
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          value: settings.enabled,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  NotificationSettingsUpdated(
                    enabled: value,
                    pushEnabled: settings.pushEnabled,
                    emailEnabled: settings.emailEnabled,
                    soundEnabled: settings.soundEnabled,
                  ),
                );
          },
        ),
        SwitchListTile(
          title: const Text('Push Notifications'),
          value: settings.pushEnabled,
          onChanged: settings.enabled
              ? (value) {
                  context.read<SettingsBloc>().add(
                        NotificationSettingsUpdated(
                          enabled: settings.enabled,
                          pushEnabled: value,
                          emailEnabled: settings.emailEnabled,
                          soundEnabled: settings.soundEnabled,
                        ),
                      );
                }
              : null,
        ),
        SwitchListTile(
          title: const Text('Email Notifications'),
          value: settings.emailEnabled,
          onChanged: settings.enabled
              ? (value) {
                  context.read<SettingsBloc>().add(
                        NotificationSettingsUpdated(
                          enabled: settings.enabled,
                          pushEnabled: settings.pushEnabled,
                          emailEnabled: value,
                          soundEnabled: settings.soundEnabled,
                        ),
                      );
                }
              : null,
        ),
        SwitchListTile(
          title: const Text('Sound'),
          value: settings.soundEnabled,
          onChanged: settings.enabled
              ? (value) {
                  context.read<SettingsBloc>().add(
                        NotificationSettingsUpdated(
                          enabled: settings.enabled,
                          pushEnabled: settings.pushEnabled,
                          emailEnabled: settings.emailEnabled,
                          soundEnabled: value,
                        ),
                      );
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildPrivacySettings(PrivacySettings settings) {
    return ExpansionTile(
      leading: const Icon(Icons.lock),
      title: const Text('Privacy'),
      children: [
        SwitchListTile(
          title: const Text('Profile Visibility'),
          subtitle: const Text('Make your profile visible to others'),
          value: settings.profileVisible,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  PrivacySettingsUpdated(
                    profileVisible: value,
                    locationVisible: settings.locationVisible,
                    activityVisible: settings.activityVisible,
                  ),
                );
          },
        ),
        SwitchListTile(
          title: const Text('Location Visibility'),
          subtitle: const Text('Share your location with others'),
          value: settings.locationVisible,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  PrivacySettingsUpdated(
                    profileVisible: settings.profileVisible,
                    locationVisible: value,
                    activityVisible: settings.activityVisible,
                  ),
                );
          },
        ),
        SwitchListTile(
          title: const Text('Activity Visibility'),
          subtitle: const Text('Share your music activity with others'),
          value: settings.activityVisible,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  PrivacySettingsUpdated(
                    profileVisible: settings.profileVisible,
                    locationVisible: settings.locationVisible,
                    activityVisible: value,
                  ),
                );
          },
        ),
      ],
    );
  }

  Widget _buildThemeSettings(String currentTheme) {
    return ListTile(
      leading: const Icon(Icons.palette),
      title: const Text('Theme'),
      trailing: DropdownButton<String>(
        value: currentTheme,
        items: const [
          DropdownMenuItem(
            value: 'light',
            child: Text('Light'),
          ),
          DropdownMenuItem(
            value: 'dark',
            child: Text('Dark'),
          ),
          DropdownMenuItem(
            value: 'system',
            child: Text('System'),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            context.read<SettingsBloc>().add(ThemeSettingUpdated(value));
          }
        },
      ),
    );
  }

  Widget _buildLanguageSettings(String currentLanguage) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      trailing: DropdownButton<String>(
        value: currentLanguage,
        items: const [
          DropdownMenuItem(
            value: 'en',
            child: Text('English'),
          ),
          DropdownMenuItem(
            value: 'es',
            child: Text('Español'),
          ),
          DropdownMenuItem(
            value: 'fr',
            child: Text('Français'),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            context.read<SettingsBloc>().add(LanguageSettingUpdated(value));
          }
        },
      ),
    );
  }
}
