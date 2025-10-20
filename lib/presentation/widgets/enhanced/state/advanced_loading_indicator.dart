import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Different types of loading indicators
enum LoadingIndicatorType {
  circular,
  linear,
  dots,
  spinningDots,
  pulse,
}

/// An advanced loading indicator widget with multiple animation styles.
///
/// Supports:
/// - Circular progress indicator
/// - Linear progress bar
/// - Animated dots
/// - Spinning dots animation
/// - Pulsing animation
/// - Optional message text
/// - Customizable colors and sizes
///
/// Example:
/// ```dart
/// LoadingIndicator(
///   type: LoadingIndicatorType.dots,
///   size: 50.0,
///   message: 'Loading your music...',
/// )
/// ```
class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({
    super.key,
    this.type = LoadingIndicatorType.circular,
    this.size = 40.0,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4.0,
    this.message,
    this.messageStyle,
    this.padding = const EdgeInsets.all(16.0),
    this.alignment = Alignment.center,
  });

  /// The type of loading indicator
  final LoadingIndicatorType type;

  /// Size of the indicator
  final double size;

  /// Color of the indicator
  final Color? color;

  /// Background color for certain types
  final Color? backgroundColor;

  /// Stroke width for circular indicators
  final double strokeWidth;

  /// Optional message to display
  final String? message;

  /// Style for the message text
  final TextStyle? messageStyle;

  /// Padding around the indicator
  final EdgeInsets padding;

  /// Alignment of the indicator
  final Alignment alignment;

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final color = widget.color ?? design?.designSystemColors.primaryRed ?? theme.primaryColor;
    final messageStyle = widget.messageStyle ??
        design?.designSystemTypography.bodyMedium.copyWith(
          color: design.designSystemColors.textMuted,
        ) ??
        theme.textTheme.bodyMedium;

    return Align(
      alignment: widget.alignment,
      child: Padding(
        padding: widget.padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: _buildIndicator(color),
            ),
            if (widget.message != null) ...[
              const SizedBox(height: 16),
              Text(
                widget.message!,
                style: messageStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(Color color) {
    switch (widget.type) {
      case LoadingIndicatorType.circular:
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: widget.strokeWidth,
        );

      case LoadingIndicatorType.linear:
        return LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: widget.backgroundColor ?? color.withValues(alpha: 0.2),
        );

      case LoadingIndicatorType.dots:
        return _buildDotsIndicator(color);

      case LoadingIndicatorType.spinningDots:
        return _buildSpinningDotsIndicator(color);

      case LoadingIndicatorType.pulse:
        return _buildPulseIndicator(color);
    }
  }

  Widget _buildDotsIndicator(Color color) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = (_animation.value - delay).clamp(0.0, 1.0);
            final scale = math.sin(value * math.pi);
            
            return Container(
              width: widget.size / 6,
              height: widget.size / 6 * scale.clamp(0.3, 1.0),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: scale.clamp(0.3, 1.0)),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSpinningDotsIndicator(Color color) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(8, (index) {
            final angle = (index * 45.0 + _animation.value * 360) * (math.pi / 180.0);
            final radius = widget.size / 3;
            final x = radius * math.cos(angle);
            final y = radius * math.sin(angle);
            
            // Fade effect based on position
            final opacity = (math.sin(angle + _animation.value * 2 * math.pi) + 1) / 2;

            return Transform.translate(
              offset: Offset(x, y),
              child: Container(
                width: widget.size / 8,
                height: widget.size / 8,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: opacity * 0.8 + 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPulseIndicator(Color color) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final scale = 0.5 + (math.sin(_animation.value * 2 * math.pi) * 0.25) + 0.25;
        final opacity = 1.0 - (math.sin(_animation.value * 2 * math.pi) * 0.3);
        
        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: opacity * 0.6),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

// Convenience constructors for common loading indicators

/// Circular loading spinner
class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({
    super.key,
    this.size = 40.0,
    this.color,
    this.message,
    this.messageStyle,
    this.padding = const EdgeInsets.all(16.0),
  });

  final double size;
  final Color? color;
  final String? message;
  final TextStyle? messageStyle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      type: LoadingIndicatorType.circular,
      size: size,
      color: color,
      message: message,
      messageStyle: messageStyle,
      padding: padding,
    );
  }
}

/// Animated dots loading indicator
class LoadingDots extends StatelessWidget {
  const LoadingDots({
    super.key,
    this.size = 40.0,
    this.color,
    this.message,
    this.messageStyle,
    this.padding = const EdgeInsets.all(16.0),
  });

  final double size;
  final Color? color;
  final String? message;
  final TextStyle? messageStyle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      type: LoadingIndicatorType.dots,
      size: size,
      color: color,
      message: message,
      messageStyle: messageStyle,
      padding: padding,
    );
  }
}

/// Pulsing circle loading indicator
class LoadingPulse extends StatelessWidget {
  const LoadingPulse({
    super.key,
    this.size = 40.0,
    this.color,
    this.message,
    this.messageStyle,
    this.padding = const EdgeInsets.all(16.0),
  });

  final double size;
  final Color? color;
  final String? message;
  final TextStyle? messageStyle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      type: LoadingIndicatorType.pulse,
      size: size,
      color: color,
      message: message,
      messageStyle: messageStyle,
      padding: padding,
    );
  }
}

/// Spinning dots loading indicator
class LoadingSpinningDots extends StatelessWidget {
  const LoadingSpinningDots({
    super.key,
    this.size = 40.0,
    this.color,
    this.message,
    this.messageStyle,
    this.padding = const EdgeInsets.all(16.0),
  });

  final double size;
  final Color? color;
  final String? message;
  final TextStyle? messageStyle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      type: LoadingIndicatorType.spinningDots,
      size: size,
      color: color,
      message: message,
      messageStyle: messageStyle,
      padding: padding,
    );
  }
}
