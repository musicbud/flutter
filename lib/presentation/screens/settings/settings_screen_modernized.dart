import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/settings/settings_bloc.dart';
import '../../../blocs/settings/settings_event.dart';
import '../../../blocs/settings/settings_state.dart';
import '../../widgets/imported/index.dart';

class ModernizedSettingsScreen extends StatefulWidget {
  const ModernizedSettingsScreen({super.key});

  @override
  State<ModernizedSettingsScreen> createState() => _ModernizedSettingsScreenState();
}

class _ModernizedSettingsScreenState extends State<ModernizedSettingsScreen>
    with LoadingStateMixin, ErrorStateMixin, TickerProviderStateMixin {
  
  final TextEditingController _languageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _languageController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setLoadingState(LoadingState.loading);
    context.read<SettingsBloc>().add(LoadSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsError) {
          setError(
            state.message,
            type: ErrorType.server,
            retryable: true,
          );
          setLoadingState(LoadingState.error);
        } else if (state is SettingsSaved) {
          setLoadingState(LoadingState.loaded);
          _showSuccessMessage('Settings saved successfully');
        } else if (state is ServiceConnected) {
          _showSuccessMessage('${state.service} connected successfully');
        } else if (state is ServiceConnectionError) {
          _showErrorMessage('Failed to connect ${state.service}: ${state.error}');
        } else if (state is LikesUpdated) {
          _showSuccessMessage('Likes synced from ${state.service}');
        } else if (state is LikesUpdateError) {
          _showErrorMessage('Failed to sync likes from ${state.service}: ${state.error}');
        } else if (state is ServiceLoginUrlReceived) {
          _showInfoMessage('Login URL received for ${state.service}');
          // TODO: Implement URL opening in browser or webview
        } else if (state is ServiceLoginUrlError) {
          _showErrorMessage('Failed to get login URL for ${state.service}: ${state.error}');
        } else if (state is SettingsLoaded) {
          setLoadingState(LoadingState.loaded);
          _languageController.text = state.languageCode;
        }
      },
      builder: (context, state) {
        return AppScaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _initializeData,
                tooltip: 'Refresh Settings',
              ),
            ],
          ),
          body: ResponsiveLayout(
            builder: (context, breakpoint) {
              switch (breakpoint) {
                case ResponsiveBreakpoint.xs:
                case ResponsiveBreakpoint.sm:
                  return _buildMobileLayout(state);
                case ResponsiveBreakpoint.md:
                  return _buildTabletLayout(state);
                case ResponsiveBreakpoint.lg:
                case ResponsiveBreakpoint.xl:
                  return _buildDesktopLayout(state);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(SettingsState state) {
    return buildLoadingState(
      context: context,
      loadedWidget: _buildSettingsContent(state),
      loadingWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading your settings...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      errorWidget: buildDefaultErrorWidget(
        context: context,
        onRetry: _initializeData,
      ),
    );
  }

  Widget _buildTabletLayout(SettingsState state) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: buildLoadingState(
            context: context,
            loadedWidget: _buildSettingsContent(state),
            loadingWidget: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading your settings...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            errorWidget: buildDefaultErrorWidget(
              context: context,
              onRetry: _initializeData,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildSettingsSidebar(state),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(SettingsState state) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: _buildSettingsSidebar(state),
        ),
        Expanded(
          child: buildLoadingState(
            context: context,
            loadedWidget: _buildSettingsContent(state),
            loadingWidget: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading your settings...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            errorWidget: buildDefaultErrorWidget(
              context: context,
              onRetry: _initializeData,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSidebar(SettingsState state) {
    return ModernCard(
      variant: ModernCardVariant.outlined,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings Overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSidebarItem(Icons.notifications, 'Notifications', 'Push, Email, Sound'),
            _buildSidebarItem(Icons.privacy_tip, 'Privacy', 'Profile, Location, Activity'),
            _buildSidebarItem(Icons.palette, 'Appearance', 'Theme, Language'),
            _buildSidebarItem(Icons.link, 'Connections', 'Music Services'),
            _buildSidebarItem(Icons.sync, 'Data Sync', 'Import Likes'),
            const SizedBox(height: 24),
            if (state is SettingsLoaded)
              ModernButton(
                text: 'Save All Settings',
                variant: ModernButtonVariant.text,
                onPressed: () {
                  context.read<SettingsBloc>().add(SaveSettingsEvent());
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(SettingsState state) {
    if (state is! SettingsLoaded) {
      return EmptyState(
        icon: Icons.settings,
        title: 'Settings Unavailable',
        message: 'Unable to load settings. Please try again.',
        actionText: 'Retry',
        actionCallback: _initializeData,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _initializeData();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifications Section
            _buildNotificationsSection(state),
            const SizedBox(height: 24),
            
            // Privacy Section
            _buildPrivacySection(state),
            const SizedBox(height: 24),
            
            // Appearance Section
            _buildAppearanceSection(state),
            const SizedBox(height: 24),
            
            // Service Connections Section
            _buildServiceConnectionsSection(),
            const SizedBox(height: 24),
            
            // Data Synchronization Section
            _buildDataSyncSection(),
            const SizedBox(height: 24),
            
            // Language Section
            _buildLanguageSection(state),
            const SizedBox(height: 32),
            
            // Save Button (Mobile only)
            if (_isMobileLayout())
              SizedBox(
                width: double.infinity,
                child: ModernButton(
                  text: 'Save Settings',
                  onPressed: () {
                    context.read<SettingsBloc>().add(SaveSettingsEvent());
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection(SettingsLoaded state) {
    return ModernCard(
      variant: ModernCardVariant.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Notifications',
          ),
          const SizedBox(height: 16),
          _buildNotificationSwitch(
            'Push Notifications',
            'Receive push notifications',
            state.notifications.pushEnabled,
            (value) {
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
          _buildNotificationSwitch(
            'Email Notifications',
            'Receive email notifications',
            state.notifications.emailEnabled,
            (value) {
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
          _buildNotificationSwitch(
            'Sound',
            'Play sound for notifications',
            state.notifications.soundEnabled,
            (value) {
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
    );
  }

  Widget _buildPrivacySection(SettingsLoaded state) {
    return ModernCard(
      variant: ModernCardVariant.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Privacy',
          ),
          const SizedBox(height: 16),
          _buildNotificationSwitch(
            'Profile Visibility',
            'Make your profile visible to others',
            state.privacy.profileVisible,
            (value) {
              context.read<SettingsBloc>().add(
                UpdatePrivacySettingsEvent(
                  profileVisible: value,
                  locationVisible: state.privacy.locationVisible,
                  activityVisible: state.privacy.activityVisible,
                ),
              );
            },
          ),
          _buildNotificationSwitch(
            'Location Visibility',
            'Share your location with others',
            state.privacy.locationVisible,
            (value) {
              context.read<SettingsBloc>().add(
                UpdatePrivacySettingsEvent(
                  profileVisible: state.privacy.profileVisible,
                  locationVisible: value,
                  activityVisible: state.privacy.activityVisible,
                ),
              );
            },
          ),
          _buildNotificationSwitch(
            'Activity Visibility',
            'Show your activity to others',
            state.privacy.activityVisible,
            (value) {
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
    );
  }

  Widget _buildAppearanceSection(SettingsLoaded state) {
    return ModernCard(
      variant: ModernCardVariant.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Appearance',
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text('Current: ${state.theme.capitalize()}'),
            leading: const Icon(Icons.brightness_6),
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
    );
  }

  Widget _buildLanguageSection(SettingsLoaded state) {
    return ModernCard(
      variant: ModernCardVariant.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Language',
          ),
          const SizedBox(height: 16),
          ModernInputField(
            labelText: 'Language Code',
            hintText: 'e.g., en, es, fr',
            controller: _languageController,
            onChanged: (value) {
              context.read<SettingsBloc>().add(UpdateLanguageEvent(value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceConnectionsSection() {
    return ModernCard(
      variant: ModernCardVariant.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Service Connections',
          ),
          const SizedBox(height: 16),
          _buildServiceConnectionTile('Spotify', 'spotify', Icons.music_note),
          const SizedBox(height: 12),
          _buildServiceConnectionTile('YouTube Music', 'ytmusic', Icons.music_video),
          const SizedBox(height: 12),
          _buildServiceConnectionTile('Last.fm', 'lastfm', Icons.radio),
          const SizedBox(height: 12),
          _buildServiceConnectionTile('MyAnimeList', 'mal', Icons.favorite),
        ],
      ),
    );
  }

  Widget _buildDataSyncSection() {
    return ModernCard(
      variant: ModernCardVariant.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Data Synchronization',
          ),
          const SizedBox(height: 16),
          _buildDataSyncTile(
            'Sync Likes from Spotify',
            'Update your liked tracks from Spotify',
            Icons.music_note,
            () {
              context.read<SettingsBloc>().add(const UpdateLikes(
                service: 'spotify',
                token: '', // Token should be retrieved from storage
              ));
              _showInfoMessage('Starting Spotify likes sync...');
            },
          ),
          const SizedBox(height: 12),
          _buildDataSyncTile(
            'Sync Likes from YouTube Music',
            'Update your liked tracks from YouTube Music',
            Icons.music_video,
            () {
              context.read<SettingsBloc>().add(const UpdateLikes(
                service: 'ytmusic',
                token: '', // Token should be retrieved from storage
              ));
              _showInfoMessage('Starting YouTube Music likes sync...');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _buildServiceConnectionTile(String serviceName, String serviceKey, IconData icon) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon),
        title: Text('Connect $serviceName'),
        subtitle: Text('Link your $serviceName account'),
        trailing: ModernButton(
          text: 'Connect',
          variant: ModernButtonVariant.text,
          onPressed: () {
            context.read<SettingsBloc>().add(GetServiceLoginUrl(serviceKey));
          },
        ),
      ),
    );
  }

  Widget _buildDataSyncTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: ModernButton(
          text: 'Sync',
          variant: ModernButtonVariant.text,
          onPressed: onPressed,
        ),
      ),
    );
  }

  bool _isMobileLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 768; // Less than md breakpoint
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showInfoMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  VoidCallback? get retryLoading => _initializeData;

  @override
  VoidCallback? get onLoadingStarted => () {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  };

  @override
  VoidCallback? get onLoadingCompleted => () {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings loaded!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  };
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}