import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Progress bar variants
enum ProgressVariant {
  linear,
  circular,
}

/// A customizable progress indicator widget.
///
/// Supports:
/// - Linear and circular variants
/// - Determinate and indeterminate modes
/// - Custom colors
/// - Size customization
/// - Labels and percentage display
///
/// Example:
/// ```dart
/// ModernProgressBar(
///   value: 0.65,
///   variant: ProgressVariant.linear,
///   showLabel: true,
///   label: 'Downloading...',
/// )
/// ```
class ModernProgressBar extends StatelessWidget {
  const ModernProgressBar({
    super.key,
    this.value,
    this.variant = ProgressVariant.linear,
    this.color,
    this.backgroundColor,
    this.height = 8.0,
    this.strokeWidth = 4.0,
    this.showLabel = false,
    this.label,
    this.showPercentage = false,
  });

  final double? value;
  final ProgressVariant variant;
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final double strokeWidth;
  final bool showLabel;
  final String? label;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? DesignSystem.primaryRed;
    final bgColor = backgroundColor ??
        DesignSystem.surfaceDark.withAlpha(77);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && label != null) ...[
          Text(
            label!,
            style: DesignSystem.bodySmall,
          ),
          const SizedBox(height: DesignSystem.spacingXS),
        ],
        Row(
          children: [
            Expanded(
              child: _buildProgress(progressColor, bgColor),
            ),
            if (showPercentage && value != null) ...[
              const SizedBox(width: DesignSystem.spacingSM),
              Text(
                '${(value! * 100).toInt()}%',
                style: (DesignSystem.bodySmall).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildProgress(Color progressColor, Color bgColor) {
    switch (variant) {
      case ProgressVariant.linear:
        return SizedBox(
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: value,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: bgColor,
            ),
          ),
        );
      case ProgressVariant.circular:
        return Center(
          child: SizedBox(
            width: height * 4,
            height: height * 4,
            child: CircularProgressIndicator(
              value: value,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: bgColor,
              strokeWidth: strokeWidth,
            ),
          ),
        );
    }
  }
}

/// Linear progress bar
class LinearProgress extends StatelessWidget {
  const LinearProgress({
    super.key,
    this.value,
    this.color,
    this.height = 8.0,
    this.showPercentage = false,
  });

  final double? value;
  final Color? color;
  final double height;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    return ModernProgressBar(
      value: value,
      variant: ProgressVariant.linear,
      color: color,
      height: height,
      showPercentage: showPercentage,
    );
  }
}

/// Circular progress indicator
class CircularProgress extends StatelessWidget {
  const CircularProgress({
    super.key,
    this.value,
    this.color,
    this.size = 40.0,
    this.strokeWidth = 4.0,
  });

  final double? value;
  final Color? color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          value: value,
          valueColor: color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

/// Stepped progress indicator
class SteppedProgress extends StatelessWidget {
  const SteppedProgress({
    super.key,
    required this.steps,
    required this.currentStep,
    this.color,
    this.inactiveColor,
    this.spacing = 8.0,
  });

  final int steps;
  final int currentStep;
  final Color? color;
  final Color? inactiveColor;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = color ?? DesignSystem.primaryRed;
    final inactive = inactiveColor ??
        DesignSystem.surfaceDark;

    return Row(
      children: List.generate(
        steps,
        (index) {
          final isActive = index <= currentStep;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < steps - 1 ? spacing : 0,
              ),
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: isActive ? activeColor : inactive,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Progress with icon and text
class ProgressWithStatus extends StatelessWidget {
  const ProgressWithStatus({
    super.key,
    required this.value,
    required this.title,
    this.subtitle,
    this.icon,
    this.color,
  });

  final double value;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceDark,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        border: Border.all(
          color: DesignSystem.textMuted.withAlpha(51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 24,
                  color: color ?? DesignSystem.primaryRed,
                ),
                const SizedBox(width: DesignSystem.spacingSM),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DesignSystem.titleSmall,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: DesignSystem.spacingXS),
                      Text(
                        subtitle!,
                        style: (DesignSystem.bodySmall).copyWith(
                          color: DesignSystem.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: (DesignSystem.titleSmall).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignSystem.spacingSM),
          LinearProgress(
            value: value,
            color: color,
          ),
        ],
      ),
    );
  }
}

/// Segmented progress bar with multiple values
class SegmentedProgress extends StatelessWidget {
  const SegmentedProgress({
    super.key,
    required this.segments,
    this.height = 8.0,
    this.spacing = 2.0,
  });

  final List<ProgressSegment> segments;
  final double height;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Row(
          children: List.generate(
            segments.length,
            (index) {
              final segment = segments[index];
              return Expanded(
                flex: (segment.value * 100).toInt(),
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < segments.length - 1 ? spacing : 0,
                  ),
                  color: segment.color,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A segment in a segmented progress bar
class ProgressSegment {
  const ProgressSegment({
    required this.value,
    required this.color,
    this.label,
  });

  final double value;
  final Color color;
  final String? label;
}