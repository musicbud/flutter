import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Modern bottom navigation bar with animations
///
/// Supports:
/// - Icon and label animations
/// - Badge indicators
/// - Custom colors and styles
/// - Floating action button integration
///
/// Example:
/// ```dart
/// ModernBottomNavBar(
///   currentIndex: 0,
///   onTap: (index) => navigateTo(index),
///   items: [
///     BottomNavItem(icon: Icons.home, label: 'Home'),
///     BottomNavItem(icon: Icons.search, label: 'Search'),
///     BottomNavItem(icon: Icons.library_music, label: 'Library'),
///   ],
/// )
/// ```
class ModernBottomNavBar extends StatelessWidget {
  const ModernBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.showLabels = true,
    this.elevation = 8.0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final bool showLabels;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: elevation,
      color: backgroundColor ?? theme.colorScheme.surface,
      child: SafeArea(
        child: Container(
          height: showLabels ? 72 : 56,
          padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingSM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              return _BottomNavButton(
                item: items[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
                selectedColor: selectedColor ?? DesignSystem.primary,
                unselectedColor: unselectedColor ?? DesignSystem.onSurfaceVariant,
                showLabel: showLabels,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.showLabel,
  });

  final BottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: DesignSystem.spacingXS),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isSelected && item.activeIcon != null ? item.activeIcon : item.icon,
                      color: isSelected ? selectedColor : unselectedColor,
                      size: 24,
                    ),
                  ),
                  if (item.badge != null && item.badge! > 0)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: DesignSystem.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          item.badge! > 99 ? '99+' : item.badge.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              if (showLabel) ...[
                const SizedBox(height: DesignSystem.spacingXS),
                AnimatedDefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                  duration: const Duration(milliseconds: 200),
                  child: Text(item.label),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom nav item data model
class BottomNavItem {
  const BottomNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
  });

  final IconData icon;
  final String label;
  final IconData? activeIcon;
  final int? badge;
}

/// Floating bottom nav bar with blur effect
class FloatingBottomNavBar extends StatelessWidget {
  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.margin,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: margin ?? const EdgeInsets.all(DesignSystem.spacingMD),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withAlpha(230),
            borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              return _BottomNavButton(
                item: items[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
                selectedColor: DesignSystem.primary,
                unselectedColor: DesignSystem.onSurfaceVariant,
                showLabel: false,
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Bottom nav bar with center FAB cutout
class BottomNavBarWithFAB extends StatelessWidget {
  const BottomNavBarWithFAB({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.onFabPressed,
    this.fabIcon = Icons.add,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;
  final VoidCallback onFabPressed;
  final IconData fabIcon;

  @override
  Widget build(BuildContext context) {
    final leftItems = items.take(items.length ~/ 2).toList();
    final rightItems = items.skip(items.length ~/ 2).toList();

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...List.generate(leftItems.length, (index) {
              return _BottomNavButton(
                item: leftItems[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
                selectedColor: DesignSystem.primary,
                unselectedColor: DesignSystem.onSurfaceVariant,
                showLabel: false,
              );
            }),
            const SizedBox(width: 48),
            ...List.generate(rightItems.length, (index) {
              final actualIndex = leftItems.length + index;
              return _BottomNavButton(
                item: rightItems[index],
                isSelected: currentIndex == actualIndex,
                onTap: () => onTap(actualIndex),
                selectedColor: DesignSystem.primary,
                unselectedColor: DesignSystem.onSurfaceVariant,
                showLabel: false,
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Bottom nav with music player mini bar
class BottomNavWithPlayer extends StatelessWidget {
  const BottomNavWithPlayer({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.playerBar,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;
  final Widget playerBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        playerBar,
        ModernBottomNavBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
        ),
      ],
    );
  }
}

/// Animated indicator bottom nav
class AnimatedIndicatorBottomNav extends StatelessWidget {
  const AnimatedIndicatorBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 8.0,
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: SizedBox(
          height: 72,
          child: Stack(
            children: [
              // Animated indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: (MediaQuery.of(context).size.width / items.length) * currentIndex,
                top: 0,
                width: MediaQuery.of(context).size.width / items.length,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: DesignSystem.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              // Nav items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  return _BottomNavButton(
                    item: items[index],
                    isSelected: currentIndex == index,
                    onTap: () => onTap(index),
                    selectedColor: DesignSystem.primary,
                    unselectedColor: DesignSystem.onSurfaceVariant,
                    showLabel: true,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact icon-only bottom nav
class CompactBottomNav extends StatelessWidget {
  const CompactBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  @override
  Widget build(BuildContext context) {
    return ModernBottomNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      showLabels: false,
      elevation: 0,
    );
  }
}