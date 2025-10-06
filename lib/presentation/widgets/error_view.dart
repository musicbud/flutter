import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/design_system.dart';
import 'common/modern_button.dart';
import 'base/base_state_display.dart';

/// A reusable error view widget that supports theming
class ErrorView extends BaseStateDisplay {
  const ErrorView({
    super.key,
    super.title,
    super.message,
    super.icon,
    super.actionCallback,
    super.actionText,
    super.iconSize,
    super.padding,
    super.backgroundColor,
    super.centerContent,
    VoidCallback? onRetry,
  });

  @override
  Widget _buildIcon(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(DesignSystem.spacingLG),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
      ),
      child: Icon(
        icon ?? Icons.error_outline,
        size: iconSize,
        color: DesignSystem.error,
      ),
    );
  }

  @override
  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        if (title != null) ...[
          Text(
            title!,
            style: DesignSystem.titleMedium.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        // Message
        if (message != null) ...[
          SizedBox(height: DesignSystem.spacingMD),
          Text(
            message!,
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurfaceVariant,
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
        icon: Icons.refresh,
        size: ModernButtonSize.medium,
      );
    }

    return const SizedBox.shrink();
  }
}
