import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../core/theme/design_system.dart';
import '../../theme/app_theme.dart';
import '../../../navigation/navigation_config.dart';
import '../../../navigation/navigation_constants.dart';
import '../../../navigation/navigation_mixins.dart';
import '../../../navigation/navigation_items.dart';
import '../../../navigation/navigation_item.dart';

class AppNavigationDrawer extends StatelessWidget with BaseNavigationMixin {
  final UserProfile? userProfile;
  final void Function(String)? onNavigate;
  final NavigationConfig? config;

  const AppNavigationDrawer({
    super.key,
    this.userProfile,
    this.onNavigate,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          _buildNavItems(context),
          if (userProfile?.isAdmin ?? false) _buildAdminItems(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final effectiveConfig = config ?? const NavigationConfig();

    return DrawerHeader(
      decoration: BoxDecoration(
        color: effectiveConfig.selectedColor ?? DesignSystem.success,
        image: const DecorationImage(
          image: AssetImage('assets/dark_map_bg.jpg'),
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: userProfile?.avatarUrl != null
                ? NetworkImage(userProfile!.avatarUrl!)
                : const AssetImage('assets/user_avatar.jpg') as ImageProvider,
          ),
          const SizedBox(height: NavigationConstants.defaultItemSpacing),
          Text(
            userProfile?.displayName ?? 'Welcome',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          Text(
            userProfile?.email ?? 'Guest',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItems(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Column(
      children: [
        // Main navigation items from the centralized navigation items
        ...mainNavigationItems.map((item) => _buildNavItemFromNavigationItem(
          context: context,
          item: item,
        )),
        const Divider(),
        // Additional navigation items (Settings, etc.)
        _buildNavItem(
          context: context,
          icon: NavigationConstants.settingsIcon,
          title: 'Settings',
          route: NavigationConstants.settingsRoute,
        ),
      ],
    );
  }

  Widget _buildNavItemFromNavigationItem({
    required BuildContext context,
    required NavigationItem item,
  }) {
    final appTheme = AppTheme.of(context);
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final itemRoute = '/${mainNavigationItems.indexOf(item)}'; // Use index as route
    final isSelected = currentRoute == itemRoute;

    return ListTile(
      leading: Icon(
        item.icon,
        color: isSelected
            ? appTheme.colors.primary
            : Colors.white,
      ),
      title: Text(
        item.label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isSelected
              ? appTheme.colors.primary
              : Colors.white,
        ),
      ),
      selected: isSelected,
      selectedColor: appTheme.colors.primary,
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (onNavigate != null) {
          onNavigate!(itemRoute);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.pageBuilder?.call(context) ?? const SizedBox.shrink()),
          );
        }
      },
    );
  }

  Widget _buildAdminItems(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        _buildNavItem(
          context: context,
          icon: Icons.admin_panel_settings_outlined,
          title: 'Admin Dashboard',
          route: '/admin',
        ),
        _buildNavItem(
          context: context,
          icon: Icons.group_outlined,
          title: 'User Management',
          route: '/admin/users',
        ),
        _buildNavItem(
          context: context,
          icon: Icons.analytics_outlined,
          title: 'Analytics',
          route: '/admin/analytics',
        ),
        _buildNavItem(
          context: context,
          icon: Icons.dashboard_outlined,
          title: 'Channel Management',
          route: '/admin/channels',
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
  }) {
    final appTheme = AppTheme.of(context);
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? appTheme.colors.primary
            : Colors.white,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isSelected
              ? appTheme.colors.primary
              : Colors.white,
        ),
      ),
      selected: isSelected,
      selectedColor: appTheme.colors.primary,
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (onNavigate != null) {
          onNavigate!(route);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
