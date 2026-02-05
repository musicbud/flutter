import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A customizable slider widget for audio and volume controls.
///
/// Supports:
/// - Custom colors and styling
/// - Labels and value display
/// - Icons on both ends
/// - Min/max value display
/// - Custom divisions
///
/// Example:
/// ```dart
/// ModernSlider(
///   value: volume,
///   min: 0,
///   max: 100,
///   onChanged: (value) => setVolume(value),
///   leadingIcon: Icons.volume_down,
///   trailingIcon: Icons.volume_up,
/// )
/// ```
class ModernSlider extends StatelessWidget {
  const ModernSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showValue = false,
    this.leadingIcon,
    this.trailingIcon,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool showValue;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? DesignSystem.primaryRed;
    final inactive = inactiveColor ?? DesignSystem.surfaceDark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: DesignSystem.bodySmall,
          ),
          const SizedBox(height: DesignSystem.spacingXS),
        ],
        Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 20,
                color: DesignSystem.textMuted,
              ),
              const SizedBox(width: DesignSystem.spacingSM),
            ],
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: active,
                  inactiveTrackColor: inactive,
                  thumbColor: thumbColor ?? active,
                  overlayColor: active.withAlpha(51),
                  trackHeight: 4.0,
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  label: label,
                  onChanged: onChanged,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: DesignSystem.spacingSM),
              Icon(
                trailingIcon,
                size: 20,
                color: DesignSystem.textMuted,
              ),
            ],
            if (showValue) ...[
              const SizedBox(width: DesignSystem.spacingSM),
              SizedBox(
                width: 40,
                child: Text(
                  '${((value / max) * 100).toInt()}%',
                  style: (DesignSystem.bodySmall).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Volume slider with volume icons
class VolumeSlider extends StatelessWidget {
  const VolumeSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.showValue = true,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final bool showValue;

  @override
  Widget build(BuildContext context) {
    return ModernSlider(
      value: value,
      onChanged: onChanged,
      min: 0,
      max: 100,
      leadingIcon: Icons.volume_down,
      trailingIcon: Icons.volume_up,
      showValue: showValue,
    );
  }
}

/// Audio seek slider with time display
class SeekSlider extends StatelessWidget {
  const SeekSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.onChanged,
    this.onChangeEnd,
  });

  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ModernSlider(
          value: position.inMilliseconds.toDouble(),
          min: 0,
          max: duration.inMilliseconds.toDouble(),
          onChanged: (value) => onChanged(Duration(milliseconds: value.toInt())),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingXS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: (DesignSystem.caption).copyWith(
                  color: DesignSystem.textMuted,
                ),
              ),
              Text(
                _formatDuration(duration),
                style: (DesignSystem.caption).copyWith(
                  color: DesignSystem.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}

/// Range slider for selecting a range of values
class ModernRangeSlider extends StatelessWidget {
  const ModernRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
  });

  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? DesignSystem.primaryRed;
    final inactive = inactiveColor ?? DesignSystem.surfaceDark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: DesignSystem.bodySmall,
          ),
          const SizedBox(height: DesignSystem.spacingXS),
        ],
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: active,
            inactiveTrackColor: inactive,
            thumbColor: active,
            overlayColor: active.withAlpha(51),
            trackHeight: 4.0,
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}