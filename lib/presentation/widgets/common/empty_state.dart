import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'modern_button.dart';
import '../base/base_state_display.dart';

/// A reusable empty state widget that supports theming
class EmptyState extends BaseStateDisplay {
  const EmptyState({
    super.key,
    required super.title,
    super.message,
    super.icon,
    super.actionText,
    super.actionCallback,
    super.iconSize,
    super.padding,
    super.backgroundColor,
    super.centerContent,
  });

  @override
  Widget _buildIcon(BuildContext context) {
    final appTheme = AppTheme.of(context);

    if (icon == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(appTheme.spacing.lg),
      decoration: BoxDecoration(
        color: appTheme.colors.surfaceDark,
        borderRadius: BorderRadius.circular(appTheme.radius.xl),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: appTheme.colors.textMuted,
      ),
    );
  }

  @override
  Widget _buildContent(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          title!,
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        // Message
        if (message != null) ...[
          SizedBox(height: appTheme.spacing.md),
          Text(
            message!,
            style: appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  @override
  Widget _buildAction(BuildContext context) {
    if (actionText != null && actionCallback != null) {
      return PrimaryButton(
        text: actionText!,
        onPressed: actionCallback,
        size: ModernButtonSize.medium,
      );
    }

    return const SizedBox.shrink();
  }
}