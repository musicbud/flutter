import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A rating display and input widget.
///
/// Supports:
/// - Star ratings (display and interactive)
/// - Numeric scores
/// - Half-star support
/// - Custom colors and sizes
///
/// Example:
/// ```dart
/// Rating(
///   rating: 4.5,
///   maxRating: 5,
///   onRatingChanged: (rating) => updateRating(rating),
/// )
/// ```
class Rating extends StatelessWidget {
  const Rating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 24.0,
    this.color,
    this.unratedColor,
    this.allowHalfRating = true,
    this.onRatingChanged,
    this.showCount = false,
    this.count,
  });

  final double rating;
  final int maxRating;
  final double size;
  final Color? color;
  final Color? unratedColor;
  final bool allowHalfRating;
  final ValueChanged<double>? onRatingChanged;
  final bool showCount;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final ratingColor = color ?? design?.designSystemColors.warning ?? Colors.amber;
    final unrated = unratedColor ?? design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxRating, (index) {
          return GestureDetector(
            onTap: onRatingChanged != null ? () => onRatingChanged!(index + 1.0) : null,
            child: Icon(
              _getIconForIndex(index),
              size: size,
              color: index < rating ? ratingColor : unrated,
            ),
          );
        }),
        if (showCount && count != null) ...[
          SizedBox(width: design?.designSystemSpacing.xs ?? 4),
          Text(
            '($count)',
            style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
              color: design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  IconData _getIconForIndex(int index) {
    final difference = rating - index;
    
    if (difference >= 1.0) {
      return Icons.star;
    } else if (difference >= 0.5 && allowHalfRating) {
      return Icons.star_half;
    } else {
      return Icons.star_border;
    }
  }
}

/// Compact rating display with numeric value
class CompactRating extends StatelessWidget {
  const CompactRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16.0,
    this.showNumeric = true,
  });

  final double rating;
  final int maxRating;
  final double size;
  final bool showNumeric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: size,
          color: design?.designSystemColors.warning ?? Colors.amber,
        ),
        if (showNumeric) ...[
          SizedBox(width: design?.designSystemSpacing.xs ?? 4),
          Text(
            rating.toStringAsFixed(1),
            style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Score display for numeric ratings
class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({
    super.key,
    required this.score,
    this.maxScore = 100,
    this.size = ScoreSize.medium,
    this.color,
    this.showMax = true,
  });

  final double score;
  final double maxScore;
  final ScoreSize size;
  final Color? color;
  final bool showMax;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final scoreColor = color ?? _getScoreColor(design, theme);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getPadding(design),
        vertical: _getPadding(design) * 0.5,
      ),
      decoration: BoxDecoration(
        color: scoreColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(_getBorderRadius(design)),
        border: Border.all(color: scoreColor, width: 1.5),
      ),
      child: Text(
        showMax ? '${score.toInt()}/${maxScore.toInt()}' : '${score.toInt()}',
        style: (_getTextStyle(design, theme) ?? const TextStyle()).copyWith(color: scoreColor),
      ),
    );
  }

  Color _getScoreColor(DesignSystemThemeExtension? design, ThemeData theme) {
    final percentage = score / maxScore;
    if (percentage >= 0.8) {
      return design?.designSystemColors.success ?? Colors.green;
    } else if (percentage >= 0.6) {
      return design?.designSystemColors.warning ?? Colors.amber;
    } else {
      return design?.designSystemColors.error ?? Colors.red;
    }
  }

  double _getPadding(DesignSystemThemeExtension? design) {
    switch (size) {
      case ScoreSize.small:
        return design?.designSystemSpacing.xs ?? 4;
      case ScoreSize.medium:
        return design?.designSystemSpacing.sm ?? 8;
      case ScoreSize.large:
        return design?.designSystemSpacing.md ?? 12;
    }
  }

  double _getBorderRadius(DesignSystemThemeExtension? design) {
    switch (size) {
      case ScoreSize.small:
        return design?.designSystemRadius.sm ?? 4;
      case ScoreSize.medium:
        return design?.designSystemRadius.md ?? 8;
      case ScoreSize.large:
        return design?.designSystemRadius.lg ?? 12;
    }
  }

  TextStyle? _getTextStyle(DesignSystemThemeExtension? design, ThemeData theme) {
    switch (size) {
      case ScoreSize.small:
        return (design?.designSystemTypography.caption ?? theme.textTheme.bodySmall)?.copyWith(
          fontWeight: FontWeight.w700,
        );
      case ScoreSize.medium:
        return (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
          fontWeight: FontWeight.w700,
        );
      case ScoreSize.large:
        return (design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
          fontWeight: FontWeight.w700,
        );
    }
  }
}

enum ScoreSize {
  small,
  medium,
  large,
}

/// Interactive rating bar
class RatingBar extends StatefulWidget {
  const RatingBar({
    super.key,
    this.initialRating = 0.0,
    this.maxRating = 5,
    required this.onRatingUpdate,
    this.size = 32.0,
    this.allowHalfRating = true,
  });

  final double initialRating;
  final int maxRating;
  final ValueChanged<double> onRatingUpdate;
  final double size;
  final bool allowHalfRating;

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  void _updateRating(double rating) {
    setState(() {
      _rating = rating;
    });
    widget.onRatingUpdate(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Rating(
      rating: _rating,
      maxRating: widget.maxRating,
      size: widget.size,
      allowHalfRating: widget.allowHalfRating,
      onRatingChanged: _updateRating,
    );
  }
}

/// Rating with label and count
class LabeledRating extends StatelessWidget {
  const LabeledRating({
    super.key,
    required this.rating,
    this.label,
    this.count,
    this.maxRating = 5,
  });

  final double rating;
  final String? label;
  final int? count;
  final int maxRating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall,
          ),
          SizedBox(height: design?.designSystemSpacing.xs ?? 4),
        ],
        Rating(
          rating: rating,
          maxRating: maxRating,
          showCount: count != null,
          count: count,
        ),
      ],
    );
  }
}
