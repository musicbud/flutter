import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';

class AppBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const AppBackButton({
    super.key,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: color ?? DesignSystem.primary,
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}
