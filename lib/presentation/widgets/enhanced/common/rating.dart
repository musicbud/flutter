import 'package:flutter/material.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

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
    final ratingColor = color ?? DesignSystem.warning;
    final unrated = unratedColor ?? DesignSystem.textMuted;

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
          const SizedBox(width: DesignSystem.spacingXS),
          Text(
            '($count)',
            style: (DesignSystem.bodySmall).copyWith(
              color: DesignSystem.textMuted,
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star,
          size: 16.0,
          color: DesignSystem.warning,
        ),
        if (showNumeric) ...[
          const SizedBox(width: DesignSystem.spacingXS),
          Text(
            rating.toStringAsFixed(1),
            style: (DesignSystem.bodySmall).copyWith(
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
    final scoreColor = color ?? _getScoreColor(theme);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getPadding(),
        vertical: _getPadding() * 0.5,
      ),
      decoration: BoxDecoration(
        color: scoreColor.withAlpha(25),
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        border: Border.all(color: scoreColor, width: 1.5),
      ),
      child: Text(
        showMax ? '${score.toInt()}/${maxScore.toInt()}' : '${score.toInt()}',
        style: (_getTextStyle(theme) ?? const TextStyle()).copyWith(color: scoreColor),
      ),
    );
  }

  Color _getScoreColor(ThemeData theme) {
    final percentage = score / maxScore;
    if (percentage >= 0.8) {
      return DesignSystem.success;
    } else if (percentage >= 0.6) {
      return DesignSystem.warning;
    } else {
      return DesignSystem.error;
    }
  }

  double _getPadding() {
    switch (size) {
      case ScoreSize.small:
        return DesignSystem.spacingXS;
      case ScoreSize.medium:
        return DesignSystem.spacingSM;
      case ScoreSize.large:
        return DesignSystem.spacingMD;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case ScoreSize.small:
        return DesignSystem.radiusSM;
      case ScoreSize.medium:
        return DesignSystem.radiusMD;
      case ScoreSize.large:
        return DesignSystem.radiusLG;
    }
  }

  TextStyle? _getTextStyle(ThemeData theme) {
    switch (size) {
      case ScoreSize.small:
        return (DesignSystem.caption).copyWith(
          fontWeight: FontWeight.w700,
        );
      case ScoreSize.medium:
        return (DesignSystem.bodySmall).copyWith(
          fontWeight: FontWeight.w700,
        );
      case ScoreSize.large:
        return (DesignSystem.bodyMedium).copyWith(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: DesignSystem.bodySmall,
          ),
          const SizedBox(height: DesignSystem.spacingXS),
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