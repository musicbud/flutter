import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// Different types of loading indicators
enum LoadingIndicatorType {
  circular,
  linear,
  dots,
  spinningDots,
  pulse,
}

/// A customizable loading indicator widget
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
    final color = widget.color ?? DesignSystem.primary;
    final messageStyle = widget.messageStyle ??
        DesignSystem.bodyMedium.copyWith(
          color: DesignSystem.onSurfaceVariant,
        );

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
            final opacity = (_animation.value - delay).clamp(0.0, 1.0);
            return Container(
              width: widget.size / 6,
              height: widget.size / 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: opacity),
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
          children: List.generate(8, (index) {
            final angle = (index * 45.0) * (3.14159 / 180.0);
            final radius = widget.size / 2;
            final x = radius * _animation.value * math.cos(angle);
            final y = radius * _animation.value * math.sin(angle);

            return Positioned(
              left: radius + x - widget.size / 12,
              top: radius + y - widget.size / 12,
              child: Container(
                width: widget.size / 6,
                height: widget.size / 6,
                decoration: BoxDecoration(
                  color: color,
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
        final scale = 0.5 + (_animation.value * 0.5);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

/// Convenience constructors for common loading indicators
class LoadingSpinner extends LoadingIndicator {
  const LoadingSpinner({
    super.key,
    super.size,
    super.color,
    super.message,
    super.messageStyle,
    super.padding,
  }) : super(type: LoadingIndicatorType.circular);
}

class LoadingDots extends LoadingIndicator {
  const LoadingDots({
    super.key,
    super.size,
    super.color,
    super.message,
    super.messageStyle,
    super.padding,
  }) : super(type: LoadingIndicatorType.dots);
}

class LoadingPulse extends LoadingIndicator {
  const LoadingPulse({
    super.key,
    super.size,
    super.color,
    super.message,
    super.messageStyle,
    super.padding,
  }) : super(type: LoadingIndicatorType.pulse);
}

/// Extension for easy loading indicator creation
extension LoadingIndicatorExtension on LoadingIndicatorType {
  Widget toLoadingIndicator({
    double size = 40.0,
    Color? color,
    Color? backgroundColor,
    double strokeWidth = 4.0,
    String? message,
    TextStyle? messageStyle,
    EdgeInsets padding = const EdgeInsets.all(16.0),
    Alignment alignment = Alignment.center,
  }) {
    return LoadingIndicator(
      type: this,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
      strokeWidth: strokeWidth,
      message: message,
      messageStyle: messageStyle,
      padding: padding,
      alignment: alignment,
    );
  }
}