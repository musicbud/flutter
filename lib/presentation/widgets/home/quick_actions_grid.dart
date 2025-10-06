import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../common/modern_button.dart';

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
    final appTheme = AppTheme.of(context);

    if (crossAxisCount == 1) {
      // Single row layout
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
        child: Row(
          children: actions.asMap().entries.map((entry) {
            final index = entry.key;
            final action = entry.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < actions.length - 1 ? appTheme.spacing.md : 0,
                ),
                child: _buildActionButton(action, appTheme),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      // Grid layout
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
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
            return _buildActionButton(action, appTheme);
          },
        ),
      );
    }
  }

  Widget _buildActionButton(QuickAction action, AppTheme appTheme) {
    if (action.isPrimary) {
      return PrimaryButton(
        text: action.title,
        onPressed: action.onPressed,
        icon: action.icon,
        size: ModernButtonSize.large,
        isFullWidth: true,
      );
    } else {
      return SecondaryButton(
        text: action.title,
        onPressed: action.onPressed,
        icon: action.icon,
        size: ModernButtonSize.large,
        isFullWidth: true,
      );
    }
  }
}