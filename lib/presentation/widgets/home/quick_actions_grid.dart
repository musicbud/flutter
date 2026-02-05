import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
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
    // Debug logs for null check error
    print('QuickActionsGrid build: actions is null? ${actions == null}');
    print('QuickActionsGrid build: actions length: ${actions.length}');
    for (int i = 0; i < actions.length; i++) {
      print('QuickActionsGrid build: action[$i] is null? ${actions[i] == null}');
      print('QuickActionsGrid build: action[$i] onPressed is null? ${actions[i].onPressed == null}');
        }
  
    // Filter out null actions
    final validActions = actions.where((a) => a != null).toList() ?? [];
    if (validActions.isEmpty) {
      return const SizedBox.shrink();
    }

    if (crossAxisCount == 1) {
      // Single row layout
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
        child: Row(
          children: validActions.asMap().entries.map((entry) {
            final index = entry.key;
            final action = entry.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < validActions.length - 1 ? DesignSystem.spacingMD : 0,
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
          itemCount: validActions.length,
          itemBuilder: (context, index) {
            final action = validActions[index];
            return _buildActionButton(action);
          },
        ),
      );
    }
  }

  Widget _buildActionButton(QuickAction action) {
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
