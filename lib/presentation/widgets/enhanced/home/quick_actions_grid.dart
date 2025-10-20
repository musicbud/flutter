import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../common/modern_button.dart';

/// Model class representing a quick action button
class QuickAction {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const QuickAction({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });
}

/// A grid of quick action buttons for the home screen
/// 
/// Provides an engaging way to display primary actions with consistent styling.
/// Supports both grid and single-row layouts.
/// 
/// Example:
/// ```dart
/// QuickActionsGrid(
///   crossAxisCount: 2,
///   actions: [
///     QuickAction(
///       title: 'Find Buds',
///       icon: Icons.people,
///       onPressed: () => Navigator.push(...),
///       isPrimary: true,
///     ),
///     QuickAction(
///       title: 'Discover',
///       icon: Icons.explore,
///       onPressed: () => Navigator.push(...),
///     ),
///   ],
/// )
/// ```
class QuickActionsGrid extends StatelessWidget {
  final List<QuickAction> actions;
  final int crossAxisCount;
  final double spacing;

  const QuickActionsGrid({
    super.key,
    required this.actions,
    this.crossAxisCount = 2,
    this.spacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount == 1) {
      // Single row layout
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
        child: Row(
          children: actions.asMap().entries.map((entry) {
            final index = entry.key;
            final action = entry.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < actions.length - 1 ? DesignSystem.spacingMD : 0,
                ),
                child: _buildActionButton(action),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      // Grid layout
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 2.5,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildActionButton(action);
          },
        ),
      );
    }
  }

  Widget _buildActionButton(QuickAction action) {
    if (action.isPrimary) {
      return ModernButton(
        text: action.title,
        onPressed: action.onPressed,
        icon: action.icon,
        variant: ModernButtonVariant.primary,
        size: ModernButtonSize.large,
        isFullWidth: true,
      );
    } else {
      return ModernButton(
        text: action.title,
        onPressed: action.onPressed,
        icon: action.icon,
        variant: ModernButtonVariant.secondary,
        size: ModernButtonSize.large,
        isFullWidth: true,
      );
    }
  }
}
