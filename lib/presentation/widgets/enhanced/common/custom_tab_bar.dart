import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Modern tab bar with customizable styles
///
/// Supports:
/// - Multiple visual styles (pills, underline, filled)
/// - Icon support
/// - Badge indicators
/// - Scrollable tabs
///
/// Example:
/// ```dart
/// ModernTabBar(
///   tabs: ['Music', 'Podcasts', 'Radio'],
///   currentIndex: selectedTab,
///   onTabChanged: (index) => setState(() => selectedTab = index),
/// )
/// ```
class ModernTabBar extends StatelessWidget {
  const ModernTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.style = TabBarStyle.pills,
    this.isScrollable = false,
    this.tabIcons,
    this.badges,
  });

  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final TabBarStyle style;
  final bool isScrollable;
  final List<IconData>? tabIcons;
  final List<int?>? badges;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case TabBarStyle.pills:
        return _PillTabBar(
          tabs: tabs,
          currentIndex: currentIndex,
          onTabChanged: onTabChanged,
          isScrollable: isScrollable,
          tabIcons: tabIcons,
          badges: badges,
        );
      case TabBarStyle.underline:
        return _UnderlineTabBar(
          tabs: tabs,
          currentIndex: currentIndex,
          onTabChanged: onTabChanged,
          isScrollable: isScrollable,
          tabIcons: tabIcons,
          badges: badges,
        );
      case TabBarStyle.filled:
        return _FilledTabBar(
          tabs: tabs,
          currentIndex: currentIndex,
          onTabChanged: onTabChanged,
          isScrollable: isScrollable,
          tabIcons: tabIcons,
          badges: badges,
        );
    }
  }
}

enum TabBarStyle {
  pills,
  underline,
  filled,
}

class _PillTabBar extends StatelessWidget {
  const _PillTabBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    required this.isScrollable,
    this.tabIcons,
    this.badges,
  });

  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final bool isScrollable;
  final List<IconData>? tabIcons;
  final List<int?>? badges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    final tabWidgets = List.generate(tabs.length, (index) {
      return _TabButton(
        label: tabs[index],
        isSelected: currentIndex == index,
        onTap: () => onTabChanged(index),
        icon: tabIcons != null && index < tabIcons!.length ? tabIcons![index] : null,
        badge: badges != null && index < badges!.length ? badges![index] : null,
        style: TabBarStyle.pills,
      );
    });

    if (isScrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: design?.designSystemSpacing.md ?? 12),
        child: Row(
          children: [
            for (int i = 0; i < tabWidgets.length; i++) ...[
              tabWidgets[i],
              if (i < tabWidgets.length - 1) SizedBox(width: design?.designSystemSpacing.sm ?? 8),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(design?.designSystemSpacing.sm ?? 8),
      child: Container(
        decoration: BoxDecoration(
          color: design?.designSystemColors.surfaceContainer ?? theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(design?.designSystemRadius.lg ?? 12),
        ),
        padding: EdgeInsets.all(design?.designSystemSpacing.xs ?? 4),
        child: Row(
          children: [
            for (int i = 0; i < tabWidgets.length; i++)
              Expanded(child: tabWidgets[i]),
          ],
        ),
      ),
    );
  }
}

class _UnderlineTabBar extends StatelessWidget {
  const _UnderlineTabBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    required this.isScrollable,
    this.tabIcons,
    this.badges,
  });

  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final bool isScrollable;
  final List<IconData>? tabIcons;
  final List<int?>? badges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    final tabWidgets = List.generate(tabs.length, (index) {
      return _TabButton(
        label: tabs[index],
        isSelected: currentIndex == index,
        onTap: () => onTabChanged(index),
        icon: tabIcons != null && index < tabIcons!.length ? tabIcons![index] : null,
        badge: badges != null && index < badges!.length ? badges![index] : null,
        style: TabBarStyle.underline,
      );
    });

    if (isScrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: design?.designSystemSpacing.md ?? 12),
        child: Row(
          children: [
            for (int i = 0; i < tabWidgets.length; i++) ...[
              tabWidgets[i],
              if (i < tabWidgets.length - 1) SizedBox(width: design?.designSystemSpacing.lg ?? 16),
            ],
          ],
        ),
      );
    }

    return Row(
      children: [
        for (int i = 0; i < tabWidgets.length; i++)
          Expanded(child: tabWidgets[i]),
      ],
    );
  }
}

class _FilledTabBar extends StatelessWidget {
  const _FilledTabBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    required this.isScrollable,
    this.tabIcons,
    this.badges,
  });

  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final bool isScrollable;
  final List<IconData>? tabIcons;
  final List<int?>? badges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    final tabWidgets = List.generate(tabs.length, (index) {
      return _TabButton(
        label: tabs[index],
        isSelected: currentIndex == index,
        onTap: () => onTabChanged(index),
        icon: tabIcons != null && index < tabIcons!.length ? tabIcons![index] : null,
        badge: badges != null && index < badges!.length ? badges![index] : null,
        style: TabBarStyle.filled,
      );
    });

    if (isScrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: design?.designSystemSpacing.md ?? 12),
        child: Row(
          children: [
            for (int i = 0; i < tabWidgets.length; i++) ...[
              tabWidgets[i],
              if (i < tabWidgets.length - 1) SizedBox(width: design?.designSystemSpacing.sm ?? 8),
            ],
          ],
        ),
      );
    }

    return Row(
      children: [
        for (int i = 0; i < tabWidgets.length; i++)
          Expanded(child: tabWidgets[i]),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.style,
    this.icon,
    this.badge,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final TabBarStyle style;
  final IconData? icon;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    switch (style) {
      case TabBarStyle.pills:
        return Material(
          color: isSelected
              ? (design?.designSystemColors.primary ?? theme.colorScheme.primary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: design?.designSystemSpacing.md ?? 12,
                vertical: design?.designSystemSpacing.sm ?? 8,
              ),
              child: _buildContent(theme, design),
            ),
          ),
        );
      case TabBarStyle.underline:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: design?.designSystemSpacing.sm ?? 8,
                  vertical: design?.designSystemSpacing.md ?? 12,
                ),
                child: _buildContent(theme, design),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              color: isSelected
                  ? (design?.designSystemColors.primary ?? theme.colorScheme.primary)
                  : Colors.transparent,
            ),
          ],
        );
      case TabBarStyle.filled:
        return Material(
          color: isSelected
              ? (design?.designSystemColors.primary ?? theme.colorScheme.primary).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: design?.designSystemSpacing.md ?? 12,
                vertical: design?.designSystemSpacing.sm ?? 8,
              ),
              child: _buildContent(theme, design),
            ),
          ),
        );
    }
  }

  Widget _buildContent(ThemeData theme, DesignSystemThemeExtension? design) {
    final textColor = _getTextColor(theme, design);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: (design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        if (badge != null && badge! > 0) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: design?.designSystemColors.error ?? theme.colorScheme.error,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badge! > 99 ? '99+' : badge.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getTextColor(ThemeData theme, DesignSystemThemeExtension? design) {
    if (style == TabBarStyle.pills && isSelected) {
      return Colors.white;
    }

    if (isSelected) {
      return design?.designSystemColors.primary ?? theme.colorScheme.primary;
    }

    return design?.designSystemColors.onSurfaceVariant ?? theme.colorScheme.onSurfaceVariant;
  }
}

/// Vertical tab bar for side navigation
class VerticalTabBar extends StatelessWidget {
  const VerticalTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.tabIcons,
  });

  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final List<IconData>? tabIcons;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(tabs.length, (index) {
        final isSelected = currentIndex == index;
        return Material(
          color: isSelected
              ? (design?.designSystemColors.primary ?? theme.colorScheme.primary).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
          child: InkWell(
            onTap: () => onTabChanged(index),
            borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: design?.designSystemSpacing.md ?? 12,
                vertical: design?.designSystemSpacing.md ?? 12,
              ),
              child: Row(
                children: [
                  if (tabIcons != null && index < tabIcons!.length) ...[
                    Icon(
                      tabIcons![index],
                      size: 20,
                      color: isSelected
                          ? (design?.designSystemColors.primary ?? theme.colorScheme.primary)
                          : (design?.designSystemColors.onSurfaceVariant ?? theme.colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(width: design?.designSystemSpacing.sm ?? 8),
                  ],
                  Text(
                    tabs[index],
                    style: (design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
                      color: isSelected
                          ? (design?.designSystemColors.primary ?? theme.colorScheme.primary)
                          : (design?.designSystemColors.onSurfaceVariant ?? theme.colorScheme.onSurfaceVariant),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
