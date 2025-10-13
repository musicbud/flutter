import 'package:flutter/material.dart';
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
  Widget buildIcon(BuildContext context) {
    if (icon == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: getDesignSystemColors(context).surfaceContainer,
        borderRadius: BorderRadius.circular(getDesignSystemRadius(context).xl),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: getDesignSystemColors(context).onSurfaceVariant,
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        if (title != null) ...[
          Text(
            title!,
            style: getDesignSystemTypography(context).titleMedium.copyWith(
              color: getDesignSystemColors(context).onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        // Message
        if (message != null) ...[
          const SizedBox(height: 8.0),
          Text(
            message!,
            style: getDesignSystemTypography(context).bodyMedium.copyWith(
              color: getDesignSystemColors(context).onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  @override
  Widget buildAction(BuildContext context) {
    if (actionText != null && actionCallback != null) {
      return ElevatedButton(
        onPressed: actionCallback,
        style: ElevatedButton.styleFrom(
          backgroundColor: getDesignSystemColors(context).primary,
          foregroundColor: getDesignSystemColors(context).onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getDesignSystemRadius(context).md),
          ),
        ),
        child: Text(
          actionText!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}