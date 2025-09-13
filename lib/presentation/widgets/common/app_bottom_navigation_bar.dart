import 'package:flutter/material.dart';
import 'dart:ui'; // Added for ImageFilter

/// A modern, combined bottom navigation bar widget with dark mode styling
class AppBottomNavigationBar extends StatelessWidget {
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

  const AppBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.height = 90,
    this.margin,
    this.borderRadius,
    this.borderColor,
    this.enableBlur = true,
    this.enableGradient = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(30),
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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: elevation ?? 0,
      selectedItemColor: selectedItemColor ?? const Color(0xFFFF6B8F),
      unselectedItemColor: unselectedItemColor ?? Colors.white.withValues(alpha: 0.6),
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
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive
            ? (selectedItemColor ?? const Color(0xFFFF6B8F)).withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(
                color: (selectedItemColor ?? const Color(0xFFFF6B8F)).withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: Icon(
        icon,
        size: isActive ? 26 : 24,
        color: isActive
            ? (selectedItemColor ?? const Color(0xFFFF6B8F))
            : (unselectedItemColor ?? Colors.white.withValues(alpha: 0.6)),
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
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.height = 80,
    this.margin,
  }) : super(key: key);

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
              ? (selectedItemColor ?? const Color(0xFFFF6B8F))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (selectedItemColor ?? const Color(0xFFFF6B8F)).withValues(alpha: 0.4),
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

/// Data class for navigation items
class NavigationItem {
  final IconData icon;
  final String label;
  final WidgetBuilder pageBuilder;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.pageBuilder,
  });
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
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.tabs,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.height = 50,
    this.margin,
  }) : super(key: key);

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
              ? (selectedColor ?? const Color(0xFFFF6B8F))
              : (backgroundColor ?? const Color.fromARGB(200, 20, 20, 20)),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? const Color(0xFFFF6B8F))
                : Colors.white.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (selectedColor ?? const Color(0xFFFF6B8F)).withValues(alpha: 0.3),
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