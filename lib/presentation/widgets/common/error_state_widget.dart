import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DesignSystem.spacingLG),
      decoration: BoxDecoration(
        color: DesignSystem.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        border: Border.all(color: DesignSystem.error.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: DesignSystem.error, size: 24),
              const SizedBox(width: DesignSystem.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DesignSystem.bodyLarge.copyWith(
                        color: DesignSystem.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: DesignSystem.bodyMedium.copyWith(
                        color: DesignSystem.error.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: DesignSystem.spacingMD),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: DesignSystem.primary,
                  textStyle: DesignSystem.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Retry'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class LoadingStateWidget extends StatelessWidget {
  final String message;
  final double size;

  const LoadingStateWidget({
    super.key,
    this.message = 'Loading...',
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DesignSystem.spacingLG),
      decoration: BoxDecoration(
        color: DesignSystem.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(DesignSystem.primary),
            ),
          ),
          const SizedBox(width: DesignSystem.spacingMD),
          Text(
            message,
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DesignSystem.spacingLG),
      decoration: BoxDecoration(
        color: DesignSystem.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: DesignSystem.onSurface.withOpacity(0.6), size: 24),
              const SizedBox(width: DesignSystem.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DesignSystem.bodyLarge.copyWith(
                        color: DesignSystem.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: DesignSystem.bodySmall.copyWith(
                        color: DesignSystem.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onAction != null && actionText != null) ...[
            const SizedBox(height: DesignSystem.spacingMD),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: DesignSystem.primary,
                  textStyle: DesignSystem.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(actionText!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}