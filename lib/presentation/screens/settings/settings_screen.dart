import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/settings/settings_bloc.dart';
import '../../../blocs/settings/settings_event.dart';
import '../../../blocs/settings/settings_state.dart';
import '../../../core/theme/design_system.dart';
import '../../../presentation/widgets/common/modern_button.dart';
import '../../../presentation/widgets/common/modern_input_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _languageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadSettingsEvent());
  }

  @override
  void dispose() {
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: DesignSystem.headlineSmall,
        ),
        backgroundColor: DesignSystem.surface,
        elevation: 0,
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: DesignSystem.error,
              ),
            );
          } else if (state is SettingsSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings saved successfully'),
                backgroundColor: DesignSystem.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsLoaded) {
            _languageController.text = state.languageCode;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(DesignSystem.spacingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Notifications'),
                  _buildNotificationSettings(state),
                  const SizedBox(height: DesignSystem.spacingXL),

                  _buildSectionHeader('Privacy'),
                  _buildPrivacySettings(state),
                  const SizedBox(height: DesignSystem.spacingXL),

                  _buildSectionHeader('Appearance'),
                  _buildThemeSettings(state),
                  const SizedBox(height: DesignSystem.spacingXL),

                  _buildSectionHeader('Language'),
                  _buildLanguageSettings(state),
                  const SizedBox(height: DesignSystem.spacingXL),

                  ModernButton(
                    text: 'Save Settings',
                    onPressed: () {
                      context.read<SettingsBloc>().add(SaveSettingsEvent());
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Failed to load settings'));
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
      child: Text(
        title,
        style: DesignSystem.headlineSmall.copyWith(
          color: DesignSystem.primary,
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(SettingsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingLG),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive push notifications'),
              value: state.notifications.pushEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdateNotificationSettingsEvent(
                    enabled: state.notifications.enabled,
                    pushEnabled: value,
                    emailEnabled: state.notifications.emailEnabled,
                    soundEnabled: state.notifications.soundEnabled,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive email notifications'),
              value: state.notifications.emailEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdateNotificationSettingsEvent(
                    enabled: state.notifications.enabled,
                    pushEnabled: state.notifications.pushEnabled,
                    emailEnabled: value,
                    soundEnabled: state.notifications.soundEnabled,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Sound'),
              subtitle: const Text('Play sound for notifications'),
              value: state.notifications.soundEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdateNotificationSettingsEvent(
                    enabled: state.notifications.enabled,
                    pushEnabled: state.notifications.pushEnabled,
                    emailEnabled: state.notifications.emailEnabled,
                    soundEnabled: value,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySettings(SettingsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingLG),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Profile Visibility'),
              subtitle: const Text('Make your profile visible to others'),
              value: state.privacy.profileVisible,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdatePrivacySettingsEvent(
                    profileVisible: value,
                    locationVisible: state.privacy.locationVisible,
                    activityVisible: state.privacy.activityVisible,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Location Visibility'),
              subtitle: const Text('Share your location with others'),
              value: state.privacy.locationVisible,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdatePrivacySettingsEvent(
                    profileVisible: state.privacy.profileVisible,
                    locationVisible: value,
                    activityVisible: state.privacy.activityVisible,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Activity Visibility'),
              subtitle: const Text('Show your activity to others'),
              value: state.privacy.activityVisible,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdatePrivacySettingsEvent(
                    profileVisible: state.privacy.profileVisible,
                    locationVisible: state.privacy.locationVisible,
                    activityVisible: value,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSettings(SettingsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingLG),
        child: Column(
          children: [
            ListTile(
              title: const Text('Theme'),
              subtitle: Text('Current: ${state.theme}'),
              trailing: DropdownButton<String>(
                value: state.theme,
                items: ['light', 'dark', 'system']
                    .map((theme) => DropdownMenuItem(
                          value: theme,
                          child: Text(theme.capitalize()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(UpdateThemeEvent(value));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSettings(SettingsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingLG),
        child: ModernInputField(
          hintText: 'Language Code (e.g., en, es, fr)',
          controller: _languageController,
          onChanged: (value) {
            context.read<SettingsBloc>().add(UpdateLanguageEvent(value));
          },
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}