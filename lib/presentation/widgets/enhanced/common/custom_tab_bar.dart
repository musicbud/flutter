import 'package:flutter/material.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        child: Row(
          children: [
            for (int i = 0; i < tabWidgets.length; i++) ...[
              tabWidgets[i],
              if (i < tabWidgets.length - 1) const SizedBox(width: DesignSystem.spacingSM),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingSM),
      child: Container(
        decoration: BoxDecoration(
          color: DesignSystem.surfaceContainer,
          borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
        ),
        padding: const EdgeInsets.all(DesignSystem.spacingXS),
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
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        child: Row(
          children: [
            for (int i = 0; i < tabWidgets.length; i++) ...[
              tabWidgets[i],
              if (i < tabWidgets.length - 1) const SizedBox(width: DesignSystem.spacingLG),
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
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        child: Row(
          children: [
            for (int i = 0; i < tabWidgets.length; i++) ...[
              tabWidgets[i],
              if (i < tabWidgets.length - 1) const SizedBox(width: DesignSystem.spacingSM),
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

    switch (style) {
      case TabBarStyle.pills:
        return Material(
          color: isSelected
              ? DesignSystem.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingMD,
                vertical: DesignSystem.spacingSM,
              ),
              child: _buildContent(theme),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingSM,
                  vertical: DesignSystem.spacingMD,
                ),
                child: _buildContent(theme),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              color: isSelected
                  ? DesignSystem.primary
                  : Colors.transparent,
            ),
          ],
        );
      case TabBarStyle.filled:
        return Material(
          color: isSelected
              ? DesignSystem.primary.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingMD,
                vertical: DesignSystem.spacingSM,
              ),
              child: _buildContent(theme),
            ),
          ),
        );
    }
  }

  Widget _buildContent(ThemeData theme) {
    final textColor = _getTextColor(theme);

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
          style: (DesignSystem.bodyMedium).copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        if (badge != null && badge! > 0) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: DesignSystem.error,
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

  Color _getTextColor(ThemeData theme) {
    if (style == TabBarStyle.pills && isSelected) {
      return Colors.white;
    }

    if (isSelected) {
      return DesignSystem.primary;
    }

    return DesignSystem.onSurfaceVariant;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(tabs.length, (index) {
        final isSelected = currentIndex == index;
        return Material(
          color: isSelected
              ? DesignSystem.primary.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          child: InkWell(
            onTap: () => onTabChanged(index),
            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingMD,
                vertical: DesignSystem.spacingMD,
              ),
              child: Row(
                children: [
                  if (tabIcons != null && index < tabIcons!.length) ...[
                    Icon(
                      tabIcons![index],
                      size: 20,
                      color: isSelected
                          ? DesignSystem.primary
                          : DesignSystem.onSurfaceVariant,
                    ),
                    const SizedBox(width: DesignSystem.spacingSM),
                  ],
                  Text(
                    tabs[index],
                    style: (DesignSystem.bodyMedium).copyWith(
                      color: isSelected
                          ? DesignSystem.primary
                          : DesignSystem.onSurfaceVariant,
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