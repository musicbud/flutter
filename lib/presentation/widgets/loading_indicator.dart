import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// A custom loading indicator widget with consistent styling
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;
  final bool showMessage;

  const LoadingIndicator({
    Key? key,
    this.size = 50.0,
    this.color,
    this.message,
    this.showMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppConstants.primaryColor,
            ),
            backgroundColor: AppConstants.surfaceColor,
          ),
        ),
        if (showMessage && message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: AppConstants.captionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// A loading indicator with pulsing animation
class PulsingLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final String? message;
  final bool showMessage;

  const PulsingLoadingIndicator({
    Key? key,
    this.size = 50.0,
    this.color,
    this.message,
    this.showMessage = false,
  }) : super(key: key);

  @override
  State<PulsingLoadingIndicator> createState() => _PulsingLoadingIndicatorState();
}

class _PulsingLoadingIndicatorState extends State<PulsingLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color ?? AppConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            );
          },
        ),
        if (widget.showMessage && widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: AppConstants.captionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// A loading indicator with shimmer effect
class ShimmerLoadingIndicator extends StatefulWidget {
  final double width;
  final double height;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoadingIndicator({
    Key? key,
    this.width = 200.0,
    this.height = 20.0,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  State<ShimmerLoadingIndicator> createState() => _ShimmerLoadingIndicatorState();
}

class _ShimmerLoadingIndicatorState extends State<ShimmerLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 2),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor ?? AppConstants.surfaceColor,
                widget.highlightColor ?? AppConstants.primaryColor.withValues(alpha: 0.5),
                widget.baseColor ?? AppConstants.surfaceColor,
              ],
              stops: [
                0.0,
                _animation.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A loading indicator for music-related content
class MusicLoadingIndicator extends StatelessWidget {
  final String? message;
  final bool showMessage;

  const MusicLoadingIndicator({
    Key? key,
    this.message,
    this.showMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: AppConstants.primaryColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.music_note,
            color: AppConstants.primaryColor,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
            backgroundColor: AppConstants.surfaceColor,
          ),
        ),
        if (showMessage && message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: AppConstants.captionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
