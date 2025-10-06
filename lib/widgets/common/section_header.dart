import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../base/base_section_header.dart';

/// A reusable section header widget with title and optional action button
class SectionHeader extends BaseSectionHeader {
  const SectionHeader({
    super.key,
    required super.title,
    super.actionText,
    super.onActionPressed,
    super.padding,
    super.titleStyle,
    super.actionStyle,
    super.showDivider,
    super.dividerColor,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
  });

  @override
  Widget _buildTitle(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Expanded(
      child: Text(
        title,
        style: titleStyle ??
            appTheme.typography.headlineH6.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  @override
  Widget _buildAction(BuildContext context) {
    if (actionText != null && onActionPressed != null) {
      final appTheme = AppTheme.of(context);

      return TextButton(
        onPressed: onActionPressed,
        child: Text(
          actionText!,
          style: actionStyle ??
              appTheme.typography.bodySmall.copyWith(
                color: appTheme.colors.primaryRed,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}