import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../../../widgets/base/base_section_header.dart';

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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Expanded(
      child: Text(
        title,
        style: titleStyle ??
            design.designSystemTypography.headlineSmall.copyWith(
              color: design.designSystemColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  @override
  Widget buildAction(BuildContext context) {
    if (actionText != null && onActionPressed != null) {
      final theme = Theme.of(context);
      final design = theme.extension<DesignSystemThemeExtension>()!;

      return TextButton(
        onPressed: onActionPressed,
        child: Text(
          actionText!,
          style: actionStyle ??
              design.designSystemTypography.bodySmall.copyWith(
                color: design.designSystemColors.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}