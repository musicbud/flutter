import 'package:flutter/material.dart';

/// A reusable bottom navigation bar widget with consistent styling
class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final double height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? borderColor;

  const AppBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.height = 80,
    this.margin,
    this.borderRadius,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      decoration: BoxDecoration(
        backgroundBlendMode: BlendMode.srcOver,
        color: backgroundColor ?? const Color.fromARGB(121, 59, 59, 59),
        border: borderColor != null
            ? Border.all(
                width: 0.5,
                color: borderColor!,
              )
            : null,
        borderRadius: borderRadius ?? BorderRadius.circular(25),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(25),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(2, 0, 0, 0),
          elevation: elevation ?? 0,
          selectedItemColor: selectedItemColor ?? const Color(0xFFFF6B8F),
          unselectedItemColor: unselectedItemColor ?? const Color.fromARGB(255, 255, 255, 255),
          items: items,
        ),
      ),
    );
  }
}