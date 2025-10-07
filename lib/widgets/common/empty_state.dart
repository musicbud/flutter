import 'package:flutter/material.dart';
import 'modern_button.dart';
import '../base/base_state_display.dart';

/// A reusable empty state widget that supports theming
class EmptyState extends BaseStateDisplay {
  const EmptyState({
    super.key,
    super.title,
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
  Widget _buildAction(BuildContext context) {
    return const SizedBox.shrink();
  }
}