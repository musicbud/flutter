import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
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
  Widget buildTitle(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        style: titleStyle ??
            DesignSystem.headlineSmall.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  @override
  Widget buildAction(BuildContext context) {
    if (actionText != null && onActionPressed != null) {
      return TextButton(
        onPressed: onActionPressed,
        child: Text(
          actionText!,
          style: actionStyle ??
              DesignSystem.bodySmall.copyWith(
                color: DesignSystem.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}