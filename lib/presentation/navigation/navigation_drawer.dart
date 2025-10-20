import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../../../navigation/navigation_items.dart';
import 'main_navigation.dart';
import '../../../utils/logger.dart';
import '../../../core/error/error_handler.dart';

/// Custom navigation drawer for the main screen
class MainNavigationDrawer extends StatelessWidget {
  final MainNavigationController navigationController;
  final VoidCallback? onDrawerItemTap;

  const MainNavigationDrawer({
    super.key,
    required this.navigationController,
    this.onDrawerItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: DesignSystem.primary, // Primary red color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.menu,
                      color: DesignSystem.onPrimary,
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'MusicBud',
                      style: TextStyle(
                        color: DesignSystem.onPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '🍔 HAMBURGER MENU OPENED! 🍔',
                  style: TextStyle(
                    color: DesignSystem.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'All Test Pages Available Below ↓',
                  style: TextStyle(
                    color: Color(0xB3FFFFFF), // 70% opacity white
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Main Navigation Section
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: DesignSystem.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: DesignSystem.primary,
                width: 2,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🍔 MAIN NAVIGATION 🍔',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DesignSystem.primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap any item below to navigate',
                  style: TextStyle(
                    fontSize: 12,
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ...mainNavigationItems.map((item) => ListTile(
            leading: Icon(item.icon),
            title: Text(item.label),
            onTap: () {
              logger.d('Drawer navigation item tapped: ${item.label}');
              Navigator.pop(context);
              final index = mainNavigationItems.indexOf(item);
              ErrorHandler.logNavigationEvent(
                ModalRoute.of(context)?.settings.name ?? 'unknown',
                item.route,
                method: 'drawer'
              );
              navigationController.navigateToPage(index, context);
              onDrawerItemTap?.call();
            },
          )),

          // Secondary Navigation Section
          if (secondaryNavigationItems.isNotEmpty) ...[
            const Divider(),

            // All Secondary Pages
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'All Pages',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: DesignSystem.onSurfaceVariant,
                ),
              ),
            ),
            ...secondaryNavigationItems.map((item) => ListTile(
              leading: Icon(item.icon, size: 20),
              title: Text(item.label, style: const TextStyle(fontSize: 14)),
              onTap: () {
                logger.d('Drawer secondary navigation item tapped: ${item.label}');
                Navigator.pop(context);
                ErrorHandler.logNavigationEvent(
                  ModalRoute.of(context)?.settings.name ?? 'unknown',
                  item.route,
                  method: 'drawer'
                );
                Navigator.pushNamed(context, item.route);
                onDrawerItemTap?.call();
              },
            )),
          ],
        ],
      ),
    );
  }
}