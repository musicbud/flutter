import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

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
    final appTheme = AppTheme.of(context);
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: color ?? appTheme.colors.primary,
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}
