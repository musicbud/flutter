import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class MusicBudBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MusicBudBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MusicBudColors.backgroundTertiary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: MusicBudColors.backgroundPrimary.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MusicBudSpacing.lg,
            vertical: MusicBudSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
                isSelected: currentIndex == 0,
              ),
              _buildNavItem(
                icon: Icons.search_rounded,
                label: 'Search',
                index: 1,
                isSelected: currentIndex == 1,
              ),
              _buildNavItem(
                icon: Icons.group_rounded,
                label: 'Buds',
                index: 2,
                isSelected: currentIndex == 2,
              ),
              _buildNavItem(
                icon: Icons.chat_bubble_rounded,
                label: 'Chat',
                index: 3,
                isSelected: currentIndex == 3,
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                index: 4,
                isSelected: currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: MusicBudAnimations.fast,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: MusicBudSpacing.md,
          vertical: MusicBudSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? MusicBudColors.primaryRed.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            MusicBudSpacing.radiusLg,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: MusicBudAnimations.fast,
              child: Icon(
                icon,
                color: isSelected 
                    ? MusicBudColors.primaryRed
                    : MusicBudColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: MusicBudAnimations.fast,
              style: MusicBudTypography.bodySmall.copyWith(
                color: isSelected 
                    ? MusicBudColors.primaryRed
                    : MusicBudColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}