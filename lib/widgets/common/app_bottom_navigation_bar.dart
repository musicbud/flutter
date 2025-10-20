import 'package:flutter/material.dart';
import 'dart:ui'; // Added for ImageFilter
import '../../../core/theme/design_system.dart';
import '../../navigation/navigation_config.dart';
import '../../navigation/navigation_constants.dart';
import '../../navigation/navigation_mixins.dart';
import '../../navigation/navigation_item.dart';

/// A modern, combined bottom navigation bar widget with dark mode styling
class AppBottomNavigationBar extends StatelessWidget with BaseNavigationMixin {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final double height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final bool enableBlur;
  final bool enableGradient;
  final NavigationConfig? config;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.height = NavigationConstants.defaultBottomNavBarHeight,
    this.margin,
    this.borderRadius,
    this.borderColor,
    this.enableBlur = true,
    this.enableGradient = true,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const NavigationConfig();
    final effectiveMargin = margin ?? effectiveConfig.margin ?? NavigationConstants.defaultMargin;
    final effectiveBorderRadius = borderRadius ?? effectiveConfig.borderRadius ?? BorderRadius.circular(NavigationConstants.defaultBorderRadius);

    return Container(
      height: height,
      margin: effectiveMargin,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(30),
        child: BackdropFilter(
          filter: enableBlur
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            decoration: BoxDecoration(
              gradient: enableGradient
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        backgroundColor ?? const Color.fromARGB(200, 20, 20, 20),
                        backgroundColor?.withValues(alpha: 0.8) ?? const Color.fromARGB(180, 15, 15, 15),
                      ],
                    )
                  : null,
              color: enableGradient ? null : (backgroundColor ?? const Color.fromARGB(200, 20, 20, 20)),
              border: borderColor != null
                  ? Border.all(
                      width: 1.5,
                      color: borderColor!.withValues(alpha: 0.3),
                    )
                  : Border.all(
                      width: 1.5,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
            ),
            child: _buildNavigationBar(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    final effectiveConfig = config ?? const NavigationConfig();
    final effectiveSelectedColor = selectedItemColor ??
        effectiveConfig.selectedColor ??
        DesignSystem.primaryContainer;
    final effectiveUnselectedColor = unselectedItemColor ??
        effectiveConfig.unselectedColor ??
        NavigationConstants.defaultUnselectedColor;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: elevation ?? effectiveConfig.elevation ?? NavigationConstants.defaultElevation,
      selectedItemColor: effectiveSelectedColor,
      unselectedItemColor: effectiveUnselectedColor,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
      items: _buildNavigationItems(),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return items.map((item) {
      return BottomNavigationBarItem(
        icon: _buildIcon(item.icon, false),
        activeIcon: _buildIcon(item.icon, true),
        label: item.label,
      );
    }).toList();
  }

  Widget _buildIcon(IconData icon, bool isActive) {
    final effectiveConfig = config ?? const NavigationConfig();
    final effectiveSelectedColor = selectedItemColor ??
        effectiveConfig.selectedColor ??
        DesignSystem.primaryContainer;
    final effectiveUnselectedColor = unselectedItemColor ??
        effectiveConfig.unselectedColor ??
        NavigationConstants.defaultUnselectedColor;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: getNavigationItemDecoration(
        isSelected: isActive,
        selectedColor: effectiveSelectedColor,
        borderRadius: 12,
      ),
      child: Icon(
        icon,
        size: isActive ? NavigationConstants.defaultActiveIconSize : NavigationConstants.defaultIconSize,
        color: isActive ? effectiveSelectedColor : effectiveUnselectedColor,
      ),
    );
  }
}

/// Alternative navigation bar with floating design
class FloatingBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double height;
  final EdgeInsetsGeometry? margin;

  const FloatingBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.height = 80,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == currentIndex;

          return _buildNavigationItem(item, index, isSelected);
        }).toList(),
      ),
    );
  }

  Widget _buildNavigationItem(NavigationItem item, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedItemColor ?? DesignSystem.primaryContainer)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (selectedItemColor ?? DesignSystem.primaryContainer).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: isSelected ? 28 : 24,
              color: isSelected
                  ? Colors.white
                  : (unselectedItemColor ?? Colors.white.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (unselectedItemColor ?? Colors.white.withValues(alpha: 0.6)),
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// Modern tab bar with animated indicators
class ModernTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<String> tabs;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ModernTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.tabs,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.height = 50,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return _buildTabItem(tabs[index], index, isSelected);
        },
      ),
    );
  }

  Widget _buildTabItem(String tab, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? DesignSystem.primaryContainer)
              : (backgroundColor ?? const Color.fromARGB(200, 20, 20, 20)),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? DesignSystem.primaryContainer)
                : Colors.white.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (selectedColor ?? DesignSystem.primaryContainer).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Text(
          tab,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (unselectedColor ?? Colors.white.withValues(alpha: 0.7)),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: isSelected ? 0.5 : 0.3,
          ),
        ),
      ),
    );
  }
}